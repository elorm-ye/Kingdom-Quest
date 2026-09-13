import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'widgets/church_feed_card.dart';
import '../../../shared/widgets/app_pop_scope.dart';

/// Dedicated full screen for Sunday & Meeting Moments Feed.
class ChurchFeedScreen extends ConsumerStatefulWidget {
  const ChurchFeedScreen({super.key});

  @override
  ConsumerState<ChurchFeedScreen> createState() => _ChurchFeedScreenState();
}

class _ChurchFeedScreenState extends ConsumerState<ChurchFeedScreen> {
  String _selectedFilter = 'All';

  final _filters = [
    'All',
    'Sunday Service',
    'Youth Fellowship',
    'Midweek Service',
    'Special Programs',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final asyncPosts = ref.watch(feedPostsNotifierProvider);
    final user = ref.watch(currentUserModelProvider).value;
    final isAdmin = user?.isAdmin == true;

    return AppPopScope(
      fallbackRoute: '/home',
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(fallbackRoute: '/home'),
          title: Row(
          children: [
            const Icon(Icons.photo_camera_rounded, size: 22, color: AppColors.terracotta),
            const SizedBox(width: AppSpacing.sm),
            const Text('Church Moments'),
          ],
        ),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add_photo_alternate_rounded),
              tooltip: 'Upload Meeting Photos',
              onPressed: () => context.push('/admin/feed'),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(feedPostsNotifierProvider.notifier).refresh(),
        child: asyncPosts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: Colors.grey),
                const SizedBox(height: AppSpacing.md),
                Text('Failed to load photos', style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.tonal(
                  onPressed: () => ref.read(feedPostsNotifierProvider.notifier).refresh(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
          data: (posts) {
            final filteredPosts = _selectedFilter == 'All'
                ? posts
                : posts.where((p) => p.meetingType.toLowerCase() == _selectedFilter.toLowerCase()).toList();

            return CustomScrollView(
              slivers: [
                // Filter chips bar
                SliverToBoxAdapter(
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (context, _) => const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = _selectedFilter == filter;
                        return ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = filter);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),

                if (filteredPosts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 64,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No pictures uploaded yet for this meeting type',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (isAdmin) ...[
                            const SizedBox(height: AppSpacing.md),
                            ElevatedButton.icon(
                              onPressed: () => context.push('/admin/feed'),
                              icon: const Icon(Icons.add_a_photo_outlined),
                              label: const Text('Upload Pictures'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = filteredPosts[index];
                          return ChurchFeedCard(post: post);
                        },
                        childCount: filteredPosts.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
}
