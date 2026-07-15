import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/services/mock_data_service.dart';

/// Admin home — stats overview, quick-action tiles, recent activity.
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;

    final prayers = MockDataService.prayerRequests;
    final petitions = MockDataService.petitions;
    final advice = MockDataService.adviceRequests;
    final members = 48; // mock total

    final pendingPrayers = prayers.where((p) => p.status.name == 'pending').length;
    final pendingPetitions = petitions.where((p) => p.status.name == 'pending').length;
    final pendingAdvice = advice.where((a) => a.status.name == 'pending').length;

    final stats = [
      (label: 'Members', value: '$members', icon: Icons.people_rounded, color: const Color(0xFF6B7FD4)),
      (label: 'Prayers', value: '${prayers.length}', icon: Icons.volunteer_activism_rounded, color: AppColors.sage),
      (label: 'Petitions', value: '${petitions.length}', icon: Icons.mail_rounded, color: AppColors.burntAmber),
      (label: 'Advice', value: '${advice.length}', icon: Icons.lightbulb_outline_rounded, color: AppColors.terracotta),
    ];

    final quickActions = [
      (label: 'Prayers', subtitle: '$pendingPrayers pending', icon: Icons.volunteer_activism_outlined, color: AppColors.sage, route: '/admin/prayers'),
      (label: 'Petitions', subtitle: '$pendingPetitions pending', icon: Icons.mail_outline_rounded, color: AppColors.burntAmber, route: '/admin/petitions'),
      (label: 'Advice', subtitle: '$pendingAdvice pending', icon: Icons.lightbulb_outline_rounded, color: AppColors.terracotta, route: '/admin/advice'),
      (label: 'Inspiration', subtitle: 'Publish post', icon: Icons.auto_awesome_outlined, color: const Color(0xFF6B7FD4), route: '/admin/inspiration'),
      (label: 'Forum', subtitle: 'Moderate', icon: Icons.forum_outlined, color: AppColors.oliveClay, route: '/admin/forum'),
      (label: 'Users', subtitle: 'Manage', icon: Icons.people_outlined, color: const Color(0xFF9B7ED4), route: '/admin/users'),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: bg,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: AppSpacing.lg, bottom: AppSpacing.lg),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      'ADMIN',
                      style: GoogleFonts.schibstedGrotesk(fontSize: 9, fontWeight: FontWeight.w800, color: primary, letterSpacing: 1.2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dashboard',
                    style: GoogleFonts.bricolageGrotesque(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app_rounded, color: textMuted),
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
                    children: stats.asMap().entries.map((e) {
                      final s = e.value;
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 10, offset: const Offset(0, 3))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(color: s.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                              child: Icon(s.icon, color: s.color, size: 22),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(s.value, style: GoogleFonts.bricolageGrotesque(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary)),
                                Text(s.label, style: GoogleFonts.schibstedGrotesk(fontSize: 12, color: textMuted)),
                              ],
                            ),
                          ],
                        ),
                      ).animate(delay: Duration(milliseconds: e.key * 60)).fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0);
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── PENDING BANNER ──
                  if (pendingPrayers + pendingPetitions + pendingAdvice > 0)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.terracotta.withValues(alpha: 0.15), AppColors.burntAmber.withValues(alpha: 0.08)]),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                        border: Border.all(color: AppColors.terracotta.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.pending_actions_rounded, color: primary, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              '${pendingPrayers + pendingPetitions + pendingAdvice} items need your attention',
                              style: GoogleFonts.schibstedGrotesk(fontSize: 13, fontWeight: FontWeight.w600, color: primary),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.xl),

                  // ── QUICK ACTIONS ──
                  Text('Quick Actions', style: GoogleFonts.bricolageGrotesque(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.9,
                    children: quickActions.asMap().entries.map((e) {
                      final a = e.value;
                      return GestureDetector(
                        onTap: () => context.go(a.route),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(color: a.color.withValues(alpha: 0.12), shape: BoxShape.circle),
                                child: Icon(a.icon, color: a.color, size: 22),
                              ),
                              const SizedBox(height: 6),
                              Text(a.label, style: GoogleFonts.schibstedGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary), textAlign: TextAlign.center),
                              Text(a.subtitle, style: GoogleFonts.schibstedGrotesk(fontSize: 10, color: textMuted), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ).animate(delay: Duration(milliseconds: 200 + e.key * 50)).fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
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
