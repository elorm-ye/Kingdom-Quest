import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/app_providers.dart';

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

// Admin
import '../../features/admin/presentation/admin_shell.dart';
import '../../features/admin/presentation/admin_home_screen.dart';
import '../../features/admin/presentation/admin_prayers_screen.dart';
import '../../features/admin/presentation/admin_petitions_screen.dart';
import '../../features/admin/presentation/admin_users_screen.dart';
import '../../features/admin/presentation/admin_more_screen.dart';
import '../../features/admin/presentation/admin_advice_screen.dart';
import '../../features/admin/presentation/admin_inspiration_screen.dart';
import '../../features/admin/presentation/admin_forum_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _adminNavigatorKey = GlobalKey<NavigatorState>();

/// Routes that don't require authentication
const _publicRoutes = {'/splash', '/login', '/register'};

final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state so the router rebuilds on sign in/out
  ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',

    // ── Auth redirect ──────────────────────────────────────────────────────
    redirect: (context, routerState) {
      final isSignedIn = Supabase.instance.client.auth.currentUser != null;
      final goingTo = routerState.matchedLocation;
      final isPublic = _publicRoutes.contains(goingTo);

      // Not signed in → push to login (except public routes)
      if (!isSignedIn && !isPublic) return '/login';

      // Already signed in → skip login/register → go to home
      if (isSignedIn && (goingTo == '/login' || goingTo == '/register')) {
        return '/home';
      }

      return null; // no redirect
    },

    routes: [
      // ── AUTH FLOW ──────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── MEMBER SHELL ───────────────────────────────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/community',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ForumScreen()),
          ),
          GoRoute(
            path: '/inspiration',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: InspirationScreen()),
          ),
          GoRoute(
            path: '/events',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: EventsScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      // ── MEMBER FULL-SCREEN ROUTES ──────────────────────────────────────
      GoRoute(
        path: '/prayer-requests',
        builder: (c, s) => const PrayerRequestsScreen(),
      ),
      GoRoute(
        path: '/submit-prayer',
        builder: (c, s) => const SubmitPrayerScreen(),
      ),
      GoRoute(path: '/petitions', builder: (c, s) => const PetitionsScreen()),
      GoRoute(
        path: '/submit-petition',
        builder: (c, s) => const SubmitPetitionScreen(),
      ),
      GoRoute(path: '/advice', builder: (c, s) => const AdviceScreen()),
      GoRoute(
        path: '/submit-advice',
        builder: (c, s) => const SubmitAdviceScreen(),
      ),
      GoRoute(
        path: '/create-post',
        builder: (c, s) => const CreatePostScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (c, s) => const NotificationsScreen(),
      ),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),

      // ── ADMIN SHELL ────────────────────────────────────────────────────
      ShellRoute(
        navigatorKey: _adminNavigatorKey,
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AdminHomeScreen()),
          ),
          GoRoute(
            path: '/admin/prayers',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AdminPrayersScreen()),
          ),
          GoRoute(
            path: '/admin/petitions',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AdminPetitionsScreen()),
          ),
          GoRoute(
            path: '/admin/users',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AdminUsersScreen()),
          ),
          GoRoute(
            path: '/admin/more',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AdminMoreScreen()),
          ),
        ],
      ),

      // ── ADMIN FULL-SCREEN ROUTES (no admin shell nav) ─────────────────
      GoRoute(
        path: '/admin/advice',
        builder: (c, s) => const AdminAdviceScreen(),
      ),
      GoRoute(
        path: '/admin/inspiration',
        builder: (c, s) => const AdminInspirationScreen(),
      ),
      GoRoute(
        path: '/admin/forum',
        builder: (c, s) => const AdminForumScreen(),
      ),
    ],
  );
});
