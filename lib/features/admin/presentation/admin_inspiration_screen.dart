import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';

/// Admin inspiration publisher — create and publish daily inspiration posts.
class AdminInspirationScreen extends ConsumerStatefulWidget {
  const AdminInspirationScreen({super.key});

  @override
  ConsumerState<AdminInspirationScreen> createState() => _AdminInspirationScreenState();
}

class _AdminInspirationScreenState extends ConsumerState<AdminInspirationScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _bibleRefController = TextEditingController();
  String _selectedType = 'motivation';
  bool _isPublishing = false;
  bool _published = false;

  final _types = [
    (
      value: 'motivation',
      label: 'Motivation',
      icon: Icons.local_fire_department_rounded,
      color: AppColors.other,
    ),
    (
      value: 'devotional',
      label: 'Devotional',
      icon: Icons.menu_book_rounded,
      color: AppColors.healing,
    ),
    (
      value: 'verse',
      label: 'Bible Verse',
      icon: Icons.format_quote_rounded,
      color: AppColors.family,
    ),
    (
      value: 'challenge',
      label: 'Challenge',
      icon: Icons.emoji_events_rounded,
      color: AppColors.education,
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _bibleRefController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) return;
    setState(() => _isPublishing = true);
    try {
      await ref.read(inspirationsNotifierProvider.notifier).publish(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        type: _selectedType,
        bibleReference: _bibleRefController.text.trim().isNotEmpty
            ? _bibleRefController.text.trim()
            : null,
      );
      setState(() {
        _isPublishing = false;
        _published = true;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() {
        _published = false;
        _titleController.clear();
        _contentController.clear();
        _bibleRefController.clear();
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

    final asyncInspirations = ref.watch(inspirationsNotifierProvider);
    final recentInspirations = (asyncInspirations.value ?? []).take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspiration Publisher'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── TYPE SELECTOR ──
            Text(
              'Post Type',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _types.map((t) {
                  final active = _selectedType == t.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = t.value),
                    child: Container(
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: active ? t.color : t.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            t.icon,
                            size: 18,
                            color: active ? Colors.white : t.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            t.label,
                            style: textTheme.labelLarge?.copyWith(
                              color: active ? Colors.white : t.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ── COMPOSE FORM ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _titleController,
                      style: textTheme.titleMedium,
                      decoration: const InputDecoration(
                        hintText: 'Give your post a title...',
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Content',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _contentController,
                      maxLines: 6,
                      style: textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        hintText: 'Write your message...',
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Bible Reference (optional)',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _bibleRefController,
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'e.g. Philippians 4:13',
                        prefixIcon: Icon(
                          Icons.menu_book_outlined,
                          size: 18,
                          color: colorScheme.primary,
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
                          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
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
                          _isPublishing ? 'Publishing...' : 'Publish Now',
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

            // ── RECENT POSTS ──
            Text(
              'Recent Posts',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            ...recentInspirations.map((ins) {
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
                            Icons.auto_awesome_rounded,
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
                                ins.title,
                                style: textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                ins.type.label,
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
