import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';

/// Admin home — stats overview, quick-action tiles, recent activity.
class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final prayers = ref.watch(prayerRequestsNotifierProvider).value ?? [];
    final petitions = ref.watch(petitionsNotifierProvider).value ?? [];
    final advice = ref.watch(adviceNotifierProvider).value ?? [];
    final asyncUsers = ref.watch(adminUsersNotifierProvider);
    final members = asyncUsers.value?.length ?? 0;

    final pendingPrayers = prayers.where((p) => p.status.name == 'pending').length;
    final pendingPetitions = petitions.where((p) => p.status.name == 'pending').length;
    final pendingAdvice = advice.where((a) => a.status.name == 'pending').length;

    final stats = [
      (
        label: 'Members',
        value: '$members',
        icon: Icons.people_rounded,
        color: AppColors.education,
      ),
      (
        label: 'Prayers',
        value: '${prayers.length}',
        icon: Icons.volunteer_activism_rounded,
        color: AppColors.healing,
      ),
      (
        label: 'Petitions',
        value: '${petitions.length}',
        icon: Icons.mail_rounded,
        color: AppColors.family,
      ),
      (
        label: 'Advice',
        value: '${advice.length}',
        icon: Icons.lightbulb_outline_rounded,
        color: AppColors.spiritualGrowth,
      ),
    ];

    final quickActions = [
      (
        label: 'Prayers',
        subtitle: '$pendingPrayers pending',
        icon: Icons.volunteer_activism_outlined,
        color: AppColors.healing,
        route: '/admin/prayers',
      ),
      (
        label: 'Petitions',
        subtitle: '$pendingPetitions pending',
        icon: Icons.mail_outline_rounded,
        color: AppColors.family,
        route: '/admin/petitions',
      ),
      (
        label: 'Advice',
        subtitle: '$pendingAdvice pending',
        icon: Icons.lightbulb_outline_rounded,
        color: AppColors.spiritualGrowth,
        route: '/admin/advice',
      ),
      (
        label: 'Inspiration',
        subtitle: 'Publish post',
        icon: Icons.auto_awesome_outlined,
        color: AppColors.education,
        route: '/admin/inspiration',
      ),
      (
        label: 'Forum',
        subtitle: 'Moderate',
        icon: Icons.forum_outlined,
        color: AppColors.financial,
        route: '/admin/forum',
      ),
      (
        label: 'Users',
        subtitle: 'Manage',
        icon: Icons.people_outlined,
        color: AppColors.other,
        route: '/admin/users',
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: AppSpacing.lg,
                bottom: AppSpacing.lg,
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      'ADMIN',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontSize: 9,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dashboard',
                    style: textTheme.displayMedium,
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                tooltip: 'Back to member view',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── STATS GRID ──
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.7,
                    children: stats.map((s) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: s.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                                ),
                                child: Icon(s.icon, color: s.color, size: 22),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    s.value,
                                    style: textTheme.displaySmall,
                                  ),
                                  Text(
                                    s.label,
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── PENDING BANNER ──
                  if (pendingPrayers + pendingPetitions + pendingAdvice > 0)
                    Card(
                      color: colorScheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                        side: BorderSide(color: colorScheme.primary, width: 1.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                '${pendingPrayers + pendingPetitions + pendingAdvice} items need your attention',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── QUICK ACTIONS ──
                  Text(
                    'Quick Actions',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.9,
                    children: quickActions.map((a) {
                      return InkWell(
                        onTap: () => context.go(a.route),
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
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    a.icon,
                                    color: a.color,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  a.label,
                                  style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurface),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  a.subtitle,
                                  style: textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
