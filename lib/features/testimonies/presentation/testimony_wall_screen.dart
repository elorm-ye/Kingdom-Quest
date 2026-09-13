import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/testimony.dart';
import '../../../shared/widgets/app_pop_scope.dart';

class TestimonyWallScreen extends ConsumerStatefulWidget {
  const TestimonyWallScreen({super.key});

  @override
  ConsumerState<TestimonyWallScreen> createState() => _TestimonyWallScreenState();
}

class _TestimonyWallScreenState extends ConsumerState<TestimonyWallScreen> {
  String? _selectedCategory;

  static const List<String> _categories = [
    'All',
    'Healing',
    'Provision',
    'Academics',
    'Faith',
    'Family',
    'Deliverance',
  ];

  void _openSubmitTestimonySheet(BuildContext context) {
    final titleController = TextEditingController();
    final storyController = TextEditingController();
    String selectedCategory = 'Faith';
    bool isAnonymous = false;

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
                            'Share Your Testimony',
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
                      const SizedBox(height: 8),
                      Text(
                        'Overcome by the blood of the Lamb and the word of your testimony (Rev 12:11).',
                        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.muted),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Headline / Summary',
                          hintText: 'e.g. God healed my back pain during worship',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Category dropdown
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: _categories
                            .where((c) => c != 'All')
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedCategory = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Story input
                      TextField(
                        controller: storyController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Your Story',
                          hintText: 'Share what God did, how your faith was tested, and how He answered...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Anonymous switch
                      SwitchListTile(
                        title: const Text('Post Anonymously'),
                        subtitle: const Text('Hide your name on the public testimony wall'),
                        value: isAnonymous,
                        contentPadding: EdgeInsets.zero,
                        activeThumbColor: AppColors.terracotta,
                        onChanged: (val) {
                          setModalState(() => isAnonymous = val);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.terracotta,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final title = titleController.text.trim();
                            final story = storyController.text.trim();
                            if (title.isEmpty || story.isEmpty) {
                              ScaffoldMessenger.of(modalCtx).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in both the headline and story'),
                                ),
                              );
                              return;
                            }

                            await ref
                                .read(testimoniesNotifierProvider.notifier)
                                .addTestimony(
                                  title: title,
                                  story: story,
                                  authorName: 'David K.',
                                  category: selectedCategory,
                                  isAnonymous: isAnonymous,
                                );

                            if (modalCtx.mounted) {
                              Navigator.pop(modalCtx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Testimony shared to the glory of God! (+25 XP)'),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Post Testimony',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
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
    final asyncTestimonies = ref.watch(testimoniesNotifierProvider);
    final allTestimonies = asyncTestimonies.value ?? [];

    final filtered = allTestimonies.where((t) {
      if (_selectedCategory == null || _selectedCategory == 'All') return true;
      return t.category.toLowerCase() == _selectedCategory!.toLowerCase();
    }).toList();

    return AppPopScope(
      fallbackRoute: '/home',
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(fallbackRoute: '/home'),
          title: const Text('Testimony Wall'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.terracotta,
          foregroundColor: Colors.white,
          onPressed: () => _openSubmitTestimonySheet(context),
          icon: const Icon(Icons.add_comment_rounded),
          label: const Text('Share Praise'),
        ),
        body: Column(
          children: [
            // Category filter chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, idx) {
                  final cat = _categories[idx];
                  final isSelected = (_selectedCategory == null && cat == 'All') ||
                      (_selectedCategory == cat);

                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.terracotta.withAlpha(35),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.terracotta : null,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat == 'All' ? null : cat;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Testimonies Feed
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.celebration_outlined, size: 56, color: AppColors.muted),
                            const SizedBox(height: 16),
                            Text(
                              'No testimonies in this category yet',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to encourage fellow youth with what God has done in your life!',
                              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.sm,
                        AppSpacing.xl,
                        80,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (ctx, idx) {
                        final testimony = filtered[idx];
                        return _buildTestimonyCard(context, theme, testimony);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonyCard(BuildContext context, ThemeData theme, Testimony testimony) {
    final hasAmen = testimony.userReactions.contains('amen');
    final hasPraise = testimony.userReactions.contains('praise');
    final hasHeart = testimony.userReactions.contains('heart');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withAlpha(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top author row
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.terracotta.withAlpha(25),
                  child: Text(
                    testimony.isAnonymous
                        ? '?'
                        : testimony.authorName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.terracotta,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        testimony.isAnonymous ? 'Anonymous Disciple' : testimony.authorName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, yyyy').format(testimony.createdAt),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.burntAmber.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    testimony.category,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.burntAmber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              testimony.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Story
            Text(
              testimony.story,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Reaction buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReactionBtn(
                  label: 'Amen! (${testimony.amenCount})',
                  icon: '🙌',
                  isActive: hasAmen,
                  onTap: () => ref
                      .read(testimoniesNotifierProvider.notifier)
                      .react(testimony.id, 'amen'),
                ),
                _buildReactionBtn(
                  label: 'Praise! (${testimony.praiseCount})',
                  icon: '🔥',
                  isActive: hasPraise,
                  onTap: () => ref
                      .read(testimoniesNotifierProvider.notifier)
                      .react(testimony.id, 'praise'),
                ),
                _buildReactionBtn(
                  label: 'Love (${testimony.heartCount})',
                  icon: '❤️',
                  isActive: hasHeart,
                  onTap: () => ref
                      .read(testimoniesNotifierProvider.notifier)
                      .react(testimony.id, 'heart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionBtn({
    required String label,
    required String icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.terracotta.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.terracotta.withAlpha(80) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.terracotta : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
