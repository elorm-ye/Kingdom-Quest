import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Admin navigation shell — separate from member shell.
/// Accessible only when user has UserRole.admin.
class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  static const _navItems = [
    (
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: 'Overview',
      route: '/admin',
    ),
    (
      icon: Icons.volunteer_activism_outlined,
      activeIcon: Icons.volunteer_activism_rounded,
      label: 'Prayers',
      route: '/admin/prayers',
    ),
    (
      icon: Icons.mail_outline_rounded,
      activeIcon: Icons.mail_rounded,
      label: 'Petitions',
      route: '/admin/petitions',
    ),
    (
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      label: 'Users',
      route: '/admin/users',
    ),
    (
      icon: Icons.more_horiz_rounded,
      activeIcon: Icons.more_horiz_rounded,
      label: 'More',
      route: '/admin/more',
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = _navItems.length - 1; i >= 0; i--) {
      if (location.startsWith(_navItems[i].route)) return i;
    }
    return 0;
  }

  Future<void> _handlePop(BuildContext context, int currentIdx) async {
    // If not on Admin Overview tab, navigate back to /admin first
    if (currentIdx != 0) {
      context.go('/admin');
      return;
    }

    // If already on Admin Overview, confirm exit
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit Kingdom Quest Admin?'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handlePop(context, idx);
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: idx,
          onTap: (i) {
            if (i != idx) context.go(_navItems[i].route);
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

