import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Main navigation shell with bottom nav bar.
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _navItems = [
    (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.forum_outlined, activeIcon: Icons.forum_rounded, label: 'Community'),
    (icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, label: 'Inspire'),
    (icon: Icons.event_outlined, activeIcon: Icons.event, label: 'Events'),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  static const _routes = ['/home', '/community', '/inspiration', '/events', '/profile'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final idx = _currentIndex(context);
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final inactive = isDark ? AppColors.textMutedDark : AppColors.muted;
    final bg = isDark ? AppColors.espresso : AppColors.linen;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bg,
          border: Border(top: BorderSide(color: isDark ? const Color(0xFF3D2E25) : const Color(0xFFE5D9C9), width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppSpacing.bottomNavHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final active = i == idx;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (i != idx) context.go(_routes[i]);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: active ? primary.withValues(alpha: 0.12) : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Icon(
                            active ? item.activeIcon : item.icon,
                            color: active ? primary : inactive,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 11,
                            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                            color: active ? primary : inactive,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
