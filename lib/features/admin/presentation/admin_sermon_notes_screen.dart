import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';

/// Admin screen for publishing, editing, and deleting sermon notes.
class AdminSermonNotesScreen extends ConsumerStatefulWidget {
  const AdminSermonNotesScreen({super.key});

  @override
  ConsumerState<AdminSermonNotesScreen> createState() => _AdminSermonNotesScreenState();
}

class _AdminSermonNotesScreenState extends ConsumerState<AdminSermonNotesScreen> {
  final _titleController = TextEditingController();
  final _preacherController = TextEditingController();
  final _scriptureController = TextEditingController();
  final _contentController = TextEditingController();
  DateTime _sermonDate = DateTime.now();
  bool _isPublishing = false;
  bool _published = false;

  @override
  void dispose() {
    _titleController.dispose();
    _preacherController.dispose();
    _scriptureController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _sermonDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null) setState(() => _sermonDate = picked);
  }

  Future<void> _publish() async {
    if (_titleController.text.trim().isEmpty ||
        _preacherController.text.trim().isEmpty ||
        _scriptureController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) return;
    setState(() => _isPublishing = true);
    try {
      await ref.read(sermonNotesNotifierProvider.notifier).publish(
        title: _titleController.text.trim(),
        preacherName: _preacherController.text.trim(),
        scriptureReference: _scriptureController.text.trim(),
        content: _contentController.text.trim(),
        sermonDate: _sermonDate,
      );
      setState(() {
        _isPublishing = false;
        _published = true;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() {
        _published = false;
        _titleController.clear();
        _preacherController.clear();
        _scriptureController.clear();
        _contentController.clear();
        _sermonDate = DateTime.now();
      });
    } catch (_) {
      setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final asyncNotes = ref.watch(sermonNotesNotifierProvider);
    final recentNotes = (asyncNotes.value ?? []).take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sermon Notes Publisher'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── COMPOSE FORM ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sermon Date picker
                    Text(
                      'Sermon Date',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 18, color: colorScheme.onPrimaryContainer),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              DateFormat('EEEE, MMM d, yyyy')
                                  .format(_sermonDate),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.edit_rounded,
                                size: 16, color: colorScheme.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Title
                    Text(
                      'Sermon Title',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _titleController,
                      style: textTheme.titleMedium,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Walking by Faith',
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Preacher
                    Text(
                      'Preacher',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _preacherController,
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'e.g. Pastor James',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Scripture
                    Text(
                      'Scripture Reference(s)',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _scriptureController,
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'e.g. 2 Corinthians 5:7',
                        prefixIcon: Icon(
                          Icons.menu_book_outlined,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Summary
                    Text(
                      'Summary',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _contentController,
                      maxLines: 8,
                      style: textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        hintText: 'Write a summary of the sermon for members who missed it...',
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Image upload placeholder
                    Text(
                      'Slide Image (optional)',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    GestureDetector(
                      onTap: () {
                        // Image picker will be wired via Supabase Storage
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: colorScheme.outline,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 20, color: colorScheme.primary),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Tap to upload an image',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── PUBLISH BUTTON ──
            SizedBox(
              width: double.infinity,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _published
                    ? Container(
                        key: const ValueKey('success'),
                        height: AppSpacing.buttonHeight,
                        decoration: BoxDecoration(
                          color: AppColors.healing,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusChip,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Published!',
                              style: textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ElevatedButton.icon(
                        key: const ValueKey('publish'),
                        onPressed: _isPublishing ? null : _publish,
                        icon: _isPublishing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                size: 18,
                              ),
                        label: Text(
                          _isPublishing ? 'Publishing...' : 'Publish Sermon Note',
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            AppSpacing.buttonHeight,
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── RECENT NOTES ──
            Text(
              'Recent Sermon Notes',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            ...recentNotes.map((note) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${note.preacherName} · ${DateFormat('MMM d').format(note.sermonDate)}',
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.healing.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Live',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.healing,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
