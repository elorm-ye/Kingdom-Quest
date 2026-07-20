import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/mock_data_service.dart';

/// Admin forum moderation — review reported posts and remove content.
class AdminForumScreen extends StatefulWidget {
  const AdminForumScreen({super.key});

  @override
  State<AdminForumScreen> createState() => _AdminForumScreenState();
}

class _AdminForumScreenState extends State<AdminForumScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ForumPost> _posts;
  late List<ForumPost> _reported;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _posts = List.from(MockDataService.forumPosts);
    // Simulate 2 reported posts for the demo
    _reported = _posts.take(2).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _removePost(ForumPost post, bool fromReported) {
    setState(() {
      if (fromReported) _reported.removeWhere((p) => p.id == post.id);
      _posts.removeWhere((p) => p.id == post.id);
    });
  }

  void _dismissReport(ForumPost post) {
    setState(() => _reported.removeWhere((p) => p.id == post.id));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;

    return Scaffold(
      backgroundColor: bg,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: bg,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Forum Moderation',
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: primary,
              labelColor: primary,
              unselectedLabelColor: textMuted,
              labelStyle: GoogleFonts.schibstedGrotesk(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              unselectedLabelStyle: GoogleFonts.schibstedGrotesk(fontSize: 13),
              tabs: [
                Tab(text: 'Reported (${_reported.length})'),
                Tab(text: 'All Posts (${_posts.length})'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ── REPORTED TAB ──
            _reported.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.done_all_rounded,
                          size: 56,
                          color: AppColors.sage.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No reports — all clear!',
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 16,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _reported.length,
                    itemBuilder: (ctx, i) => _ForumAdminCard(
                      post: _reported[i],
                      isReported: true,
                      isDark: isDark,
                      primary: primary,
                      surface: surface,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                      onRemove: () => _removePost(_reported[i], true),
                      onDismiss: () => _dismissReport(_reported[i]),
                      index: i,
                    ),
                  ),

            // ── ALL POSTS TAB ──
            ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _posts.length,
              itemBuilder: (ctx, i) => _ForumAdminCard(
                post: _posts[i],
                isReported: false,
                isDark: isDark,
                primary: primary,
                surface: surface,
                textPrimary: textPrimary,
                textMuted: textMuted,
                onRemove: () => _removePost(_posts[i], false),
                onDismiss: () {},
                index: i,
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
  final bool isDark;
  final Color primary, surface, textPrimary, textMuted;
  final VoidCallback onRemove, onDismiss;
  final int index;

  const _ForumAdminCard({
    required this.post,
    required this.isReported,
    required this.isDark,
    required this.primary,
    required this.surface,
    required this.textPrimary,
    required this.textMuted,
    required this.onRemove,
    required this.onDismiss,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            border: isReported
                ? Border.all(
                    color: AppColors.alert.withValues(alpha: 0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
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
                        color: primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_off_outlined,
                        size: 16,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.displayName,
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          '${post.commentCount} comments · ${post.voteScore >= 0 ? '+' : ''}${post.voteScore} votes',
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 10,
                            color: textMuted,
                          ),
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
                          color: AppColors.alert.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Reported',
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.alert,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  post.title,
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.content,
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 13,
                    color: textMuted,
                    height: 1.4,
                  ),
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
                        child: Text(
                          'Dismiss',
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 11,
                            color: textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: surface,
                            title: Text(
                              'Remove Post?',
                              style: GoogleFonts.bricolageGrotesque(
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            content: Text(
                              'This action cannot be undone.',
                              style: GoogleFonts.schibstedGrotesk(
                                color: textMuted,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.schibstedGrotesk(
                                    color: textMuted,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  onRemove();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.alert,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Remove',
                                  style: GoogleFonts.schibstedGrotesk(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 14,
                      ),
                      label: Text(
                        'Remove',
                        style: GoogleFonts.schibstedGrotesk(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        backgroundColor: AppColors.alert,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: index * 60))
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
