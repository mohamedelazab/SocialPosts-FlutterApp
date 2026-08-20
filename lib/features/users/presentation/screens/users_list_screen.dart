import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../data/models/user_model.dart';
import '../../data/users_api.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final UsersApi _usersApi = UsersApi();
  late Future<List<UserModel>> _usersFuture;

  List<UserModel> _allUsers = [];
  final TextEditingController _searchController = TextEditingController();
  String _query = "";

  @override
  void initState() {
    super.initState();
    _usersFuture = _usersApi.getUsers();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("People"),
        titleSpacing: 20,
        toolbarHeight: 60,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _allUsers.isEmpty
                    ? "The directory"
                    : "${_allUsers.length} in the directory",
                style: TextStyle(color: semantic.inkDim, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoader();
          }

          if (snapshot.hasError) {
            return AppError(
              message: "${snapshot.error}",
              onRetry: () => setState(() => _usersFuture = _usersApi.getUsers()),
            );
          }

          _allUsers = snapshot.data ?? [];
          final filtered = _allUsers.where((user) {
            if (_query.isEmpty) return true;
            return user.name.toLowerCase().contains(_query) ||
                user.email.toLowerCase().contains(_query) ||
                user.companyName.toLowerCase().contains(_query) ||
                user.city.toLowerCase().contains(_query);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search by name, company, city…",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final user = filtered[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => context.push('/profile/${user.id}'),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              InitialsAvatar(name: user.name, radius: 19),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700, fontSize: 14),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "@${user.username} · ${user.companyName}",
                                      style: TextStyle(
                                          color: semantic.inkDim, fontSize: 11.5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (user.city.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(user.city),
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
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
