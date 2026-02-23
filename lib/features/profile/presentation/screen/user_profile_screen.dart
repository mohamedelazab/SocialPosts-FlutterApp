import 'package:flutter/material.dart';
import '../../../../core/widgets/gradient_app_bar.dart';
import '../../../users/data/models/album_model.dart';
import '../../../users/data/models/posts_model.dart';
import '../../../users/data/models/todo_model.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/data/users_api.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UsersApi _usersApi = UsersApi();

  late Future<UserModel> _userFuture;
  late Future<List<PostModel>> _postsFuture;
  late Future<List<AlbumModel>> _albumsFuture;
  late Future<List<TodoModel>> _todosFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _usersApi.getUserById(widget.userId);
    _postsFuture = _usersApi.getUserPosts(widget.userId);
    _albumsFuture = _usersApi.getUserAlbums(widget.userId);
    _todosFuture = _usersApi.getUserTodos(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const GradientAppBar(title: "User Profile"),
        body: FutureBuilder<UserModel>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            final user = snapshot.data!;

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: _buildProfileHeader(user),
                  ),
                  SliverAppBar(
                    pinned: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    toolbarHeight: 0, // <-- remove default height
                    bottom: const TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Posts"),
                        Tab(text: "Albums"),
                        Tab(text: "Todos"),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  _buildPosts(),
                  _buildAlbums(),
                  _buildTodos(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= PROFILE HEADER =================

  Widget _buildProfileHeader(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.blue[50],
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              user.name[0],
              style: const TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(user.email),
          const SizedBox(height: 6),
          Text(user.phone),
          Text(user.website),
          const SizedBox(height: 6),
          Text(
            user.companyName,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ================= POSTS =================

  Widget _buildPosts() {
    return FutureBuilder<List<PostModel>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(post.body),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================= ALBUMS =================

  Widget _buildAlbums() {
    return FutureBuilder<List<AlbumModel>>(
      future: _albumsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final albums = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album = albums[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(album.title),
              ),
            );
          },
        );
      },
    );
  }

  // ================= TODOS =================

  Widget _buildTodos() {
    return FutureBuilder<List<TodoModel>>(
      future: _todosFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final todos = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: CheckboxListTile(
                value: todo.completed,
                onChanged: null,
                title: Text(todo.title),
              ),
            );
          },
        );
      },
    );
  }
}