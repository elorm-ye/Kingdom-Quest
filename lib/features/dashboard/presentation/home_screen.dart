import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/models/models.dart';
import '../../events/presentation/widgets/event_details_sheet.dart';
import '../../feed/presentation/widgets/church_feed_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    final verse = ref.watch(dailyVerseProvider);
    final asyncUser = ref.watch(currentUserModelProvider);
    final user = asyncUser.value;
    final displayName = user?.displayName ?? 'Friend';
    final asyncEvents = ref.watch(eventsNotifierProvider);
    final events = (asyncEvents.value ?? []).take(2).toList();
    final asyncAnnouncements = ref.watch(announcementsNotifierProvider);
    final announcements = asyncAnnouncements.value ?? [];
    final asyncFeed = ref.watch(feedPostsNotifierProvider);
    final feedPosts = asyncFeed.value ?? [];
    final asyncGamification = ref.watch(gamificationNotifierProvider);
    final streak = asyncGamification.value?.streak ??
        const QuestStreak(currentStreak: 1, longestStreak: 1, xpPoints: 50);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with church name
          SliverAppBar(
            floating: true,
            snap: true,
            title: Row(
              children: [
                _buildSmallMark(theme),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'ICGC',
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colorScheme.error,
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
                  'Hey $displayName 👋',
                  style: textTheme.displayLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'What\'s on your heart today?',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                ),

                const SizedBox(height: AppSpacing.md),

                // Daily Streak & Quest Banner
                _streakHeroBanner(context, theme, streak),

                const SizedBox(height: AppSpacing.xl),

                // Verse of the day card
                _verseCard(context, ref, verse, theme),

                const SizedBox(height: AppSpacing.xxl),

                // Spiritual Growth & Word
                _spiritualGrowthSection(context, theme),

                const SizedBox(height: AppSpacing.xxl),

                // Quick actions
                Text(
                  'COMMUNITY & MINISTRY',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _quickActionsGrid(context, theme),

                const SizedBox(height: AppSpacing.xxl),

                // Sunday & Meeting Moments (Instagram feed)
                _sundayFeedSection(context, feedPosts, theme),

                const SizedBox(height: AppSpacing.xxl),

                // Announcements
                if (announcements.isNotEmpty) ...[
                  Text(
                    'ANNOUNCEMENTS',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...announcements.map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _announcementCard(a.title, a.content, a.adminName, a.isPinned, theme),
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.xxl),

                // Upcoming events
                Text(
                  'UPCOMING EVENTS',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...events.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _eventCard(e, context, theme, ref),
                  ),
                ),

                const SizedBox(height: AppSpacing.massive),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMark(ThemeData theme) => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: theme.colorScheme.primary,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
    ),
    child: Center(
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
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
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _streakHeroBanner(BuildContext context, ThemeData theme, QuestStreak streak) {
    return InkWell(
      onTap: () => context.push('/quests'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB8614A), Color(0xFFC7784E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.terracotta.withAlpha(50),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('🔥', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${streak.currentStreak} Day Streak',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '⚡ ${streak.xpPoints} XP',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    streak.completedBibleReadingToday && streak.completedDevotionalToday
                        ? 'All daily quests finished! Keep the fire burning.'
                        : 'Tap to view daily quests & milestone badges',
                    style: TextStyle(
                      color: Colors.white.withAlpha(220),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _verseCard(BuildContext context, WidgetRef ref, Map<String, String> verse, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VERSE OF THE DAY',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              verse['text']!,
              style: theme.textTheme.titleLarge?.copyWith(height: 1.4),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              verse['reference']!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Start here. The rest can wait.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(gamificationNotifierProvider.notifier).recordDailyAction(
                          devotional: true,
                          bonusXp: 10,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Amen! +10 XP added to your devotional streak 🔥'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.favorite_rounded, size: 16),
                  label: const Text('Amen'),
                ),
                const SizedBox(width: AppSpacing.md),
                FilledButton.tonalIcon(
                  onPressed: () {
                    context.push('/notes', extra: verse['reference']);
                  },
                  icon: const Icon(Icons.edit_note_rounded, size: 18),
                  label: const Text('Journal Note'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _spiritualGrowthSection(BuildContext context, ThemeData theme) {
    final features = [
      (
        icon: Icons.menu_book_rounded,
        title: 'Bible Reader',
        subtitle: '66 Books & Search',
        route: '/bible',
        color: AppColors.terracotta,
      ),
      (
        icon: Icons.auto_stories_rounded,
        title: 'Reading Plans',
        subtitle: 'Youth Devotionals',
        route: '/reading-plans',
        color: AppColors.sage,
      ),
      (
        icon: Icons.edit_note_rounded,
        title: 'Sermon Notes',
        subtitle: 'Personal Journal',
        route: '/notes',
        color: AppColors.burntAmber,
      ),
      (
        icon: Icons.celebration_outlined,
        title: 'Testimony Wall',
        subtitle: 'Answered Prayers',
        route: '/testimonies',
        color: AppColors.oliveClay,
      ),
      (
        icon: Icons.quiz_outlined,
        title: 'Bible Trivia',
        subtitle: 'Timed Challenges',
        route: '/trivia',
        color: const Color(0xFF6B5282),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SPIRITUAL GROWTH & WORD',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/quests'),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: AppColors.terracotta,
              ),
              child: const Text('View Quests'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: features.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (ctx, idx) {
              final f = features[idx];
              return InkWell(
                onTap: () => context.push(f.route),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(70),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.dividerColor.withAlpha(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: f.color.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(f.icon, size: 18, color: f.color),
                      ),
                      const Spacer(),
                      Text(
                        f.title,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        f.subtitle,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.muted,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _quickActionsGrid(BuildContext context, ThemeData theme) {
    final actions = [
      (
        icon: Icons.volunteer_activism_outlined,
        label: 'Prayer\nRequest',
        route: '/prayer-requests',
        color: AppColors.healing,
      ),
      (
        icon: Icons.description_outlined,
        label: 'Submit\nPetition',
        route: '/petitions',
        color: AppColors.family,
      ),
      (
        icon: Icons.psychology_outlined,
        label: 'Ask for\nAdvice',
        route: '/advice',
        color: AppColors.spiritualGrowth,
      ),
      (
        icon: Icons.forum_outlined,
        label: 'Community\nForum',
        route: '/community',
        color: AppColors.education,
      ),
      (
        icon: Icons.auto_awesome,
        label: 'Daily\nInspiration',
        route: '/inspiration',
        color: AppColors.thanksgiving,
      ),
      (
        icon: Icons.event_outlined,
        label: 'Church\nEvents',
        route: '/events',
        color: AppColors.financial,
      ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.95,
      children: actions.map((a) {
        return InkWell(
          onTap: () {
            if (['/community', '/inspiration', '/events'].contains(a.route)) {
              context.go(a.route);
            } else {
              context.push(a.route);
            }
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: a.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    ),
                    child: Icon(a.icon, color: a.color, size: 22),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    a.label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _announcementCard(String title, String content, String admin, bool pinned, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (pinned) ...[
                  Icon(
                    Icons.push_pin_outlined,
                    size: 14,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '— $admin',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventCard(ChurchEvent event, BuildContext context, ThemeData theme, WidgetRef ref) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final time = event.startTime;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showEventDetailsSheet(context, event, ref),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${time.day}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      months[time.month - 1],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
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
                      event.title,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    if (event.location != null && event.location!.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meetingHighlightsRow(
    BuildContext context,
    List<ChurchFeedPost> posts,
    ThemeData theme,
  ) {
    if (posts.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length,
        separatorBuilder: (context, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) {
          final post = posts[i];
          final img = post.imageUrls.firstOrNull ?? '';
          return GestureDetector(
            onTap: () => context.push('/feed'),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.terracotta,
                        AppColors.burntAmber,
                        AppColors.glow,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.colorScheme.surface,
                    child: ClipOval(
                      child: img.isNotEmpty
                          ? Image.network(
                              img,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.church_rounded, size: 24),
                            )
                          : const Icon(Icons.church_rounded, size: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 76,
                  child: Text(
                    post.meetingType,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sundayFeedSection(
    BuildContext context,
    List<ChurchFeedPost> posts,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.photo_camera_rounded,
                  size: 16,
                  color: AppColors.terracotta,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'SUNDAY & MEETING MOMENTS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => context.push('/feed'),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Highlights from every Sunday and fellowship gathering',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _meetingHighlightsRow(context, posts, theme),
        const SizedBox(height: AppSpacing.md),
        if (posts.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 40,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'No meeting pictures posted yet.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...posts.take(3).map((post) => ChurchFeedCard(post: post)),
      ],
    );
  }
}
