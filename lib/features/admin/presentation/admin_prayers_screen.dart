import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../core/providers/feature_providers.dart';

/// Admin prayer requests management — respond, mark answered.
class AdminPrayersScreen extends ConsumerStatefulWidget {
  const AdminPrayersScreen({super.key});

  @override
  ConsumerState<AdminPrayersScreen> createState() => _AdminPrayersScreenState();
}

class _AdminPrayersScreenState extends ConsumerState<AdminPrayersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  List<PrayerRequest> _filtered(String status, List<PrayerRequest> prayers) =>
      prayers.where((p) => p.status.name == status).toList();

  void _markAnswered(PrayerRequest p) {
    ref.read(prayerRequestsNotifierProvider.notifier).markAnswered(p.id);
  }

  void _showReplySheet(
    BuildContext context,
    PrayerRequest p,
    ThemeData theme,
  ) {
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    _replyController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Reply to Prayer Request',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              p.title,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _replyController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your pastoral response...',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_replyController.text.trim().isNotEmpty) {
                    Navigator.pop(ctx);
                    ref.read(prayerRequestsNotifierProvider.notifier).reply(
                      prayerRequestId: p.id,
                      message: _replyController.text.trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Response sent & marked as answered'),
                      ),
                    );
                  }
                },
                child: const Text('Send Response'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final asyncPrayers = ref.watch(prayerRequestsNotifierProvider);
    final prayers = asyncPrayers.value ?? [];

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            pinned: true,
            title: const Text('Prayer Requests'),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Pending (${_filtered('pending', prayers).length})'),
                Tab(text: 'Praying (${_filtered('praying', prayers).length})'),
                Tab(text: 'Answered (${_filtered('answered', prayers).length})'),
              ],
            ),
          ),
        ],
        body: asyncPrayers.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (_) => TabBarView(
            controller: _tabController,
            children: ['pending', 'praying', 'answered'].map((status) {
              final list = _filtered(status, prayers);
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'No $status requests',
                    style: textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.read(prayerRequestsNotifierProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) => _PrayerAdminCard(
                    prayer: list[i],
                    theme: theme,
                    onReply: () => _showReplySheet(
                      context,
                      list[i],
                      theme,
                    ),
                    onMarkAnswered: () => _markAnswered(list[i]),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _PrayerAdminCard extends StatelessWidget {
  final PrayerRequest prayer;
  final ThemeData theme;
  final VoidCallback onReply, onMarkAnswered;

  const _PrayerAdminCard({
    required this.prayer,
    required this.theme,
    required this.onReply,
    required this.onMarkAnswered,
  });

  Color _categoryColor() {
    switch (prayer.category) {
      case PrayerCategory.healing:
        return AppColors.healing;
      case PrayerCategory.financial:
        return AppColors.financial;
      case PrayerCategory.education:
        return AppColors.education;
      case PrayerCategory.family:
        return AppColors.family;
      case PrayerCategory.thanksgiving:
        return AppColors.thanksgiving;
      default:
        return AppColors.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor();
    final name = prayer.isAnonymous
        ? (prayer.anonymousDisplayName ?? 'Anonymous Member')
        : (prayer.submitterName ?? 'Member');
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              height: 4,
              color: catColor,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          prayer.category.label,
                          style: textTheme.labelSmall?.copyWith(color: catColor),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.favorite_outline,
                        size: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${prayer.prayerCount}',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    prayer.title,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prayer.description,
                    style: textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        prayer.isAnonymous
                            ? Icons.person_off_outlined
                            : Icons.person_outline,
                        size: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        name,
                        style: textTheme.bodySmall,
                      ),
                      const Spacer(),
                      if (prayer.status != PrayerStatus.answered) ...[
                        TextButton(
                          onPressed: onMarkAnswered,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            'Mark Answered',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.healing,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: onReply,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('Respond'),
                        ),
                      ] else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.healing.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Text(
                            '✓ Answered',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.healing,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (prayer.responses.isNotEmpty) ...[
                    const Divider(height: 16),
                    ...prayer.responses.map(
                      (r) => Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.reply_rounded,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                r.message,
                                style: textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
