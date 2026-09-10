import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/app_providers.dart';
import 'widgets/edit_profile_sheet.dart';

/// User profile screen — avatar, stats, activity feed.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    final asyncUser = ref.watch(currentUserModelProvider);
    final user = asyncUser.value;
    if (user == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final stats = [
      (label: 'Prayers', value: '12', icon: Icons.volunteer_activism_rounded),
      (label: 'Petitions', value: '3', icon: Icons.mail_outlined),
      (label: 'Posts', value: '8', icon: Icons.forum_outlined),
    ];

    final activities = [
      (
        icon: Icons.volunteer_activism_rounded,
        color: AppColors.healing,
        title: 'Prayer request answered',
        time: '2 days ago',
        subtitle: '"Healing for my grandmother"',
        route: '/prayer-requests',
      ),
      (
        icon: Icons.auto_awesome_rounded,
        color: AppColors.thanksgiving,
        title: 'Liked a Daily Inspiration',
        time: '3 days ago',
        subtitle: '"Start here. The rest can wait."',
        route: '/inspiration',
      ),
      (
        icon: Icons.forum_outlined,
        color: colorScheme.primary,
        title: 'Commented on forum post',
        time: '5 days ago',
        subtitle: '"How do you deal with anxiety as a Christian?"',
        route: '/community',
      ),
      (
        icon: Icons.event_rounded,
        color: AppColors.education,
        title: 'Registered for event',
        time: '1 week ago',
        subtitle: '"Youth Sunday Service"',
        route: '/events',
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── HEADER ──
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push('/settings'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Solid Header Background
                  Container(
                    color: colorScheme.surfaceContainerHighest,
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
                            color: colorScheme.primary,
                            border: Border.all(color: colorScheme.surface, width: 4),
                          ),
                          child: Center(
                            child: Text(
                              user.displayName.substring(0, 1).toUpperCase(),
                              style: textTheme.displayLarge?.copyWith(
                                color: colorScheme.onPrimary,
                                fontSize: 36,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          user.displayName,
                          style: textTheme.displayMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.church_outlined,
                              size: 13,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Kingdom Quest Youth',
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              ),
                              child: Text(
                                'Member',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontSize: 10,
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
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: stats.map((s) {
                          return Column(
                            children: [
                              Icon(s.icon, size: 22, color: colorScheme.primary),
                              const SizedBox(height: 6),
                              Text(
                                s.value,
                                style: textTheme.displaySmall,
                              ),
                              Text(
                                s.label,
                                style: textTheme.bodySmall,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── BIO ──
                if (user.bio != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'About',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              user.bio!,
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: AppSpacing.lg),

                // ── ACTIVITY FEED ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      Text(
                        'Recent Activity',
                        style: textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...activities.map((act) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: 4,
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          if (['/community', '/inspiration', '/events'].contains(act.route)) {
                            context.go(act.route);
                          } else {
                            context.push(act.route);
                          }
                        },
                        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
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
                                      style: textTheme.titleMedium,
                                    ),
                                    Text(
                                      act.subtitle,
                                      style: textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                act.time,
                                style: textTheme.bodySmall,
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: AppSpacing.xxl),

                // ── EDIT PROFILE BUTTON ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () => showEditProfileSheet(context, user, ref),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit Profile'),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
