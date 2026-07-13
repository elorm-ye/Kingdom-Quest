import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/dashboard/presentation/main_shell.dart';
import '../../features/dashboard/presentation/home_screen.dart';
import '../../features/prayer_requests/presentation/prayer_requests_screen.dart';
import '../../features/prayer_requests/presentation/submit_prayer_screen.dart';
import '../../features/petitions/presentation/petitions_screen.dart';
import '../../features/petitions/presentation/submit_petition_screen.dart';
import '../../features/advice/presentation/advice_screen.dart';
import '../../features/advice/presentation/submit_advice_screen.dart';
import '../../features/daily_inspiration/presentation/inspiration_screen.dart';
import '../../features/community_forum/presentation/forum_screen.dart';
import '../../features/community_forum/presentation/create_post_screen.dart';
import '../../features/events/presentation/events_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/community',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ForumScreen(),
            ),
          ),
          GoRoute(
            path: '/inspiration',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: InspirationScreen(),
            ),
          ),
          GoRoute(
            path: '/events',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EventsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/prayer-requests',
        builder: (context, state) => const PrayerRequestsScreen(),
      ),
      GoRoute(
        path: '/submit-prayer',
        builder: (context, state) => const SubmitPrayerScreen(),
      ),
      GoRoute(
        path: '/petitions',
        builder: (context, state) => const PetitionsScreen(),
      ),
      GoRoute(
        path: '/submit-petition',
        builder: (context, state) => const SubmitPetitionScreen(),
      ),
      GoRoute(
        path: '/advice',
        builder: (context, state) => const AdviceScreen(),
      ),
      GoRoute(
        path: '/submit-advice',
        builder: (context, state) => const SubmitAdviceScreen(),
      ),
      GoRoute(
        path: '/create-post',
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
