import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode provider — persists user's theme preference
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

/// Authentication state
final isAuthenticatedProvider = NotifierProvider<_BoolNotifier, bool>(_BoolNotifier.new);
class _BoolNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool v) => state = v;
}

/// Current navigation index
final currentNavIndexProvider = NotifierProvider<_IntNotifier, int>(_IntNotifier.new);
class _IntNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void set(int v) => state = v;
}
