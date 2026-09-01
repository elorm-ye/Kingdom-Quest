import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../shared/models/petition.dart';

class PetitionsScreen extends ConsumerWidget {
  const PetitionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final asyncPetitions = ref.watch(petitionsNotifierProvider);
    final petitions = asyncPetitions.value ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('Petitions'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/submit-petition'),
        child: const Icon(Icons.add),
      ),
      body: asyncPetitions.isLoading && petitions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(petitionsNotifierProvider.notifier).refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.xl),
                itemCount: petitions.length,
                itemBuilder: (context, i) {
                  final p = petitions[i];
                  final statusColor = switch (p.status) {
                    PetitionStatus.pending => AppColors.other,
                    PetitionStatus.underReview => AppColors.education,
                    PetitionStatus.resolved => AppColors.healing,
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
                                    p.status.label,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: statusColor,
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
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              p.subject,
                              style: textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              p.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 14,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  p.isAnonymous
                                      ? (p.anonymousDisplayName ?? 'Anonymous')
                                      : (p.submitterName ?? 'Member'),
                                  style: textTheme.bodySmall,
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

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
