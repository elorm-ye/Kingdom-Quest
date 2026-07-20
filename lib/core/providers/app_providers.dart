import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/models/models.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/storage_service.dart';
import '../../shared/services/supabase_data_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SUPABASE CLIENT
// ─────────────────────────────────────────────────────────────────────────────

/// The raw Supabase client — single instance, accessed via Supabase.instance.client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ─────────────────────────────────────────────────────────────────────────────
// SERVICES
// ─────────────────────────────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(supabaseClientProvider));
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(supabaseClientProvider));
});

final dataServiceProvider = Provider<SupabaseDataService>((ref) {
  return SupabaseDataService(ref.watch(supabaseClientProvider));
});

// ─────────────────────────────────────────────────────────────────────────────
// AUTH STATE
// ─────────────────────────────────────────────────────────────────────────────

/// Listens to Supabase auth state changes and exposes the current session.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// The current Supabase [User], or null if not signed in.
final currentSupabaseUserProvider = Provider<User?>((ref) {
  final authAsync = ref.watch(authStateProvider);
  return authAsync.when(
    data: (state) => state.session?.user,
    loading: () => Supabase.instance.client.auth.currentUser,
    error: (_, __) => null,
  );
});

/// Resolved [UserModel] (with profile data) for the signed-in user.
final currentUserModelProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(currentSupabaseUserProvider);
  if (user == null) return null;
  return ref.read(authServiceProvider).fetchProfile(user.id);
});

/// True when a user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentSupabaseUserProvider) != null;
});

// ─────────────────────────────────────────────────────────────────────────────
// AUTH NOTIFIER  (sign in / sign up / sign out actions)
// ─────────────────────────────────────────────────────────────────────────────

class AuthNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  AuthService get _auth => ref.read(authServiceProvider);

  Future<bool> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      await _auth.signIn(email: email, password: password);
      state = const AsyncValue.data(null);
      return true;
    } on AuthException catch (e, st) {
      state = AsyncValue.error(e.message, st);
      return false;
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    required String gender,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _auth.signUp(
        email: email,
        password: password,
        displayName: displayName,
        gender: gender,
      );
      state = const AsyncValue.data(null);
      return true;
    } on AuthException catch (e, st) {
      state = AsyncValue.error(e.message, st);
      return false;
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
      return false;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _auth.resetPassword(email);
      state = const AsyncValue.data(null);
    } on AuthException catch (e, st) {
      state = AsyncValue.error(e.message, st);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  /// Returns the error message string if state is in error, null otherwise.
  String? get errorMessage => state.hasError ? state.error.toString() : null;
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AsyncValue<void>>(
  AuthNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// THEME
// ─────────────────────────────────────────────────────────────────────────────

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeMode') ?? 'light';
    state = saved == 'dark'
        ? ThemeMode.dark
        : saved == 'system'
        ? ThemeMode.system
        : ThemeMode.light;
  }

  Future<void> toggle() async {
    await setTheme(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    final key = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.system
        ? 'system'
        : 'light';
    await prefs.setString('themeMode', key);
  }

  bool get isDark => state == ThemeMode.dark;
}

// ─────────────────────────────────────────────────────────────────────────────
// NAVIGATION
// ─────────────────────────────────────────────────────────────────────────────

final currentNavIndexProvider = NotifierProvider<_IntNotifier, int>(
  _IntNotifier.new,
);

class _IntNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void set(int v) => state = v;
}
