import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/mock_data_service.dart';

/// Events & Announcements screen — tabbed layout.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ChurchEvent> _events;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _events = List.from(MockDataService.events);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleRegistration(int index) {
    final e = _events[index];
    setState(() {
      _events[index] = ChurchEvent(
        id: e.id,
        churchId: e.churchId,
        title: e.title,
        description: e.description,
        location: e.location,
        startTime: e.startTime,
        endTime: e.endTime,
        isRecurring: e.isRecurring,
        recurringPattern: e.recurringPattern,
        createdBy: e.createdBy,
        registrationCount: e.isRegistered
            ? e.registrationCount - 1
            : e.registrationCount + 1,
        isRegistered: !e.isRegistered,
        createdAt: e.createdAt,
      );
    });
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final min = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day} · $hour:$min $period';
  }

  String _daysLabel(DateTime dt) {
    final days = dt.difference(DateTime.now()).inDays;
    if (days < 0) return 'Past';
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return 'In $days days';
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;
    final announcements = MockDataService.announcements;

    return Scaffold(
      backgroundColor: bg,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: bg,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: AppSpacing.lg,
                bottom: 60,
              ),
              title: Text(
                'Events & News',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: primary,
              indicatorWeight: 2.5,
              labelColor: primary,
              unselectedLabelColor: textMuted,
              labelStyle: GoogleFonts.schibstedGrotesk(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.schibstedGrotesk(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Upcoming Events'),
                Tab(text: 'Announcements'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ── EVENTS TAB ──
            ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _events.length,
              itemBuilder: (ctx, i) {
                final e = _events[i];
                final days = e.startTime.difference(DateTime.now()).inDays;
                return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusCard,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.25 : 0.06,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.terracotta,
                                  AppColors.burntAmber,
                                ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppSpacing.radiusCard),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.title,
                                            style:
                                                GoogleFonts.bricolageGrotesque(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: textPrimary,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDateTime(e.startTime),
                                            style: GoogleFonts.schibstedGrotesk(
                                              fontSize: 12,
                                              color: textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: days <= 3
                                            ? primary.withValues(alpha: 0.12)
                                            : surface,
                                        border: Border.all(
                                          color: days <= 3
                                              ? primary
                                              : textMuted.withValues(
                                                  alpha: 0.3,
                                                ),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusFull,
                                        ),
                                      ),
                                      child: Text(
                                        _daysLabel(e.startTime),
                                        style: GoogleFonts.schibstedGrotesk(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: days <= 3
                                              ? primary
                                              : textMuted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  e.description,
                                  style: GoogleFonts.schibstedGrotesk(
                                    fontSize: 13,
                                    color: textMuted,
                                    height: 1.5,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Row(
                                  children: [
                                    HugeIcon(
                                      icon: HugeIcons.strokeRoundedLocation01,
                                      size: 13,
                                      color: textMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        e.location ?? 'TBA',
                                        style: GoogleFonts.schibstedGrotesk(
                                          fontSize: 12,
                                          color: textMuted,
                                        ),
                                      ),
                                    ),
                                    HugeIcon(
                                      icon: HugeIcons.strokeRoundedUserMultiple,
                                      size: 13,
                                      color: textMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${e.registrationCount}',
                                      style: GoogleFonts.schibstedGrotesk(
                                        fontSize: 12,
                                        color: textMuted,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    GestureDetector(
                                      onTap: () => _toggleRegistration(i),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: e.isRegistered
                                              ? AppColors.sage
                                              : primary,
                                          borderRadius: BorderRadius.circular(
                                            AppSpacing.radiusFull,
                                          ),
                                        ),
                                        child: Text(
                                          e.isRegistered
                                              ? '✓ Joined'
                                              : 'Register',
                                          style: GoogleFonts.schibstedGrotesk(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (e.isRecurring == true) ...[
                                  const SizedBox(height: AppSpacing.sm),
                                  Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedRepeat,
                                        size: 12,
                                        color: AppColors.sage,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        e.recurringPattern ?? 'Recurring',
                                        style: GoogleFonts.schibstedGrotesk(
                                          fontSize: 11,
                                          color: AppColors.sage,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(delay: Duration(milliseconds: i * 80))
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.15, end: 0, curve: Curves.easeOut);
              },
            ),

            // ── ANNOUNCEMENTS TAB ──
            ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: announcements.length,
              itemBuilder: (ctx, i) {
                final ann = announcements[i];
                return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusCard,
                        ),
                        border: ann.isPinned
                            ? Border.all(
                                color: primary.withValues(alpha: 0.4),
                                width: 1.5,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.25 : 0.06,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (ann.isPinned) ...[
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedPin,
                                  size: 14,
                                  color: primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'PINNED',
                                  style: GoogleFonts.schibstedGrotesk(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                              const Spacer(),
                              Text(
                                _timeAgo(ann.createdAt),
                                style: GoogleFonts.schibstedGrotesk(
                                  fontSize: 11,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            ann.title,
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ann.content,
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 14,
                              color: textMuted,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedUser,
                                  size: 14,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                ann.adminName,
                                style: GoogleFonts.schibstedGrotesk(
                                  fontSize: 12,
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    .animate(delay: Duration(milliseconds: i * 80))
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.15, end: 0, curve: Curves.easeOut);
              },
            ),
          ],
        ),
      ),
    );
  }
}
