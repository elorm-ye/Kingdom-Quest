import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/advice_request.dart';
import '../../../shared/services/mock_data_service.dart';

class AdviceScreen extends StatelessWidget {
  const AdviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final requests = MockDataService.adviceRequests;

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
          'Advice Center',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/submit-advice'),
        child: const HugeIcon(icon: HugeIcons.strokeRoundedAdd01),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.xl),
        itemCount: requests.length,
        itemBuilder: (context, i) {
          final a = requests[i];
          final card = isDark ? AppColors.espresso : AppColors.linen;
          final statusColor = switch (a.status) {
            AdviceStatus.pending =>
              isDark ? AppColors.glow : AppColors.oliveClay,
            AdviceStatus.inProgress => AppColors.burntAmber,
            AdviceStatus.completed => AppColors.sage,
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
                            a.status.label,
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          a.isAnonymous
                              ? (a.anonymousDisplayName ?? 'Anonymous')
                              : (a.submitterName ?? 'Member'),
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      a.title,
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.umber,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      a.description,
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
                    if (a.responses.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Divider(
                        color: isDark
                            ? const Color(0xFF3D2E25)
                            : const Color(0xFFE5D9C9),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Response from ${a.responses.first.adminName}',
                        style: GoogleFonts.schibstedGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.accentLinkDark
                              : AppColors.terracotta,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        a.responses.first.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.schibstedGrotesk(
                          fontSize: 12,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.muted,
                        ),
                      ),
                      if (a.responses.first.bibleReferences.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.xs,
                          children: a.responses.first.bibleReferences
                              .map(
                                (ref) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.plumDusk
                                        : AppColors.sand,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    ref,
                                    style: GoogleFonts.schibstedGrotesk(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.glow
                                          : AppColors.terracotta,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ],
                ),
              )
              .animate(delay: Duration(milliseconds: 100 * i))
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05);
        },
      ),
    );
  }
}
