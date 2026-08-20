import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/post_card.dart';
import '../../../profile/data/models/posts_model.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/data/users_api.dart';

class _FeedData {
  final List<PostModel> posts;
  final Map<int, UserModel> usersById;
  final Map<int, int> commentCountByPostId;

  _FeedData(this.posts, this.usersById, this.commentCountByPostId);
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final UsersApi _usersApi = UsersApi();
  late Future<_FeedData> _feedFuture;
  final TextEditingController _searchController = TextEditingController();
  String _query = "";

  @override
  void initState() {
    super.initState();
    _feedFuture = _loadFeed();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<_FeedData> _loadFeed() async {
    final results = await Future.wait([
      _usersApi.getAllPosts(),
      _usersApi.getUsers(),
      _usersApi.getAllComments(),
    ]);

    final posts = results[0] as List<PostModel>;
    final users = results[1] as List<UserModel>;
    final comments = results[2] as List;

    final usersById = {for (final u in users) u.id: u};

    final commentCounts = <int, int>{};
    for (final c in comments) {
      commentCounts[c.postId] = (commentCounts[c.postId] ?? 0) + 1;
    }

    return _FeedData(posts, usersById, commentCounts);
  }

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        titleSpacing: 20,
        toolbarHeight: 60,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What people are posting",
                style: TextStyle(color: semantic.inkDim, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<_FeedData>(
        future: _feedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasError) {
            return AppError(
              message: "${snapshot.error}",
              onRetry: () => setState(() => _feedFuture = _loadFeed()),
            );
          }

          final data = snapshot.data!;
          final posts = data.posts.where((post) {
            if (_query.isEmpty) return true;
            final author = data.usersById[post.userId];
            return post.title.toLowerCase().contains(_query) ||
                post.body.toLowerCase().contains(_query) ||
                (author?.name.toLowerCase().contains(_query) ?? false);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search posts or people…",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final author = data.usersById[post.userId];

                    return PostCard(
                      title: post.title,
                      body: post.body,
                      commentCount: data.commentCountByPostId[post.id] ?? 0,
                      authorName: author?.name ?? "Unknown",
                      authorSubtitle: author?.companyName,
                      onTap: () => context.push('/post/${post.id}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
