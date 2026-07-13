import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/services/mock_data_service.dart';

class InspirationScreen extends StatelessWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final posts = MockDataService.inspirations;

    return Scaffold(
      backgroundColor: isDark ? AppColors.umberNight : AppColors.sand,
      appBar: AppBar(
        title: Text('Daily Inspiration', style: GoogleFonts.bricolageGrotesque(fontSize: 20, fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.xl),
        itemCount: posts.length,
        itemBuilder: (context, i) {
          final p = posts[i];
          final card = isDark ? AppColors.espresso : AppColors.linen;
          final typeColor = switch (p.type.name) {
            'motivation' => AppColors.terracotta,
            'challenge' => AppColors.sage,
            'devotional' => AppColors.burntAmber,
            'verse' => AppColors.oliveClay,
            _ => AppColors.terracotta,
          };

          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                  child: Text(p.type.label, style: GoogleFonts.schibstedGrotesk(fontSize: 10, fontWeight: FontWeight.w600, color: typeColor)),
                ),
                const Spacer(),
                Text(_timeAgo(p.createdAt), style: GoogleFonts.schibstedGrotesk(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
              ]),
              const SizedBox(height: AppSpacing.lg),
              Text(p.title, style: GoogleFonts.bricolageGrotesque(fontSize: 18, fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.umber)),
              const SizedBox(height: AppSpacing.md),
              Text(p.content, style: GoogleFonts.schibstedGrotesk(fontSize: 14, height: 1.6,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.muted)),
              if (p.bibleReference != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(p.bibleReference!, style: GoogleFonts.schibstedGrotesk(fontSize: 13, fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.accentLinkDark : AppColors.terracotta)),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(children: [
                Text('— ${p.adminName}', style: GoogleFonts.schibstedGrotesk(fontSize: 12, fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textMutedDark : AppColors.muted)),
              ]),
              const SizedBox(height: AppSpacing.lg),
              Divider(color: isDark ? const Color(0xFF3D2E25) : const Color(0xFFE5D9C9)),
              const SizedBox(height: AppSpacing.md),
              Row(children: [
                _actionBtn(Icons.favorite, p.isLikedByUser ? AppColors.terracotta : (isDark ? AppColors.textMutedDark : AppColors.muted),
                    '${p.likeCount}', isDark),
                const SizedBox(width: AppSpacing.xl),
                _actionBtn(Icons.chat_bubble_outline, isDark ? AppColors.textMutedDark : AppColors.muted,
                    '${p.commentCount}', isDark),
                const Spacer(),
                _actionBtn(Icons.share_outlined, isDark ? AppColors.textMutedDark : AppColors.muted, 'Share', isDark),
              ]),
            ]),
          ).animate(delay: Duration(milliseconds: 100 * i)).fadeIn(duration: 400.ms).slideY(begin: 0.05);
        },
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, String label, bool isDark) => Row(children: [
    Icon(icon, size: 18, color: color),
    const SizedBox(width: 4),
    Text(label, style: GoogleFonts.schibstedGrotesk(fontSize: 12, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
  ]);

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
