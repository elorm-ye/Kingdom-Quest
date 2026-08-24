import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;

    return Scaffold(
      backgroundColor: isDark ? AppColors.umberNight : AppColors.sand,
      appBar: AppBar(
        title: Text(
          'Community',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
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
              color: isDark ? AppColors.espresso : AppColors.linen,
              borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
              ),
              labelColor: Colors.white,
              unselectedLabelColor:
                  isDark ? AppColors.textSecondaryDark : AppColors.muted,
              labelStyle: GoogleFonts.schibstedGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.schibstedGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            color: isDark
                ? AppColors.plumDusk
                : AppColors.terracotta.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
          ),
          child: Row(
            children: [
              Icon(
                Icons.shield_outlined,
                size: 16,
                color: isDark ? AppColors.glow : AppColors.terracotta,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'All posts are anonymous. Your identity is never revealed.',
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.umber,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            itemCount: posts.length,
            itemBuilder: (context, i) {
              final p = posts[i];
              final card = isDark ? AppColors.espresso : AppColors.linen;

              return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusCard,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.plumDusk
                                    : AppColors.terracotta.withValues(
                                        alpha: 0.1,
                                      ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_outline,
                                size: 18,
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.terracotta,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.displayName,
                                  style: GoogleFonts.schibstedGrotesk(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.umber,
                                  ),
                                ),
                                Text(
                                  _timeAgo(p.createdAt),
                                  style: GoogleFonts.schibstedGrotesk(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.textMutedDark
                                        : AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.more_horiz_rounded,
                                size: 18,
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.muted,
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
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.umber,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          p.content,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 13,
                            height: 1.5,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            _actionBtn(
                              Icons.arrow_upward,
                              '${p.voteScore}',
                              isDark,
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            _actionBtn(
                              Icons.favorite_outline,
                              '${p.likeCount}',
                              isDark,
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            _actionBtn(
                              Icons.chat_bubble_outline,
                              '${p.commentCount}',
                              isDark,
                            ),
                            const Spacer(),
                            _actionBtn(Icons.flag_outlined, 'Report', isDark),
                          ],
                        ),
                      ],
                    ),
                  )
                  .animate(delay: Duration(milliseconds: 100 * i))
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.05);
            },
          ),
        ),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, bool isDark) => Row(
    children: [
      Icon(
        icon,
        size: 16,
        color: isDark ? AppColors.textMutedDark : AppColors.muted,
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: GoogleFonts.schibstedGrotesk(
          fontSize: 12,
          color: isDark ? AppColors.textMutedDark : AppColors.muted,
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
