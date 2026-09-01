import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';
import 'sermon_notes_tab.dart';

class ForumScreen extends ConsumerStatefulWidget {
  const ForumScreen({super.key});

  @override
  ConsumerState<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends ConsumerState<ForumScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search_rounded,
              size: 22,
            ),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
              ),
              labelColor: colorScheme.onPrimary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              tabs: const [
                Tab(text: 'Forum'),
                Tab(text: 'Sermon Notes'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          // Only show FAB on Forum tab (index 0)
          if (_tabController.index != 0) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: () => context.push('/create-post'),
            child: const Icon(Icons.edit_outlined),
          );
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── Forum Tab ──
          _ForumList(),
          // ── Sermon Notes Tab ──
          const SermonNotesTab(),
        ],
      ),
    );
  }
}

class _ForumList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    final asyncPosts = ref.watch(forumPostsStreamProvider);
    final posts = asyncPosts.value ?? [];

    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        // Info banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
          ),
          child: Row(
            children: [
              Icon(
                Icons.shield_outlined,
                size: 16,
                color: colorScheme.onTertiaryContainer,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'All posts are anonymous. Your identity is never revealed.',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            itemCount: posts.length,
            itemBuilder: (context, i) {
              final p = posts[i];

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
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
                                Icons.person_outline,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.displayName,
                                  style: textTheme.labelMedium,
                                ),
                                Text(
                                  _timeAgo(p.createdAt),
                                  style: textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.more_horiz_rounded,
                                size: 18,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          p.title,
                          style: textTheme.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          p.content,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            _actionBtn(
                              Icons.arrow_upward,
                              '${p.voteScore}',
                              textTheme,
                              colorScheme,
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            _actionBtn(
                              Icons.favorite_outline,
                              '${p.likeCount}',
                              textTheme,
                              colorScheme,
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            _actionBtn(
                              Icons.chat_bubble_outline,
                              '${p.commentCount}',
                              textTheme,
                              colorScheme,
                            ),
                            const Spacer(),
                            _actionBtn(Icons.flag_outlined, 'Report', textTheme, colorScheme),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, TextTheme textTheme, ColorScheme colorScheme) => Row(
    children: [
      Icon(
        icon,
        size: 16,
        color: colorScheme.onSurfaceVariant,
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
