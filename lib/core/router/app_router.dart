import 'package:go_router/go_router.dart';

import '../../features/profile/presentation/screen/album_screen.dart';
import '../../features/profile/presentation/screen/user_profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/users/presentation/screens/users_list_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      /// Splash
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      /// Users List
      GoRoute(
        path: '/users',
        name: 'users',
        builder: (context, state) => const UsersListScreen(),
      ),

      /// Profile
      GoRoute(
        path: '/profile/:userId',
        name: 'profile',
        builder: (context, state) {
          final userId = int.parse(state.pathParameters['userId']!);

          return UserProfileScreen(userId: userId);
        },
      ),

      /// Album Screen
      GoRoute(
        path: '/album/:albumId',
        name: 'album',
        builder: (context, state) {
          final albumId = int.parse(state.pathParameters['albumId']!);
          final albumTitle = state.extra as String? ?? "Album";

          return AlbumScreen(albumId: albumId, albumTitle: albumTitle);
        },
      ),

    ],
  );
}
