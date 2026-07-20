import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/prayer_request.dart';
import '../../../shared/services/mock_data_service.dart';

class PrayerRequestsScreen extends StatefulWidget {
  const PrayerRequestsScreen({super.key});
  @override
  State<PrayerRequestsScreen> createState() => _PrayerRequestsScreenState();
}

class _PrayerRequestsScreenState extends State<PrayerRequestsScreen> {
  PrayerCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final requests = MockDataService.prayerRequests
        .where(
          (r) => _selectedCategory == null || r.category == _selectedCategory,
        )
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.umberNight : AppColors.sand,
      appBar: AppBar(
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Prayer Requests',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/submit-prayer'),
        child: const HugeIcon(icon: HugeIcons.strokeRoundedAdd01),
      ),
      body: Column(
        children: [
          // Category filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              children: [
                _chip(
                  'All',
                  _selectedCategory == null,
                  () => setState(() => _selectedCategory = null),
                  isDark,
                ),
                ...PrayerCategory.values.map(
                  (c) => _chip(
                    '${c.icon} ${c.label}',
                    _selectedCategory == c,
                    () => setState(() => _selectedCategory = c),
                    isDark,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              itemCount: requests.length,
              itemBuilder: (context, i) => _requestCard(requests[i], isDark)
                  .animate(delay: Duration(milliseconds: 100 * i))
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.05),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap, bool isDark) {
    final bg = selected
        ? (isDark ? AppColors.burntAmber : AppColors.terracotta)
        : (isDark ? AppColors.espresso : AppColors.linen);
    final fg = selected
        ? Colors.white
        : (isDark ? AppColors.textSecondaryDark : AppColors.umber);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.schibstedGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _requestCard(PrayerRequest req, bool isDark) {
    final card = isDark ? AppColors.espresso : AppColors.linen;
    final statusColor = switch (req.status) {
      PrayerStatus.pending => isDark ? AppColors.glow : AppColors.oliveClay,
      PrayerStatus.praying => AppColors.terracotta,
      PrayerStatus.answered => AppColors.sage,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  req.status.label,
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${req.category.icon} ${req.category.label}',
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 11,
                  color: isDark ? AppColors.textMutedDark : AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            req.title,
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.umber,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            req.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.schibstedGrotesk(
              fontSize: 13,
              height: 1.5,
              color: isDark ? AppColors.textSecondaryDark : AppColors.muted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedUser,
                size: 14,
                color: isDark ? AppColors.textMutedDark : AppColors.muted,
              ),
              const SizedBox(width: 4),
              Text(
                req.isAnonymous
                    ? (req.anonymousDisplayName ?? 'Anonymous')
                    : (req.submitterName ?? 'Member'),
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 12,
                  color: isDark ? AppColors.textMutedDark : AppColors.muted,
                ),
              ),
              const Spacer(),
              HugeIcon(
                icon: HugeIcons.strokeRoundedFavourite,
                size: 14,
                color: AppColors.terracotta,
              ),
              const SizedBox(width: 4),
              Text(
                '${req.prayerCount} praying',
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 12,
                  color: isDark ? AppColors.textMutedDark : AppColors.muted,
                ),
              ),
            ],
          ),
          if (req.responses.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Divider(
              color: isDark ? const Color(0xFF3D2E25) : const Color(0xFFE5D9C9),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedReply,
                  size: 14,
                  color: isDark
                      ? AppColors.accentLinkDark
                      : AppColors.terracotta,
                ),
                const SizedBox(width: 4),
                Text(
                  'Response from ${req.responses.first.adminName}',
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.accentLinkDark
                        : AppColors.terracotta,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              req.responses.first.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.schibstedGrotesk(
                fontSize: 12,
                height: 1.4,
                fontStyle: FontStyle.italic,
                color: isDark ? AppColors.textSecondaryDark : AppColors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
