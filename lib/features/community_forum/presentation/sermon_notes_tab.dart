import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../shared/models/sermon_note.dart';

/// Sermon Notes tab — displayed inside the Community screen TabBarView.
/// Newest sermon notes first, tap to expand full summary.
class SermonNotesTab extends ConsumerWidget {
  const SermonNotesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asyncNotes = ref.watch(sermonNotesNotifierProvider);
    final notes = asyncNotes.value ?? [];

    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 56,
              color: isDark
                  ? AppColors.textMutedDark
                  : AppColors.muted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No sermon notes yet',
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondaryDark : AppColors.muted,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Sermon summaries will appear here after Sunday services.',
              textAlign: TextAlign.center,
              style: GoogleFonts.schibstedGrotesk(
                fontSize: 13,
                color: isDark ? AppColors.textMutedDark : AppColors.muted,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      itemCount: notes.length,
      itemBuilder: (context, i) {
        final note = notes[i];
        return _SermonNoteCard(note: note, index: i);
      },
    );
  }
}

class _SermonNoteCard extends StatefulWidget {
  final SermonNote note;
  final int index;

  const _SermonNoteCard({required this.note, required this.index});

  @override
  State<_SermonNoteCard> createState() => _SermonNoteCardState();
}

class _SermonNoteCardState extends State<_SermonNoteCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppColors.espresso : AppColors.linen;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;
    final note = widget.note;
    final dateStr = DateFormat('EEEE, MMM d, yyyy').format(note.sermonDate);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: _expanded
              ? Border.all(color: primary.withValues(alpha: 0.3), width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date chip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                dateStr,
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Title
            Text(
              note.title,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Preacher + Scripture
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  note.preacherName,
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(
                  Icons.menu_book_outlined,
                  size: 14,
                  color: primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    note.scriptureReference,
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Summary text (collapsed / expanded)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 13,
                  height: 1.6,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.muted,
                ),
              ),
              secondChild: Text(
                note.content,
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 13,
                  height: 1.6,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.muted,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Tap indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  _expanded ? 'Tap to collapse' : 'Tap to read more',
                  style: GoogleFonts.schibstedGrotesk(
                    fontSize: 11,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 * widget.index))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.05);
  }
}
