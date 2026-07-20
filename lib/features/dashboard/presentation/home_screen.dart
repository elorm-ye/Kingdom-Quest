import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/services/mock_data_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verse = MockDataService.getDailyVerse();
    final user = MockDataService.currentUser;
    final events = MockDataService.events.take(2).toList();
    final announcements = MockDataService.announcements;

    return Scaffold(
      backgroundColor: isDark ? AppColors.umberNight : AppColors.sand,
      body: CustomScrollView(
        slivers: [
          // App bar with church name
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: isDark ? AppColors.umberNight : AppColors.sand,
            title: Row(
              children: [
                _buildSmallMark(isDark),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'ICGC',
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.umber,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.umber,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.alert,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () => context.push('/notifications'),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppSpacing.sm),

                // Welcome
                Text(
                      'Hey ${user.displayName} 👋',
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.umber,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideX(begin: -0.1, duration: 500.ms),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'What\'s on your heart today?',
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 14,
                    color: isDark ? AppColors.textMutedDark : AppColors.muted,
                  ),
                ).animate(delay: 100.ms).fadeIn(duration: 500.ms),

                const SizedBox(height: AppSpacing.xxl),

                // Verse of the day card
                _verseCard(verse, isDark, context)
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.05, duration: 600.ms),

                const SizedBox(height: AppSpacing.xxl),

                // Quick actions
                Text(
                  'QUICK ACTIONS',
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : AppColors.muted,
                    letterSpacing: 1.2,
                  ),
                ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                const SizedBox(height: AppSpacing.md),
                _quickActionsGrid(
                  isDark,
                  context,
                ).animate(delay: 350.ms).fadeIn(duration: 500.ms),

                const SizedBox(height: AppSpacing.xxl),

                // Announcements
                if (announcements.isNotEmpty) ...[
                  Text(
                    'ANNOUNCEMENTS',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textMutedDark : AppColors.muted,
                      letterSpacing: 1.2,
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: AppSpacing.md),
                  ...announcements
                      .map(
                        (a) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: _announcementCard(
                            a.title,
                            a.content,
                            a.adminName,
                            a.isPinned,
                            isDark,
                          ),
                        ),
                      )
                      .toList()
                      .animate(interval: 100.ms, delay: 450.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.05),
                ],

                const SizedBox(height: AppSpacing.xxl),

                // Upcoming events
                Text(
                  'UPCOMING EVENTS',
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : AppColors.muted,
                    letterSpacing: 1.2,
                  ),
                ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
                const SizedBox(height: AppSpacing.md),
                ...events
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _eventCard(
                          e.title,
                          e.location ?? '',
                          e.startTime,
                          isDark,
                        ),
                      ),
                    )
                    .toList()
                    .animate(interval: 100.ms, delay: 550.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.05),

                const SizedBox(height: AppSpacing.massive),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMark(bool isDark) => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      gradient: AppColors.brandGradient,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: AppColors.linen.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(3),
            bottomRight: Radius.circular(3),
          ),
        ),
        child: Center(
          child: Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              color: AppColors.terracotta,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _verseCard(
    Map<String, String> verse,
    bool isDark,
    BuildContext context,
  ) {
    final cardBg = isDark ? AppColors.espresso : AppColors.linen;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VERSE OF THE DAY',
            style: GoogleFonts.schibstedGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMutedDark : AppColors.muted,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            verse['text']!,
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.umber,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            verse['reference']!,
            style: GoogleFonts.schibstedGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.accentLinkDark : AppColors.terracotta,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Start here. The rest can wait.',
            style: GoogleFonts.schibstedGrotesk(
              fontSize: 13,
              color: isDark ? AppColors.textMutedDark : AppColors.muted,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              _verseButton(
                'Amen',
                isDark ? AppColors.burntAmber : AppColors.terracotta,
                Colors.white,
              ),
              const SizedBox(width: AppSpacing.md),
              _verseButton(
                'Save',
                isDark ? AppColors.plumDusk : const Color(0xFFE5D9C9),
                isDark ? AppColors.textPrimaryDark : AppColors.umber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _verseButton(String label, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    ),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
    ),
    child: Text(
      label,
      style: GoogleFonts.schibstedGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: fg,
      ),
    ),
  );

  Widget _quickActionsGrid(bool isDark, BuildContext context) {
    final actions = [
      (
        icon: Icons.volunteer_activism_outlined,
        label: 'Prayer\nRequest',
        route: '/prayer-requests',
        color: AppColors.terracotta,
      ),
      (
        icon: Icons.description_outlined,
        label: 'Submit\nPetition',
        route: '/petitions',
        color: AppColors.burntAmber,
      ),
      (
        icon: Icons.psychology_outlined,
        label: 'Ask for\nAdvice',
        route: '/advice',
        color: AppColors.oliveClay,
      ),
      (
        icon: Icons.forum_outlined,
        label: 'Community\nForum',
        route: '/community',
        color: AppColors.sage,
      ),
      (
        icon: Icons.auto_awesome,
        label: 'Daily\nInspiration',
        route: '/inspiration',
        color: const Color(0xFFC7784E),
      ),
      (
        icon: Icons.event_outlined,
        label: 'Church\nEvents',
        route: '/events',
        color: const Color(0xFF5A7A9B),
      ),
    ];

    final cardBg = isDark ? AppColors.espresso : AppColors.linen;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.95,
      children: actions
          .map(
            (a) => GestureDetector(
              onTap: () {
                if (a.route == '/community' ||
                    a.route == '/inspiration' ||
                    a.route == '/events') {
                  context.go(a.route);
                } else {
                  context.push(a.route);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: a.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusChip,
                        ),
                      ),
                      child: Icon(a.icon, color: a.color, size: 22),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      a.label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.schibstedGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.umber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _announcementCard(
    String title,
    String content,
    String admin,
    bool pinned,
    bool isDark,
  ) {
    final cardBg = isDark ? AppColors.espresso : AppColors.linen;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (pinned) ...[
                Icon(
                  Icons.push_pin_outlined,
                  size: 14,
                  color: isDark ? AppColors.glow : AppColors.terracotta,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.umber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.schibstedGrotesk(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '— $admin',
            style: GoogleFonts.schibstedGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.accentLinkDark : AppColors.terracotta,
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventCard(String title, String location, DateTime time, bool isDark) {
    final cardBg = isDark ? AppColors.espresso : AppColors.linen;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 52,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.plumDusk
                  : AppColors.terracotta.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${time.day}',
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.terracotta,
                  ),
                ),
                Text(
                  months[time.month - 1],
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.terracotta,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.umber,
                  ),
                ),
                const SizedBox(height: 2),
                if (location.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: GoogleFonts.schibstedGrotesk(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.muted,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? AppColors.textMutedDark : AppColors.muted,
          ),
        ],
      ),
    );
  }
}
