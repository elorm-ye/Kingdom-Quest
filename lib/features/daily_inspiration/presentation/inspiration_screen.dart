import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';

class InspirationScreen extends ConsumerWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final asyncPosts = ref.watch(inspirationsNotifierProvider);
    final posts = asyncPosts.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Inspiration'),
      ),
      body: asyncPosts.isLoading && posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(inspirationsNotifierProvider.notifier).refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.xl),
                itemCount: posts.length,
                itemBuilder: (context, i) {
                  final p = posts[i];
                  final typeColor = switch (p.type.name) {
                    'motivation' => AppColors.other,
                    'challenge' => AppColors.sage,
                    'devotional' => AppColors.financial,
                    'verse' => AppColors.family,
                    _ => AppColors.other,
                  };

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
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
                                    color: typeColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    p.type.label,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: typeColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  _timeAgo(p.createdAt),
                                  style: textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              p.title,
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              p.content,
                              style: textTheme.bodyMedium,
                            ),
                            if (p.bibleReference != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                p.bibleReference!,
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                Text(
                                  '— ${p.adminName}',
                                  style: textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Divider(
                              color: colorScheme.outlineVariant,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                _actionBtn(
                                  Icons.favorite,
                                  p.isLikedByUser
                                      ? AppColors.healing
                                      : colorScheme.onSurfaceVariant,
                                  '${p.likeCount}',
                                  textTheme,
                                ),
                                const SizedBox(width: AppSpacing.xl),
                                _actionBtn(
                                  Icons.chat_bubble_outline,
                                  colorScheme.onSurfaceVariant,
                                  '${p.commentCount}',
                                  textTheme,
                                ),
                                const Spacer(),
                                _actionBtn(
                                  Icons.share_outlined,
                                  colorScheme.onSurfaceVariant,
                                  'Share',
                                  textTheme,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, String label, TextTheme textTheme) =>
      Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      );

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
