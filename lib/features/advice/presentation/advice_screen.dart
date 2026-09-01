import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../shared/models/advice_request.dart';

class AdviceScreen extends ConsumerWidget {
  const AdviceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    final asyncRequests = ref.watch(adviceNotifierProvider);
    final requests = asyncRequests.value ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('Advice Center'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/submit-advice'),
        child: const Icon(Icons.add),
      ),
      body: asyncRequests.isLoading && requests.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(adviceNotifierProvider.notifier).refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.xl),
                itemCount: requests.length,
                itemBuilder: (context, i) {
                  final a = requests[i];
                  final statusColor = switch (a.status) {
                    AdviceStatus.pending => AppColors.other,
                    AdviceStatus.inProgress => AppColors.education,
                    AdviceStatus.completed => AppColors.healing,
                  };

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
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
                                    color: statusColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    a.status.label,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  a.isAnonymous
                                      ? (a.anonymousDisplayName ?? 'Anonymous')
                                      : (a.submitterName ?? 'Member'),
                                  style: textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              a.title,
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              a.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium,
                            ),
                            if (a.responses.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              Divider(
                                color: colorScheme.outlineVariant,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Response from ${a.responses.first.adminName}',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                a.responses.first.message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              if (a.responses.first.bibleReferences.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.sm),
                                Wrap(
                                  spacing: AppSpacing.xs,
                                  children: a.responses.first.bibleReferences
                                      .map(
                                        (ref) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.sm,
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
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
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
  }
}
