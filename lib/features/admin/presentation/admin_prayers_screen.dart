import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/mock_data_service.dart';

/// Admin prayer requests management — respond, mark answered.
class AdminPrayersScreen extends StatefulWidget {
  const AdminPrayersScreen({super.key});

  @override
  State<AdminPrayersScreen> createState() => _AdminPrayersScreenState();
}

class _AdminPrayersScreenState extends State<AdminPrayersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<PrayerRequest> _prayers;
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _prayers = List.from(MockDataService.prayerRequests);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  List<PrayerRequest> _filtered(String status) =>
      _prayers.where((p) => p.status.name == status).toList();

  void _markAnswered(PrayerRequest p) {
    setState(() {
      final idx = _prayers.indexWhere((x) => x.id == p.id);
      if (idx != -1) {
        _prayers[idx] = PrayerRequest(
          id: p.id,
          userId: p.userId,
          title: p.title,
          description: p.description,
          category: p.category,
          isAnonymous: p.isAnonymous,
          submitterName: p.submitterName,
          anonymousDisplayName: p.anonymousDisplayName,
          status: PrayerStatus.answered,
          prayerCount: p.prayerCount,
          responses: p.responses,
          createdAt: p.createdAt,
        );
      }
    });
  }

  void _showReplySheet(
    BuildContext context,
    PrayerRequest p,
    bool isDark,
    Color primary,
    Color surface,
    Color textPrimary,
    Color textMuted,
  ) {
    _replyController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusSection),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Reply to Prayer Request',
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              p.title,
              style: GoogleFonts.schibstedGrotesk(
                fontSize: 13,
                color: textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _replyController,
              maxLines: 5,
              style: GoogleFonts.schibstedGrotesk(
                fontSize: 14,
                color: textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Write your pastoral response...',
                hintStyle: GoogleFonts.schibstedGrotesk(color: textMuted),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_replyController.text.trim().isNotEmpty) {
                    Navigator.pop(ctx);
                    _markAnswered(p);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Response sent & marked as answered',
                          style: GoogleFonts.schibstedGrotesk(),
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Send Response',
                  style: GoogleFonts.schibstedGrotesk(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              'Prayer Requests',
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
              unselectedLabelStyle: GoogleFonts.schibstedGrotesk(
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: 'Pending (${_filtered('pending').length})'),
                Tab(text: 'Praying (${_filtered('praying').length})'),
                Tab(text: 'Answered (${_filtered('answered').length})'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: ['pending', 'praying', 'answered'].map((status) {
            final list = _filtered(status);
            if (list.isEmpty) {
              return Center(
                child: Text(
                  'No $status requests',
                  style: GoogleFonts.schibstedGrotesk(color: textMuted),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: list.length,
              itemBuilder: (ctx, i) => _PrayerAdminCard(
                prayer: list[i],
                isDark: isDark,
                primary: primary,
                surface: surface,
                textPrimary: textPrimary,
                textMuted: textMuted,
                onReply: () => _showReplySheet(
                  context,
                  list[i],
                  isDark,
                  primary,
                  surface,
                  textPrimary,
                  textMuted,
                ),
                onMarkAnswered: () => _markAnswered(list[i]),
                index: i,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _PrayerAdminCard extends StatelessWidget {
  final PrayerRequest prayer;
  final bool isDark;
  final Color primary, surface, textPrimary, textMuted;
  final VoidCallback onReply, onMarkAnswered;
  final int index;

  const _PrayerAdminCard({
    required this.prayer,
    required this.isDark,
    required this.primary,
    required this.surface,
    required this.textPrimary,
    required this.textMuted,
    required this.onReply,
    required this.onMarkAnswered,
    required this.index,
  });

  Color _categoryColor() {
    switch (prayer.category) {
      case PrayerCategory.healing:
        return AppColors.sage;
      case PrayerCategory.financial:
        return AppColors.oliveClay;
      case PrayerCategory.education:
        return const Color(0xFF5A7A9B);
      case PrayerCategory.family:
        return AppColors.burntAmber;
      case PrayerCategory.thanksgiving:
        return AppColors.glow;
      default:
        return AppColors.terracotta;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor();
    final name = prayer.isAnonymous
        ? (prayer.anonymousDisplayName ?? 'Anonymous Member')
        : (prayer.submitterName ?? 'Member');

    return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: catColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusCard),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: catColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                          ),
                          child: Text(
                            prayer.category.label,
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: catColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedFavourite,
                          size: 12,
                          color: textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${prayer.prayerCount}',
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 11,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      prayer.title,
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prayer.description,
                      style: GoogleFonts.schibstedGrotesk(
                        fontSize: 13,
                        color: textMuted,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          prayer.isAnonymous
                              ? Icons.person_off_outlined
                              : Icons.person_outline,
                          size: 13,
                          color: textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          name,
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 11,
                            color: textMuted,
                          ),
                        ),
                        const Spacer(),
                        if (prayer.status != PrayerStatus.answered) ...[
                          TextButton(
                            onPressed: onMarkAnswered,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              'Mark Answered',
                              style: GoogleFonts.schibstedGrotesk(
                                fontSize: 11,
                                color: AppColors.sage,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: onReply,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              minimumSize: Size.zero,
                              backgroundColor: primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusFull,
                                ),
                              ),
                            ),
                            child: Text(
                              'Respond',
                              style: GoogleFonts.schibstedGrotesk(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ] else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sage.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull,
                              ),
                            ),
                            child: Text(
                              '✓ Answered',
                              style: GoogleFonts.schibstedGrotesk(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.sage,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (prayer.responses.isNotEmpty) ...[
                      const Divider(height: 16),
                      ...prayer.responses.map(
                        (r) => Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusChip,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowTurnBackward,
                                size: 14,
                                color: primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  r.message,
                                  style: GoogleFonts.schibstedGrotesk(
                                    fontSize: 12,
                                    color: textMuted,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: Duration(milliseconds: index * 60))
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
