import 'package:go_router/go_router.dart';

import '../../features/feed/presentation/screens/feed_screen.dart';
import '../../features/profile/data/models/photo_model.dart';
import '../../features/profile/presentation/screen/album_screen.dart';
import '../../features/profile/presentation/screen/photo_viewer_screen.dart';
import '../../features/profile/presentation/screen/post_detail_screen.dart';
import '../../features/profile/presentation/screen/user_profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/users/presentation/screens/users_list_screen.dart';
import '../widgets/app_shell.dart';

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

      /// Bottom-nav shell: Feed <-> People
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/feed',
                name: 'feed',
                builder: (context, state) => const FeedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/people',
                name: 'people',
                builder: (context, state) => const UsersListScreen(),
              ),
            ],
          ),
        ],
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

      /// Post detail
      GoRoute(
        path: '/post/:postId',
        name: 'post',
        builder: (context, state) {
          final postId = int.parse(state.pathParameters['postId']!);

          return PostDetailScreen(postId: postId);
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
        routes: [
          /// Photo viewer — receives the already-fetched photo list so it
          /// doesn't re-hit the API just to page through images.
          GoRoute(
            path: 'photo',
            name: 'album-photo',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;

              return PhotoViewerScreen(
                photos: extra['photos'] as List<PhotoModel>,
                initialIndex: extra['initialIndex'] as int,
              );
            },
          ),
        ],
      ),
    ],
  );
}
