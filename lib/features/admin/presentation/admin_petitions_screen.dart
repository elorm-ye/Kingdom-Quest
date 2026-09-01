import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../core/providers/feature_providers.dart';

/// Admin petitions screen — update status, view details.
class AdminPetitionsScreen extends ConsumerWidget {
  const AdminPetitionsScreen({super.key});

  Color _statusColor(PetitionStatus s) {
    switch (s) {
      case PetitionStatus.pending:
        return AppColors.muted;
      case PetitionStatus.underReview:
        return AppColors.burntAmber;
      case PetitionStatus.resolved:
        return AppColors.sage;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final asyncPetitions = ref.watch(petitionsNotifierProvider);
    final petitions = asyncPetitions.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Petitions'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Chip(
              label: Text(
                '${petitions.length} total',
                style: textTheme.labelSmall?.copyWith(color: colorScheme.primary),
              ),
              backgroundColor: colorScheme.primaryContainer,
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: asyncPetitions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (_) => petitions.isEmpty
            ? Center(
                child: Text(
                  'No petitions yet',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.read(petitionsNotifierProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: petitions.length,
                  itemBuilder: (ctx, i) {
                    final p = petitions[i];
                    final statusColor = _statusColor(p.status);
                    final name = p.isAnonymous
                        ? (p.anonymousDisplayName ?? 'Anonymous Member')
                        : (p.submitterName ?? 'Member');

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
                                      color: statusColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                                    ),
                                    child: Text(
                                      p.status.label,
                                      style: textTheme.labelSmall?.copyWith(
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    p.isAnonymous ? Icons.person_off_outlined : Icons.person_outline,
                                    size: 13,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    name,
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                p.subject,
                                style: textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.description,
                                style: textTheme.bodySmall,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              // Status update buttons
                              Row(
                                children: [
                                  Text(
                                    'Update:',
                                    style: textTheme.bodySmall,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  ...PetitionStatus.values.map((s) {
                                    final isActive = p.status == s;
                                    final sc = _statusColor(s);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: GestureDetector(
                                        onTap: isActive
                                            ? null
                                            : () => ref.read(petitionsNotifierProvider.notifier).updateStatus(
                                                  id: p.id,
                                                  status: s.name,
                                                ),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isActive ? sc : colorScheme.surface,
                                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                                            border: Border.all(
                                              color: isActive ? sc : sc.withValues(alpha: 0.5),
                                            ),
                                          ),
                                          child: Text(
                                            s.label,
                                            style: textTheme.labelSmall?.copyWith(
                                              color: isActive ? Colors.white : sc,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
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
      ),
    );
  }
}
