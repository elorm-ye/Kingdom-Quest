import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/petition.dart';
import '../../../shared/services/mock_data_service.dart';

class PetitionsScreen extends StatelessWidget {
  const PetitionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final petitions = MockDataService.petitions;

    return Scaffold(
      backgroundColor: isDark ? AppColors.umberNight : AppColors.sand,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: Text('Petitions', style: GoogleFonts.bricolageGrotesque(fontSize: 20, fontWeight: FontWeight.w600)),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.push('/submit-petition'), child: const Icon(Icons.add)),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.xl),
        itemCount: petitions.length,
        itemBuilder: (context, i) {
          final p = petitions[i];
          final statusColor = switch (p.status) {
            PetitionStatus.pending => isDark ? AppColors.glow : AppColors.oliveClay,
            PetitionStatus.underReview => AppColors.burntAmber,
            PetitionStatus.resolved => AppColors.sage,
          };
          final card = isDark ? AppColors.espresso : AppColors.linen;

          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                  child: Text(p.status.label, style: GoogleFonts.schibstedGrotesk(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                ),
                const Spacer(),
                Text(_timeAgo(p.createdAt), style: GoogleFonts.schibstedGrotesk(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
              ]),
              const SizedBox(height: AppSpacing.md),
              Text(p.subject, style: GoogleFonts.bricolageGrotesque(
                  fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.umber)),
              const SizedBox(height: AppSpacing.sm),
              Text(p.description, maxLines: 3, overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.schibstedGrotesk(fontSize: 13, height: 1.5, color: isDark ? AppColors.textSecondaryDark : AppColors.muted)),
              const SizedBox(height: AppSpacing.md),
              Row(children: [
                Icon(Icons.person_outline, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.muted),
                const SizedBox(width: 4),
                Text(p.isAnonymous ? (p.anonymousDisplayName ?? 'Anonymous') : (p.submitterName ?? 'Member'),
                    style: GoogleFonts.schibstedGrotesk(fontSize: 12, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
              ]),
            ]),
          ).animate(delay: Duration(milliseconds: 100 * i)).fadeIn(duration: 400.ms).slideY(begin: 0.05);
        },
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
