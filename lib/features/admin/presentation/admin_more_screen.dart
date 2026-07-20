import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Admin "More" screen — links to advice, inspiration publisher, forum mod.
class AdminMoreScreen extends StatelessWidget {
  const AdminMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;
    final divider = isDark ? const Color(0xFF3D2E25) : const Color(0xFFE5D9C9);

    final modules = [
      (
        icon: Icons.lightbulb_outline_rounded,
        color: AppColors.terracotta,
        title: 'Advice Center',
        subtitle: 'Review & respond to spiritual advice requests',
        route: '/admin/advice',
      ),
      (
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFF6B7FD4),
        title: 'Inspiration Publisher',
        subtitle: 'Create and schedule daily inspirations',
        route: '/admin/inspiration',
      ),
      (
        icon: Icons.forum_outlined,
        color: AppColors.oliveClay,
        title: 'Forum Moderation',
        subtitle: 'Review reported posts and moderate content',
        route: '/admin/forum',
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'More Tools',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // ── MODULE TILES ──
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            ),
            child: Column(
              children: modules.asMap().entries.map((entry) {
                final i = entry.key;
                final m = entry.value;
                return Column(
                  children: [
                    ListTile(
                          onTap: () => context.go(m.route),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: m.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(m.icon, color: m.color, size: 22),
                          ),
                          title: Text(
                            m.title,
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            m.subtitle,
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 12,
                              color: textMuted,
                            ),
                          ),
                          trailing: HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowRight01,
                            color: textMuted,
                          ),
                        )
                        .animate(delay: Duration(milliseconds: i * 60))
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: 0.05, end: 0),
                    if (i < modules.length - 1)
                      Divider(height: 1, color: divider, indent: 72),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── CHURCH SETTINGS ──
          Text(
            'Church Settings',
            style: GoogleFonts.schibstedGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedBuilding01,
                      color: primary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Church Profile',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Name, logo, contact info',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 12,
                      color: textMuted,
                    ),
                  ),
                  trailing: HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    color: textMuted,
                  ),
                ),
                Divider(height: 1, color: divider, indent: 72),
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedCalendar01,
                      color: primary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Event Management',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Create and manage events',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 12,
                      color: textMuted,
                    ),
                  ),
                  trailing: HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    color: textMuted,
                  ),
                ),
                Divider(height: 1, color: divider, indent: 72),
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedMegaphone01,
                      color: primary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Announcements',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Publish church announcements',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 12,
                      color: textMuted,
                    ),
                  ),
                  trailing: HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight01,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 350.ms),
        ],
      ),
    );
  }
}
