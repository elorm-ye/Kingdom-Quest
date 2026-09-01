import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';

/// Events & Announcements screen — tabbed layout.
class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleRegistration(int index) {
    final asyncEvents = ref.read(eventsNotifierProvider);
    final events = asyncEvents.value ?? [];
    if (index >= events.length) return;
    final e = events[index];
    ref.read(eventsNotifierProvider.notifier).toggleRegistration(
      eventId: e.id,
      currentlyRegistered: e.isRegistered,
    );
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final min = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day} · $hour:$min $period';
  }

  String _daysLabel(DateTime dt) {
    final days = dt.difference(DateTime.now()).inDays;
    if (days < 0) return 'Past';
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return 'In $days days';
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    final asyncEvents = ref.watch(eventsNotifierProvider);
    final _events = asyncEvents.value ?? [];
    final asyncAnnouncements = ref.watch(announcementsNotifierProvider);
    final announcements = asyncAnnouncements.value ?? [];

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: AppSpacing.lg,
                bottom: 60,
              ),
              title: Text(
                'Events & News',
                style: textTheme.titleLarge,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Upcoming Events'),
                Tab(text: 'Announcements'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ── EVENTS TAB ──
            ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _events.length,
              itemBuilder: (ctx, i) {
                final e = _events[i];
                final days = e.startTime.difference(DateTime.now()).inDays;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 5,
                          color: colorScheme.primary,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.title,
                                          style: textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatDateTime(e.startTime),
                                          style: textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: days <= 3
                                          ? colorScheme.primaryContainer
                                          : colorScheme.surface,
                                      border: Border.all(
                                        color: days <= 3
                                            ? colorScheme.primary
                                            : colorScheme.outlineVariant,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusFull,
                                      ),
                                    ),
                                    child: Text(
                                      _daysLabel(e.startTime),
                                      style: textTheme.labelSmall?.copyWith(
                                        color: days <= 3
                                            ? colorScheme.onPrimaryContainer
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                e.description,
                                style: textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 13,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      e.location ?? 'TBA',
                                      style: textTheme.bodySmall,
                                    ),
                                  ),
                                  Icon(
                                    Icons.people_outline_rounded,
                                    size: 13,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${e.registrationCount}',
                                    style: textTheme.bodySmall,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  GestureDetector(
                                    onTap: () => _toggleRegistration(i),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: e.isRegistered
                                            ? AppColors.healing
                                            : colorScheme.primary,
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusFull,
                                        ),
                                      ),
                                      child: Text(
                                        e.isRegistered
                                            ? '✓ Joined'
                                            : 'Register',
                                        style: textTheme.labelSmall?.copyWith(
                                          color: e.isRegistered
                                              ? Colors.white
                                              : colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (e.isRecurring == true) ...[
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.repeat_rounded,
                                      size: 12,
                                      color: AppColors.healing,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      e.recurringPattern ?? 'Recurring',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: AppColors.healing,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // ── ANNOUNCEMENTS TAB ──
            ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: announcements.length,
              itemBuilder: (ctx, i) {
                final ann = announcements[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Card(
                    shape: ann.isPinned
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                            side: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          )
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (ann.isPinned) ...[
                                Icon(
                                  Icons.push_pin_outlined,
                                  size: 14,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'PINNED',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                              const Spacer(),
                              Text(
                                _timeAgo(ann.createdAt),
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            ann.title,
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ann.content,
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  size: 14,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                ann.adminName,
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
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
          ],
        ),
      ),
    );
  }
}
