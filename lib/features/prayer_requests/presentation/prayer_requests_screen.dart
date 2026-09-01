import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../shared/models/prayer_request.dart';

class PrayerRequestsScreen extends ConsumerStatefulWidget {
  const PrayerRequestsScreen({super.key});
  @override
  ConsumerState<PrayerRequestsScreen> createState() => _PrayerRequestsScreenState();
}

class _PrayerRequestsScreenState extends ConsumerState<PrayerRequestsScreen> {
  PrayerCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    final asyncRequests = ref.watch(prayerRequestsNotifierProvider);
    final allRequests = asyncRequests.value ?? [];
    final requests = allRequests
        .where(
          (r) => _selectedCategory == null || r.category == _selectedCategory,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('Prayer Requests'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/submit-prayer'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Category filter chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              children: [
                _chip(
                  'All',
                  _selectedCategory == null,
                  () => setState(() => _selectedCategory = null),
                  theme,
                ),
                ...PrayerCategory.values.map(
                  (c) => _chip(
                    '${c.icon} ${c.label}',
                    _selectedCategory == c,
                    () => setState(() => _selectedCategory = c),
                    theme,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: asyncRequests.isLoading && allRequests.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => ref.read(prayerRequestsNotifierProvider.notifier).refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      itemCount: requests.length,
                      itemBuilder: (context, i) => _requestCard(requests[i], theme),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final bg = selected ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final fg = selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: selected ? null : Border.all(color: colorScheme.outlineVariant),
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _requestCard(PrayerRequest req, ThemeData theme) {
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    final statusColor = switch (req.status) {
      PrayerStatus.pending => AppColors.other,
      PrayerStatus.praying => AppColors.education,
      PrayerStatus.answered => AppColors.healing,
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
                      req.status.label,
                      style: textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${req.category.icon} ${req.category.label}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                req.title,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                req.description,
                maxLines: 2,
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
                    req.isAnonymous
                        ? (req.anonymousDisplayName ?? 'Anonymous')
                        : (req.submitterName ?? 'Member'),
                    style: textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.favorite_rounded,
                    size: 14,
                    color: AppColors.healing,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${req.prayerCount} praying',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              if (req.responses.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Divider(
                  color: colorScheme.outlineVariant,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.reply_rounded,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Response from ${req.responses.first.adminName}',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  req.responses.first.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
