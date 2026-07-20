import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final inactive = isDark ? AppColors.textMutedDark : AppColors.muted;
    final bg = isDark ? AppColors.espresso : AppColors.linen;
    final idx = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bg,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF3D2E25) : const Color(0xFFE5D9C9),
              width: 0.5,
            ),
          ),
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
                      if (i != idx) context.go(item.route);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? primary.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                          ),
                          child: Icon(
                            active ? item.activeIcon : item.icon,
                            color: active ? primary : inactive,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 10,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w400,
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
