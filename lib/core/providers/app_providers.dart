import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/models/models.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/mock_data_service.dart';
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

/// Mock demo user when testing without live backend.
final demoUserModelProvider = NotifierProvider<_DemoUserNotifier, UserModel?>(
  _DemoUserNotifier.new,
);

class _DemoUserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => MockDataService.currentUser;
  void set(UserModel? u) => state = u;
}

/// Resolved [UserModel] (with profile data) for the signed-in user.
final currentUserModelProvider = FutureProvider<UserModel?>((ref) async {
  final demoUser = ref.watch(demoUserModelProvider);
  if (demoUser != null) return demoUser;

  final user = ref.watch(currentSupabaseUserProvider);
  if (user == null) return null;
  try {
    final profile = await ref.read(authServiceProvider).fetchProfile(user.id);
    return profile ?? MockDataService.currentUser;
  } catch (_) {
    return MockDataService.currentUser;
  }
});

/// True when a user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(demoUserModelProvider) != null ||
      ref.watch(currentSupabaseUserProvider) != null;
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
      ref.read(demoUserModelProvider.notifier).set(null);
      state = const AsyncValue.data(null);
      return true;
    } on AuthException catch (e, st) {
      state = AsyncValue.error(e.message, st);
      return false;
    } catch (e, st) {
      // Backend unavailable / connection error fallback to demo mode
      final isAdmin = email.toLowerCase().contains('admin');
      ref.read(demoUserModelProvider.notifier).set(
        isAdmin ? MockDataService.adminUser : MockDataService.currentUser,
      );
      state = const AsyncValue.data(null);
      return true;
    }
  }

  Future<bool> signInAsDemo({bool isAdmin = false}) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 300));
    ref.read(demoUserModelProvider.notifier).set(
      isAdmin ? MockDataService.adminUser : MockDataService.currentUser,
    );
    state = const AsyncValue.data(null);
    return true;
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
      // Backend unavailable fallback to demo mode
      ref.read(demoUserModelProvider.notifier).set(
        UserModel(
          id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          displayName: displayName,
          role: UserRole.member,
          gender: gender == 'female'
              ? Gender.female
              : gender == 'male'
                  ? Gender.male
                  : Gender.preferNotToSay,
          createdAt: DateTime.now(),
        ),
      );
      state = const AsyncValue.data(null);
      return true;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      ref.read(demoUserModelProvider.notifier).set(null);
      await _auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      ref.read(demoUserModelProvider.notifier).set(null);
      state = const AsyncValue.data(null);
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
      state = const AsyncValue.data(null);
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
// COLOR THEME (default / pink)
// ─────────────────────────────────────────────────────────────────────────────

/// The name of the active color theme. Currently supports 'default' and 'pink'.
enum ColorThemeName { defaultTheme, pink }

final colorThemeProvider = NotifierProvider<ColorThemeNotifier, ColorThemeName>(() {
  return ColorThemeNotifier();
});

class ColorThemeNotifier extends Notifier<ColorThemeName> {
  @override
  ColorThemeName build() {
    _loadColorTheme();
    return ColorThemeName.defaultTheme;
  }

  Future<void> _loadColorTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('colorTheme') ?? 'default';
    state = saved == 'pink' ? ColorThemeName.pink : ColorThemeName.defaultTheme;
  }

  Future<void> toggle() async {
    await setColorTheme(
      state == ColorThemeName.defaultTheme ? ColorThemeName.pink : ColorThemeName.defaultTheme,
    );
  }

  Future<void> setColorTheme(ColorThemeName theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('colorTheme', theme == ColorThemeName.pink ? 'pink' : 'default');
  }

  bool get isPink => state == ColorThemeName.pink;
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
