import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/feature_providers.dart';

/// Notification center screen — grouped by read/unread.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {

  void _markAllRead() {
    ref.read(notificationsNotifierProvider.notifier).markAllRead();
  }


  void _markRead(String id) {
    ref.read(notificationsNotifierProvider.notifier).markRead(id);
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'prayer_response':
        return Icons.volunteer_activism_rounded;
      case 'inspiration':
        return Icons.auto_awesome_rounded;
      case 'announcement':
        return Icons.campaign_rounded;
      case 'event_reminder':
        return Icons.event_rounded;
      case 'petition_update':
        return Icons.mail_outline_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _colorForType(String type, Color primary) {
    switch (type) {
      case 'prayer_response':
        return AppColors.healing;
      case 'inspiration':
        return AppColors.education;
      case 'announcement':
        return primary;
      case 'event_reminder':
        return AppColors.financial;
      default:
        return primary;
    }
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
    
    final asyncNotifications = ref.watch(notificationsStreamProvider);
    final _notifications = asyncNotifications.value ?? [];
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _notifications.length,
              itemBuilder: (ctx, i) {
                final n = _notifications[i];
                final typeColor = _colorForType(n.type, colorScheme.primary);

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: GestureDetector(
                    onTap: () => _markRead(n.id),
                    child: Card(
                      elevation: n.isRead ? 0 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                        side: n.isRead 
                            ? BorderSide.none 
                            : BorderSide(
                                color: colorScheme.primary.withValues(alpha: 0.25),
                                width: 1,
                              ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: typeColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _iconForType(n.type),
                                size: 20,
                                color: typeColor,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          n.title,
                                          style: textTheme.titleSmall?.copyWith(
                                            fontWeight: n.isRead ? FontWeight.normal : FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      if (!n.isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          margin: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    n.body,
                                    style: textTheme.bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _timeAgo(n.createdAt),
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
