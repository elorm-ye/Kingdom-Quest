import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
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
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No sermon notes yet',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Sermon summaries will appear here after Sunday services.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    final note = widget.note;
    final dateStr = DateFormat('EEEE, MMM d, yyyy').format(note.sermonDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Card(
          elevation: _expanded ? 2 : 1,
          shape: _expanded 
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                side: BorderSide(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              )
            : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dateStr,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Title
                Text(
                  note.title,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Preacher + Scripture
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      note.preacherName,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      Icons.menu_book_outlined,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        note.scriptureReference,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
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
                    style: textTheme.bodyMedium,
                  ),
                  secondChild: Text(
                    note.content,
                    style: textTheme.bodyMedium,
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
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _expanded ? 'Tap to collapse' : 'Tap to read more',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
