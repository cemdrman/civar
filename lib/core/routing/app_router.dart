import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app_state/repository_providers.dart';
import '../../features/compose/compose_screen.dart';
import '../../features/dm/dm_chat_screen.dart';
import '../../features/dm/dm_list_screen.dart';
import '../../features/feed/feed_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/onboarding/onboarding_flow_screen.dart';
import '../../features/paywall/paywall_screen.dart';
import '../../features/place_detail/place_detail_screen.dart';
import '../../features/profile/blocked_users_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/shell/app_shell.dart';
import 'route_paths.dart';

/// Bridges a Stream (auth state changes) to a Listenable so GoRouter
/// re-evaluates its redirect whenever the mock auth repository changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final refresh = GoRouterRefreshStream(authRepo.authStateChanges());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: RoutePaths.onboarding,
    refreshListenable: refresh,
    redirect: (context, state) async {
      final user = await authRepo.currentUser();
      final onOnboarding = state.matchedLocation == RoutePaths.onboarding;
      if (user == null) return onOnboarding ? null : RoutePaths.onboarding;
      if (onOnboarding) return RoutePaths.map;
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingFlowScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.map, builder: (context, state) => const MapScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.feed, builder: (context, state) => const FeedScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.dm, builder: (context, state) => const DmListScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/place/:placeId',
        builder: (context, state) =>
            PlaceDetailScreen(placeId: state.pathParameters['placeId']!),
      ),
      GoRoute(
        path: '/dm-thread/:threadId',
        builder: (context, state) =>
            DmChatScreen(threadId: state.pathParameters['threadId']!),
      ),
      GoRoute(
        path: RoutePaths.compose,
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: ComposeScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.paywall,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.blockedUsers,
        builder: (context, state) => const BlockedUsersScreen(),
      ),
    ],
  );
});
