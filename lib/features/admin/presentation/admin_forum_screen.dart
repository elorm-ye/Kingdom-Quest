import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../core/providers/feature_providers.dart';

/// Admin forum moderation — review reported posts and remove content.
class AdminForumScreen extends ConsumerStatefulWidget {
  const AdminForumScreen({super.key});

  @override
  ConsumerState<AdminForumScreen> createState() => _AdminForumScreenState();
}

class _AdminForumScreenState extends ConsumerState<AdminForumScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _removePost(ForumPost post) {
    ref.read(forumNotifierProvider.notifier).removePost(post.id);
  }

  void _dismissReport(ForumPost post) {
    ref.read(forumNotifierProvider.notifier).dismissReport(post.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final asyncPosts = ref.watch(forumPostsStreamProvider);
    final posts = asyncPosts.value ?? [];
    // For now, reported posts are a placeholder — integrate with a reports stream later
    final reported = <ForumPost>[];

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            pinned: true,
            title: const Text('Forum Moderation'),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Reported (${reported.length})'),
                Tab(text: 'All Posts (${posts.length})'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ── REPORTED TAB ──
            reported.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.done_all_rounded,
                          size: 56,
                          color: AppColors.healing.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No reports — all clear!',
                          style: textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: reported.length,
                    itemBuilder: (ctx, i) => _ForumAdminCard(
                      post: reported[i],
                      isReported: true,
                      theme: theme,
                      onRemove: () => _removePost(reported[i]),
                      onDismiss: () => _dismissReport(reported[i]),
                    ),
                  ),

            // ── ALL POSTS TAB ──
            ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: posts.length,
              itemBuilder: (ctx, i) => _ForumAdminCard(
                post: posts[i],
                isReported: false,
                theme: theme,
                onRemove: () => _removePost(posts[i]),
                onDismiss: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForumAdminCard extends StatelessWidget {
  final ForumPost post;
  final bool isReported;
  final ThemeData theme;
  final VoidCallback onRemove, onDismiss;

  const _ForumAdminCard({
    required this.post,
    required this.isReported,
    required this.theme,
    required this.onRemove,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        shape: isReported
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                side: BorderSide(
                  color: colorScheme.error.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_off_outlined,
                      size: 16,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.displayName,
                        style: textTheme.labelMedium,
                      ),
                      Text(
                        '${post.commentCount} comments · ${post.voteScore >= 0 ? '+' : ''}${post.voteScore} votes',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (isReported)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Reported',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                post.title,
                style: textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                post.content,
                style: textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isReported) ...[
                    TextButton(
                      onPressed: onDismiss,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Dismiss'),
                    ),
                    const SizedBox(width: 4),
                  ],
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Remove Post?'),
                          content: const Text('This action cannot be undone.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                onRemove();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.error,
                                foregroundColor: colorScheme.onError,
                              ),
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline_rounded, size: 14),
                    label: const Text('Remove'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
