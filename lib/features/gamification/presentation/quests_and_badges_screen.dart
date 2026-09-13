import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/gamification_models.dart';
import '../../../shared/widgets/app_pop_scope.dart';

class QuestsAndBadgesScreen extends ConsumerWidget {
  const QuestsAndBadgesScreen({super.key});

  void _showBadgeDetail(BuildContext context, MilestoneBadge badge) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badge.isUnlocked
                        ? AppColors.glow.withAlpha(40)
                        : Colors.grey.withAlpha(30),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: badge.isUnlocked ? AppColors.burntAmber : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    badge.iconEmoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  badge.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.terracotta.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge.category,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.terracotta,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  badge.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.muted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (badge.isUnlocked) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.sage, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'Unlocked Milestone!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.sage,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: badge.target > 0
                          ? (badge.progress / badge.target).clamp(0.0, 1.0)
                          : 0.0,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.terracotta),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Progress: ${badge.progress} / ${badge.target}',
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.muted),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.terracotta,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Awesome'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final asyncGamification = ref.watch(gamificationNotifierProvider);

    final gamificationState = asyncGamification.value ??
        const GamificationState(
          streak: QuestStreak(currentStreak: 1, longestStreak: 1, xpPoints: 50),
          badges: [],
        );

    final streak = gamificationState.streak;
    final badges = gamificationState.badges;

    return AppPopScope(
      fallbackRoute: '/home',
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(fallbackRoute: '/home'),
          title: const Text('Daily Quests & Badges'),
          actions: [
            IconButton(
              icon: const Icon(Icons.quiz_outlined),
              tooltip: 'Weekly Trivia',
              onPressed: () => context.push('/trivia'),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            // Hero Streak & XP Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB8614A), Color(0xFFC7784E), Color(0xFFD68A57)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.terracotta.withAlpha(60),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 40)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${streak.currentStreak} Day Streak!',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Personal Best: ${streak.longestStreak} days',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withAlpha(220),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withAlpha(60)),
                        ),
                        child: Column(
                          children: [
                            const Text('⚡ XP', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            Text(
                              '${streak.xpPoints}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_moon_outlined, color: Colors.amberAccent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            streak.currentStreak >= 3
                                ? 'Fervent in Spirit unlocked! Keep the fire burning.'
                                : 'Reach a 3-day streak to unlock the "Fervent in Spirit" badge!',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Daily Quests Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Spiritual Quests',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Reset at midnight',
                  style: theme.textTheme.labelSmall?.copyWith(color: AppColors.muted),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Quest 1: Bible Reading
            _buildQuestCard(
              context: context,
              theme: theme,
              title: 'Read Scripture in Bible Reader',
              subtitle: 'Spend intentional moments meditating on God\'s Word',
              isCompleted: streak.completedBibleReadingToday,
              xpReward: 10,
              icon: Icons.menu_book_rounded,
              actionLabel: 'Read',
              onAction: () => context.push('/bible'),
              onToggle: (checked) {
                ref.read(gamificationNotifierProvider.notifier).recordDailyAction(
                      bibleReading: checked ?? false,
                      bonusXp: 10,
                    );
              },
            ),
            const SizedBox(height: 10),

            // Quest 2: Devotional / Journal Note
            _buildQuestCard(
              context: context,
              theme: theme,
              title: 'Write Devotional or Sermon Reflection',
              subtitle: 'Record what the Holy Spirit is teaching you today',
              isCompleted: streak.completedDevotionalToday,
              xpReward: 15,
              icon: Icons.edit_note_rounded,
              actionLabel: 'Journal',
              onAction: () => context.push('/notes'),
              onToggle: (checked) {
                ref.read(gamificationNotifierProvider.notifier).recordDailyAction(
                      devotional: checked ?? false,
                      bonusXp: 15,
                    );
              },
            ),
            const SizedBox(height: 10),

            // Quest 3: Prayer
            _buildQuestCard(
              context: context,
              theme: theme,
              title: 'Lift Up a Brother or Sister in Prayer',
              subtitle: 'Stand in the gap on the church prayer wall',
              isCompleted: streak.completedPrayerToday,
              xpReward: 10,
              icon: Icons.volunteer_activism_rounded,
              actionLabel: 'Pray',
              onAction: () => context.push('/prayer-requests'),
              onToggle: (checked) {
                ref.read(gamificationNotifierProvider.notifier).recordDailyAction(
                      prayer: checked ?? false,
                      bonusXp: 10,
                    );
                ref.read(gamificationNotifierProvider.notifier).incrementBadge('shield_of_faith');
              },
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Weekly Trivia Promo Card
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/trivia'),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: isDark ? theme.colorScheme.surfaceContainerHighest : AppColors.linen,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.burntAmber.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.burntAmber.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('👑', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Bible Trivia Challenge',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Timed multiple-choice quizzes with instant scripture explanations.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.terracotta),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Milestone Badges Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Milestone Badges',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${badges.where((b) => b.isUnlocked).length} of ${badges.length} Unlocked',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.terracotta,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Badges Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: badges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (ctx, idx) {
                final badge = badges[idx];
                final isUnlocked = badge.isUnlocked;

                return InkWell(
                  onTap: () => _showBadgeDetail(context, badge),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? (isDark ? const Color(0xFF231B15) : const Color(0xFFFFF9F2))
                          : theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isUnlocked
                            ? AppColors.burntAmber.withAlpha(120)
                            : theme.dividerColor.withAlpha(40),
                        width: isUnlocked ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          badge.iconEmoji,
                          style: TextStyle(
                            fontSize: 32,
                            color: isUnlocked ? null : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          badge.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isUnlocked ? null : AppColors.muted,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (isUnlocked) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle, size: 12, color: AppColors.sage),
                              const SizedBox(width: 4),
                              Text(
                                'Unlocked',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.sage,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: badge.target > 0
                                  ? (badge.progress / badge.target).clamp(0.0, 1.0)
                                  : 0.0,
                              minHeight: 4,
                              backgroundColor: theme.dividerColor.withAlpha(40),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.terracotta,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${badge.progress}/${badge.target}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestCard({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required int xpReward,
    required IconData icon,
    required String actionLabel,
    required VoidCallback onAction,
    required ValueChanged<bool?> onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.sage.withAlpha(15)
            : theme.colorScheme.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted ? AppColors.sage.withAlpha(80) : theme.dividerColor.withAlpha(40),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isCompleted,
            activeColor: AppColors.sage,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: onToggle,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.terracotta.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+$xpReward XP',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.terracotta,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: AppColors.terracotta,
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
