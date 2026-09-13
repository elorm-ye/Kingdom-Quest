import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Main navigation shell with bottom nav bar and system back button handling.
class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _navItems = [
    (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    (
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum_rounded,
      label: 'Community',
    ),
    (
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome,
      label: 'Inspire',
    ),
    (icon: Icons.event_outlined, activeIcon: Icons.event, label: 'Events'),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  static const _routes = [
    '/home',
    '/community',
    '/inspiration',
    '/events',
    '/profile',
  ];

  final List<int> _tabHistory = [0];
  DateTime? _lastBackPressTime;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  void _syncCurrentTab(int idx) {
    if (_tabHistory.isEmpty || _tabHistory.last != idx) {
      _tabHistory.remove(idx);
      _tabHistory.add(idx);
    }
  }

  Future<void> _handlePop(BuildContext context, int currentIdx) async {
    // If the tab history has more than 1 tab, navigate to the previous tab
    if (_tabHistory.length > 1) {
      _tabHistory.removeLast();
      final prevTab = _tabHistory.last;
      context.go(_routes[prevTab]);
      return;
    }

    // If current tab is not Home, navigate back to Home first
    if (currentIdx != 0) {
      _tabHistory.clear();
      _tabHistory.add(0);
      context.go('/home');
      return;
    }

    // Already on Home tab: double back press to exit safely
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Press back again to exit Kingdom Quest'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    _syncCurrentTab(idx);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handlePop(context, idx);
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: idx,
          onTap: (i) {
            if (i != idx) {
              _syncCurrentTab(i);
              context.go(_routes[i]);
            }
          },
          items: _navItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              activeIcon: Icon(item.activeIcon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

