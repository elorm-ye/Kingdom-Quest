import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/models/event.dart';
import '../../events/presentation/widgets/event_details_sheet.dart';

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

                const SizedBox(height: AppSpacing.xxl),

                // Verse of the day card
                _verseCard(verse, theme),

                const SizedBox(height: AppSpacing.xxl),

                // Quick actions
                Text(
                  'QUICK ACTIONS',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _quickActionsGrid(context, theme),

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

  Widget _verseCard(Map<String, String> verse, ThemeData theme) {
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
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Amen'),
                ),
                const SizedBox(width: AppSpacing.md),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
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
}
