import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/data/users_api.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/posts_model.dart';

class _PostDetailData {
  final PostModel post;
  final UserModel? author;
  final List<CommentModel> comments;

  _PostDetailData(this.post, this.author, this.comments);
}

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final UsersApi _usersApi = UsersApi();
  late Future<_PostDetailData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_PostDetailData> _load() async {
    final post = await _usersApi.getPostById(widget.postId);
    final results = await Future.wait([
      _usersApi.getUserById(post.userId),
      _usersApi.getPostComments(widget.postId),
    ]);

    return _PostDetailData(
      post,
      results[0] as UserModel,
      results[1] as List<CommentModel>,
    );
  }

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Scaffold(
      appBar: AppBar(title: const Text("Post")),
      body: FutureBuilder<_PostDetailData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasError) {
            return AppError(
              message: "${snapshot.error}",
              onRetry: () => setState(() => _future = _load()),
            );
          }

          final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  InitialsAvatar(name: data.author?.name ?? "?", radius: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.author?.name ?? "Unknown",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13.5),
                        ),
                        if ((data.author?.companyName ?? "").isNotEmpty)
                          Text(
                            data.author!.companyName,
                            style: TextStyle(color: semantic.inkDim, fontSize: 11.5),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                data.post.title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 19, height: 1.3),
              ),
              const SizedBox(height: 10),
              Text(
                data.post.body,
                style: TextStyle(color: semantic.inkDim, fontSize: 14, height: 1.55),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Text(
                    "${data.comments.length} comments".toUpperCase(),
                    style: TextStyle(
                      color: semantic.inkDim,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              for (final comment in data.comments)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InitialsAvatar(name: comment.name, radius: 15),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  comment.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700, fontSize: 12.5),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  comment.email,
                                  style:
                                      TextStyle(color: semantic.inkDim, fontSize: 10.5),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              comment.body,
                              style: TextStyle(
                                  color: semantic.inkDim, fontSize: 12.5, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
