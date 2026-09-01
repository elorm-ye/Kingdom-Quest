import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main navigation shell with bottom nav bar.
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

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

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i) {
          if (i != idx) context.go(_routes[i]);
        },
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
