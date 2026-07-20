import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/services/mock_data_service.dart';

/// User profile screen — avatar, stats, activity feed.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;
    final user = MockDataService.currentUser;

    final stats = [
      (label: 'Prayers', value: '12', icon: Icons.volunteer_activism_rounded),
      (label: 'Petitions', value: '3', icon: Icons.mail_outlined),
      (label: 'Posts', value: '8', icon: Icons.forum_outlined),
    ];

    final activities = [
      (
        icon: Icons.volunteer_activism_rounded,
        color: AppColors.sage,
        title: 'Prayer request answered',
        time: '2 days ago',
        subtitle: '"Healing for my grandmother"',
      ),
      (
        icon: Icons.auto_awesome_rounded,
        color: AppColors.burntAmber,
        title: 'Liked a Daily Inspiration',
        time: '3 days ago',
        subtitle: '"Start here. The rest can wait."',
      ),
      (
        icon: Icons.forum_outlined,
        color: primary,
        title: 'Commented on forum post',
        time: '5 days ago',
        subtitle: '"How do you deal with anxiety as a Christian?"',
      ),
      (
        icon: Icons.event_rounded,
        color: const Color(0xFF6B7FD4),
        title: 'Registered for event',
        time: '1 week ago',
        subtitle: '"Youth Sunday Service"',
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── HEADER ──
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: bg,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: textPrimary,
                ),
                onPressed: () => context.push('/settings'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Gradient header
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.terracotta.withValues(alpha: 0.9),
                          AppColors.burntAmber.withValues(alpha: 0.7),
                          bg,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                  // Avatar + name
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // Avatar circle
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.terracotta,
                                AppColors.burntAmber,
                              ],
                            ),
                            border: Border.all(color: bg, width: 4),
                          ),
                          child: Center(
                            child: Text(
                              user.displayName.substring(0, 1).toUpperCase(),
                              style: GoogleFonts.bricolageGrotesque(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          user.displayName,
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.church_outlined,
                              size: 13,
                              color: textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Kingdom Quest Youth',
                              style: GoogleFonts.schibstedGrotesk(
                                fontSize: 12,
                                color: textMuted,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusFull,
                                ),
                              ),
                              child: Text(
                                'Member',
                                style: GoogleFonts.schibstedGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // ── STATS ROW ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusCard,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.06,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: stats
                          .map(
                            (s) => Column(
                              children: [
                                Icon(s.icon, size: 22, color: primary),
                                const SizedBox(height: 6),
                                Text(
                                  s.value,
                                  style: GoogleFonts.bricolageGrotesque(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                                Text(
                                  s.label,
                                  style: GoogleFonts.schibstedGrotesk(
                                    fontSize: 12,
                                    color: textMuted,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppSpacing.lg),

                // ── BIO ──
                if (user.bio != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusChip,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textMuted,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            user.bio!,
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 14,
                              color: textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppSpacing.lg),

                // ── ACTIVITY FEED ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Recent Activity',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...activities.asMap().entries.map((entry) {
                  final i = entry.key;
                  final act = entry.value;
                  return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: 4,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusChip,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: act.color.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  act.icon,
                                  size: 18,
                                  color: act.color,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      act.title,
                                      style: GoogleFonts.schibstedGrotesk(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      act.subtitle,
                                      style: GoogleFonts.schibstedGrotesk(
                                        fontSize: 12,
                                        color: textMuted,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                act.time,
                                style: GoogleFonts.schibstedGrotesk(
                                  fontSize: 11,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate(delay: Duration(milliseconds: 150 + i * 70))
                      .fadeIn(duration: 350.ms)
                      .slideX(begin: 0.05, end: 0);
                }),

                const SizedBox(height: AppSpacing.xxl),

                // ── EDIT PROFILE BUTTON ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: primary,
                      ),
                      label: Text(
                        'Edit Profile',
                        style: GoogleFonts.schibstedGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: primary.withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusChip,
                          ),
                        ),
                      ),
                    ),
                  ),
                ).animate(delay: 400.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
