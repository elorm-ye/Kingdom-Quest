import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/services/bible_service.dart';
import '../../../shared/widgets/app_pop_scope.dart';

class ReadingPlansScreen extends ConsumerStatefulWidget {
  const ReadingPlansScreen({super.key});

  @override
  ConsumerState<ReadingPlansScreen> createState() => _ReadingPlansScreenState();
}

class _ReadingPlansScreenState extends ConsumerState<ReadingPlansScreen> {
  String? _expandedPlanId;

  @override
  void initState() {
    super.initState();
    _expandedPlanId = BibleService.readingPlans.first.id;
  }

  void _openScripture(String scriptureRef) {
    final parts = scriptureRef.split(' ');
    final bookName = parts[0];
    final chapterNum = int.tryParse(parts[1].split(':')[0]) ?? 1;

    final foundBook = BibleService.books.firstWhere(
      (b) => b.name.toLowerCase() == bookName.toLowerCase(),
      orElse: () => BibleService.books.first,
    );

    ref.read(bibleSelectedBookProvider.notifier).state = foundBook;
    ref.read(bibleSelectedChapterNumberProvider.notifier).state = chapterNum;
    context.push('/bible');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressMap = ref.watch(readingPlanProgressNotifierProvider);

    return AppPopScope(
      fallbackRoute: '/bible',
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(fallbackRoute: '/bible'),
          title: const Text('Youth Reading Plans'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            // Header banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.terracotta, AppColors.burntAmber],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Guided Spiritual Growth',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Targeted daily devotionals tailored for youth and students',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withAlpha(220),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            Text(
              'Curated Plans',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            ...BibleService.readingPlans.map((plan) {
              final completedDays = progressMap[plan.id] ?? [];
              final percent = plan.days.isEmpty
                  ? 0.0
                  : (completedDays.length / plan.days.length).clamp(0.0, 1.0);
              final isExpanded = _expandedPlanId == plan.id;

              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isExpanded
                        ? AppColors.terracotta.withAlpha(120)
                        : theme.dividerColor.withAlpha(50),
                    width: isExpanded ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.vertical(
                        top: const Radius.circular(16),
                        bottom: Radius.circular(isExpanded ? 0 : 16),
                      ),
                      onTap: () {
                        setState(() {
                          _expandedPlanId = isExpanded ? null : plan.id;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.terracotta.withAlpha(30),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    plan.category,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppColors.terracotta,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${completedDays.length}/${plan.durationDays} Days',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.muted,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppColors.muted,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              plan.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              plan.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.muted,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: percent,
                                minHeight: 8,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  percent == 1.0 ? AppColors.sage : AppColors.terracotta,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded) ...[
                      const Divider(height: 1),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: plan.days.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (ctx, dayIdx) {
                          final day = plan.days[dayIdx];
                          final isCompleted =
                              completedDays.contains(day.dayNumber);

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.sage.withAlpha(15)
                                  : theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCompleted
                                    ? AppColors.sage.withAlpha(60)
                                    : theme.dividerColor.withAlpha(40),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isCompleted,
                                      activeColor: AppColors.sage,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (checked) {
                                        ref
                                            .read(
                                                readingPlanProgressNotifierProvider
                                                    .notifier)
                                            .toggleDay(
                                              planId: plan.id,
                                              dayNumber: day.dayNumber,
                                              completed: checked ?? false,
                                            );
                                      },
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Day ${day.dayNumber}: ${day.title}',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              decoration: isCompleted
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                          Text(
                                            day.scriptureRef,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: AppColors.terracotta,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _openScripture(day.scriptureRef),
                                      icon: const Icon(Icons.menu_book, size: 16),
                                      label: const Text('Read'),
                                      style: TextButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        foregroundColor: AppColors.terracotta,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 48,
                                    right: 8,
                                    bottom: 6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        day.reflection,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.muted,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.burntAmber.withAlpha(20),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.favorite_border,
                                              size: 14,
                                              color: AppColors.burntAmber,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                'Prayer: ${day.prayerPrompt}',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  fontStyle: FontStyle.italic,
                                                  color: AppColors.burntAmber,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
