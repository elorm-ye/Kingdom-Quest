import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/personal_note.dart';
import '../../../shared/widgets/app_pop_scope.dart';

class PersonalNotesScreen extends ConsumerStatefulWidget {
  final String? initialScripture;

  const PersonalNotesScreen({super.key, this.initialScripture});

  @override
  ConsumerState<PersonalNotesScreen> createState() => _PersonalNotesScreenState();
}

class _PersonalNotesScreenState extends ConsumerState<PersonalNotesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<Color> _noteColors = [
    Color(0xFFFBF4E8), // Warm Amber
    Color(0xFFEBF3EE), // Sage Green
    Color(0xFFEAF1F8), // Soft Slate/Blue
    Color(0xFFF7EBEB), // Soft Terracotta
    Color(0xFFF3EAF8), // Soft Purple
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialScripture != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openNoteEditor(
          context,
          initialScripture: widget.initialScripture,
        );
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNoteEditor(
    BuildContext context, {
    PersonalNote? existingNote,
    String? initialScripture,
  }) {
    final titleController = TextEditingController(text: existingNote?.title ?? '');
    final contentController = TextEditingController(text: existingNote?.content ?? '');
    final sermonController = TextEditingController(
      text: existingNote?.linkedSermonTitle ?? '',
    );
    final scriptureController = TextEditingController();
    final scriptures = List<String>.from(
      existingNote?.scriptureReferences ??
          (initialScripture != null ? [initialScripture] : []),
    );
    int selectedColorIndex = existingNote?.colorIndex ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            final theme = Theme.of(modalCtx);

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom,
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                top: AppSpacing.lg,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            existingNote == null ? 'New Personal Note' : 'Edit Note',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(modalCtx),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Color picker
                      Row(
                        children: List.generate(_noteColors.length, (index) {
                          final isSelected = selectedColorIndex == index;
                          return GestureDetector(
                            onTap: () => setModalState(() => selectedColorIndex = index),
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _noteColors[index],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.terracotta
                                      : Colors.grey.withAlpha(80),
                                  width: isSelected ? 2.5 : 1,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: AppColors.terracotta,
                                    )
                                  : null,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      TextField(
                        controller: titleController,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Note Title / Topic',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Linked Sermon
                      TextField(
                        controller: sermonController,
                        decoration: const InputDecoration(
                          hintText: 'Linked Sermon (Optional)',
                          prefixIcon: Icon(Icons.mic_none_rounded, size: 20),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Scripture tags
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: scriptureController,
                              decoration: const InputDecoration(
                                hintText: 'Add Scripture (e.g. Rom 8:28)',
                                prefixIcon: Icon(Icons.menu_book_rounded, size: 20),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.terracotta,
                            ),
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              final text = scriptureController.text.trim();
                              if (text.isNotEmpty && !scriptures.contains(text)) {
                                setModalState(() {
                                  scriptures.add(text);
                                  scriptureController.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      if (scriptures.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: scriptures.map((refStr) {
                            return Chip(
                              label: Text(refStr),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setModalState(() => scriptures.remove(refStr));
                              },
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 12),

                      // Note Content
                      TextField(
                        controller: contentController,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          hintText: 'Write your devotional reflections, pastor quotes, and personal action steps...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Action buttons
                      Row(
                        children: [
                          if (existingNote != null) ...[
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.alert),
                              tooltip: 'Delete Note',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: modalCtx,
                                  builder: (dCtx) => AlertDialog(
                                    title: const Text('Delete Note?'),
                                    content: const Text('Are you sure you want to permanently delete this note?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(dCtx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(dCtx, true),
                                        child: const Text('Delete', style: TextStyle(color: AppColors.alert)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await ref
                                      .read(personalNotesNotifierProvider.notifier)
                                      .deleteNote(existingNote.id);
                                  if (modalCtx.mounted) Navigator.pop(modalCtx);
                                }
                              },
                            ),
                            const Spacer(),
                          ] else
                            const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.pop(modalCtx),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.terracotta,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () async {
                              final title = titleController.text.trim();
                              final content = contentController.text.trim();
                              if (title.isEmpty && content.isEmpty) {
                                ScaffoldMessenger.of(modalCtx).showSnackBar(
                                  const SnackBar(content: Text('Please enter a note title or content')),
                                );
                                return;
                              }

                              if (existingNote == null) {
                                await ref
                                    .read(personalNotesNotifierProvider.notifier)
                                    .addNote(
                                      title: title.isEmpty ? 'Untitled Note' : title,
                                      content: content,
                                      scriptures: scriptures,
                                      linkedSermon: sermonController.text.trim().isEmpty
                                          ? null
                                          : sermonController.text.trim(),
                                      colorIndex: selectedColorIndex,
                                    );
                              } else {
                                await ref
                                    .read(personalNotesNotifierProvider.notifier)
                                    .updateNote(
                                      existingNote.copyWith(
                                        title: title.isEmpty ? 'Untitled Note' : title,
                                        content: content,
                                        scriptureReferences: scriptures,
                                        linkedSermonTitle: sermonController.text.trim().isEmpty
                                            ? null
                                            : sermonController.text.trim(),
                                        colorIndex: selectedColorIndex,
                                      ),
                                    );
                              }

                              if (modalCtx.mounted) Navigator.pop(modalCtx);
                            },
                            child: Text(existingNote == null ? 'Save Note' : 'Update Note'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final asyncNotes = ref.watch(personalNotesNotifierProvider);
    final allNotes = asyncNotes.value ?? [];

    final filteredNotes = allNotes.where((note) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final inTitle = note.title.toLowerCase().contains(q);
      final inContent = note.content.toLowerCase().contains(q);
      final inSermon = note.linkedSermonTitle?.toLowerCase().contains(q) ?? false;
      final inScriptures = note.scriptureReferences.any((s) => s.toLowerCase().contains(q));
      return inTitle || inContent || inSermon || inScriptures;
    }).toList();

    return AppPopScope(
      fallbackRoute: '/home',
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(fallbackRoute: '/home'),
          title: const Text('Devotional Journal & Notes'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.terracotta,
          foregroundColor: Colors.white,
          onPressed: () => _openNoteEditor(context),
          tooltip: 'New Note',
          child: const Icon(Icons.edit_note_rounded, size: 28),
        ),
        body: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search notes, scriptures, sermons...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              ),
            ),

            // Notes List
            Expanded(
              child: filteredNotes.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.menu_book_outlined,
                              size: 56,
                              color: AppColors.muted,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No notes match "$_searchQuery"'
                                  : 'No journal notes yet',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the button below to capture sermon insights, prayers, and scripture revelations.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.muted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: filteredNotes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, idx) {
                        final note = filteredNotes[idx];
                        final cardColor = isDark
                            ? theme.colorScheme.surfaceContainerHighest
                            : _noteColors[note.colorIndex % _noteColors.length];

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _openNoteEditor(context, existingNote: note),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.dividerColor.withAlpha(40),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MMM d').format(note.updatedAt),
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                                if (note.linkedSermonTitle != null) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.mic_none_rounded,
                                        size: 14,
                                        color: AppColors.burntAmber,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          note.linkedSermonTitle!,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: AppColors.burntAmber,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Text(
                                  note.content,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.4,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (note.scriptureReferences.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: note.scriptureReferences.map((refText) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.terracotta.withAlpha(25),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          refText,
                                          style: theme.textTheme.labelSmall?.copyWith(
                                            color: AppColors.terracotta,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
