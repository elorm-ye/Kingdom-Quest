import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Admin navigation shell — separate from member shell.
/// Accessible only when user has UserRole.admin.
class AdminShell extends StatefulWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
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

  final List<int> _tabHistory = [0];
  DateTime? _lastBackPressTime;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = _navItems.length - 1; i >= 0; i--) {
      if (location.startsWith(_navItems[i].route)) return i;
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
      context.go(_navItems[prevTab].route);
      return;
    }

    // If not on Admin Overview tab, navigate back to /admin first
    if (currentIdx != 0) {
      _tabHistory.clear();
      _tabHistory.add(0);
      context.go('/admin');
      return;
    }

    // Already on Admin Overview: double back press to exit safely
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Press back again to exit Kingdom Quest Admin'),
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
              context.go(_navItems[i].route);
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

