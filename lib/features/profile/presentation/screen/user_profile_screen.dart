import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/post_card.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/data/users_api.dart';
import '../../data/models/album_model.dart';
import '../../data/models/posts_model.dart';
import '../../data/models/todo_model.dart';

enum _TodoFilter { all, active, done }

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

  int _tabIndex = 0;
  _TodoFilter _todoFilter = _TodoFilter.all;

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
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: FutureBuilder<UserModel>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }
          if (snapshot.hasError) {
            return AppError(message: "${snapshot.error}");
          }

          final user = snapshot.data!;

          return Column(
            children: [
              _ProfileHeader(
                user: user,
                postsFuture: _postsFuture,
                albumsFuture: _albumsFuture,
                todosFuture: _todosFuture,
              ),
              _SegmentedControl(
                labels: const ["Posts", "Albums", "To-dos"],
                index: _tabIndex,
                onChanged: (i) => setState(() => _tabIndex = i),
              ),
              Expanded(
                child: IndexedStack(
                  index: _tabIndex,
                  sizing: StackFit.expand,
                  children: [
                    _buildPosts(),
                    _buildAlbums(),
                    _buildTodos(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= POSTS =================

  Widget _buildPosts() {
    return FutureBuilder<List<PostModel>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const AppLoader();

        final posts = snapshot.data!;
        if (posts.isEmpty) {
          return const _EmptyTab(icon: Icons.article_outlined, message: "No posts yet.");
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            return PostCard(
              title: post.title,
              body: post.body,
              commentCount: 0,
              onTap: () => context.push('/post/${post.id}'),
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
        if (!snapshot.hasData) return const AppLoader();

        final albums = snapshot.data!;
        if (albums.isEmpty) {
          return const _EmptyTab(icon: Icons.photo_album_outlined, message: "No albums yet.");
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album = albums[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.photo_album_outlined),
                title: Text(album.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push('/album/${album.id}', extra: album.title),
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
        if (!snapshot.hasData) return const AppLoader();

        final todos = snapshot.data!;
        if (todos.isEmpty) {
          return const _EmptyTab(icon: Icons.checklist_rounded, message: "No to-dos yet.");
        }

        final doneCount = todos.where((t) => t.completed).length;
        final pct = todos.isEmpty ? 0.0 : doneCount / todos.length;

        final filtered = todos.where((t) {
          switch (_todoFilter) {
            case _TodoFilter.active:
              return !t.completed;
            case _TodoFilter.done:
              return t.completed;
            case _TodoFilter.all:
              return true;
          }
        }).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            _TodoProgress(doneCount: doneCount, total: todos.length, pct: pct),
            const SizedBox(height: 12),
            _SegmentedControl(
              labels: const ["All", "Active", "Done"],
              index: _TodoFilter.values.indexOf(_todoFilter),
              onChanged: (i) => setState(() => _todoFilter = _TodoFilter.values[i]),
            ),
            const SizedBox(height: 8),
            for (final todo in filtered) _TodoRow(todo: todo),
          ],
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  final Future<List<PostModel>> postsFuture;
  final Future<List<AlbumModel>> albumsFuture;
  final Future<List<TodoModel>> todosFuture;

  const _ProfileHeader({
    required this.user,
    required this.postsFuture,
    required this.albumsFuture,
    required this.todosFuture,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        Container(
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, semantic.primarySoft],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                  ),
                  child: InitialsAvatar(name: user.name, radius: 32),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                    Text(
                      "@${user.username}${user.city.isNotEmpty ? ' · ${user.city}' : ''}",
                      style: TextStyle(color: semantic.inkDim, fontSize: 12),
                    ),
                    if (user.companyCatchPhrase.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        '"${user.companyCatchPhrase}"',
                        style: TextStyle(
                          color: semantic.inkDim,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    _StatsRow(
                      postsFuture: postsFuture,
                      albumsFuture: albumsFuture,
                      todosFuture: todosFuture,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Future<List<PostModel>> postsFuture;
  final Future<List<AlbumModel>> albumsFuture;
  final Future<List<TodoModel>> todosFuture;

  const _StatsRow({
    required this.postsFuture,
    required this.albumsFuture,
    required this.todosFuture,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: semantic.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _statCell(context, postsFuture, (posts) => "${posts.length}", "Posts"),
          _divider(semantic),
          _statCell(context, albumsFuture, (albums) => "${albums.length}", "Albums"),
          _divider(semantic),
          _statCell(
            context,
            todosFuture,
            (todos) {
              if (todos.isEmpty) return "0%";
              final done = todos.where((t) => t.completed).length;
              return "${((done / todos.length) * 100).round()}%";
            },
            "To-dos",
          ),
        ],
      ),
    );
  }

  Widget _divider(AppSemanticColors semantic) =>
      Container(width: 1, height: 34, color: semantic.border);

  Widget _statCell<T>(
    BuildContext context,
    Future<List<T>> future,
    String Function(List<T>) label,
    String caption,
  ) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Expanded(
      child: FutureBuilder<List<T>>(
        future: future,
        builder: (context, snapshot) {
          final value = snapshot.hasData ? label(snapshot.data!) : "–";

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  caption.toUpperCase(),
                  style: TextStyle(
                    color: semantic.inkDim,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  const _SegmentedControl({required this.labels, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: semantic.surface2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: index == i ? Theme.of(context).colorScheme.surface : null,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: index == i
                          ? [const BoxShadow(color: Colors.black12, blurRadius: 3)]
                          : null,
                    ),
                    child: Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: index == i ? primary : semantic.inkDim,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TodoProgress extends StatelessWidget {
  final int doneCount;
  final int total;
  final double pct;

  const _TodoProgress({required this.doneCount, required this.total, required this.pct});

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$doneCount of $total done".toUpperCase(),
                  style: TextStyle(
                    color: semantic.inkDim,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  "${(pct * 100).round()}%",
                  style: TextStyle(
                    color: semantic.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                backgroundColor: semantic.surface2,
                valueColor: AlwaysStoppedAnimation(semantic.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodoRow extends StatelessWidget {
  final TodoModel todo;

  const _TodoRow({required this.todo});

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: todo.completed ? primary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: todo.completed ? primary : semantic.border, width: 1.6),
            ),
            child: todo.completed
                ? Icon(Icons.check, size: 14, color: Theme.of(context).colorScheme.onPrimary)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              todo.title,
              style: TextStyle(
                fontSize: 13,
                color: todo.completed ? semantic.inkDim : null,
                decoration: todo.completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTab extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyTab({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: semantic.inkDim),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: semantic.inkDim, fontSize: 12.5)),
        ],
      ),
    );
  }
}
