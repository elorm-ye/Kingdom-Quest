import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../core/providers/feature_providers.dart';

/// Admin advice moderation — respond to and close advice requests.
class AdminAdviceScreen extends ConsumerStatefulWidget {
  const AdminAdviceScreen({super.key});

  @override
  ConsumerState<AdminAdviceScreen> createState() => _AdminAdviceScreenState();
}

class _AdminAdviceScreenState extends ConsumerState<AdminAdviceScreen> {
  final _replyController = TextEditingController();
  final _bibleController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    _bibleController.dispose();
    super.dispose();
  }

  void _closeRequest(String id) {
    ref.read(adviceNotifierProvider.notifier).close(id);
  }

  void _showReplySheet(
    BuildContext context,
    AdviceRequest request,
    ThemeData theme,
  ) {
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    _replyController.clear();
    _bibleController.clear();
    
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
              'Spiritual Response',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _replyController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Write pastoral guidance...',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _bibleController,
              decoration: InputDecoration(
                hintText: 'Bible references (e.g. John 3:16, Psalm 23)',
                prefixIcon: Icon(
                  Icons.menu_book_outlined,
                  color: colorScheme.primary,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_replyController.text.trim().isNotEmpty) {
                    Navigator.pop(ctx);
                    ref.read(adviceNotifierProvider.notifier).reply(
                      adviceRequestId: request.id,
                      message: _replyController.text.trim(),
                      bibleReferences: _bibleController.text.trim().isNotEmpty
                          ? _bibleController.text.split(',')
                              .map((s) => s.trim())
                              .where((s) => s.isNotEmpty)
                              .toList()
                          : [],
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Response sent'),
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

  Color _statusColor(AdviceStatus s) {
    switch (s) {
      case AdviceStatus.pending:
        return AppColors.muted;
      case AdviceStatus.inProgress:
        return AppColors.burntAmber;
      case AdviceStatus.completed:
        return AppColors.sage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advice Center'),
      ),
      body: Builder(
        builder: (context) {
          final asyncAdvice = ref.watch(adviceNotifierProvider);
          final requests = asyncAdvice.value ?? [];
          return asyncAdvice.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (_) => RefreshIndicator(
              onRefresh: () => ref.read(adviceNotifierProvider.notifier).refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: requests.length,
                itemBuilder: (ctx, i) {
                  final r = requests[i];
                  final sc = _statusColor(r.status);
                  final name = r.isAnonymous
                      ? (r.anonymousDisplayName ?? 'Anonymous Member')
                      : 'Member';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      child: Padding(
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
                                    color: sc.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                                  ),
                                  child: Text(
                                    r.status.label,
                                    style: textTheme.labelSmall?.copyWith(color: sc),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  name,
                                  style: textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              r.title,
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              r.description,
                              style: textTheme.bodySmall,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            if (r.status != AdviceStatus.completed)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FilledButton.tonal(
                                    onPressed: () => _closeRequest(r.id),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      minimumSize: Size.zero,
                                    ),
                                    child: const Text('Close'),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  ElevatedButton.icon(
                                    onPressed: () => _showReplySheet(context, r, theme),
                                    icon: const Icon(Icons.reply_rounded, size: 14),
                                    label: const Text('Respond'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      minimumSize: Size.zero,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 14,
                                    color: AppColors.sage,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Closed',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: AppColors.sage,
                                    ),
                                  ),
                                ],
                              ),
                            if (r.responses.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              ...r.responses.map(
                                (resp) => Container(
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resp.message,
                                        style: textTheme.bodySmall,
                                      ),
                                      if (resp.bibleReferences.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Wrap(
                                          spacing: 4,
                                          children: resp.bibleReferences.map(
                                            (ref) => Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colorScheme.primaryContainer,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                ref,
                                                style: textTheme.labelSmall?.copyWith(
                                                  color: colorScheme.onPrimaryContainer,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ).toList(),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
