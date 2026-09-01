import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Admin "More" screen — links to advice, inspiration publisher, forum mod.
class AdminMoreScreen extends StatelessWidget {
  const AdminMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final modules = [
      (
        icon: Icons.lightbulb_outline_rounded,
        color: AppColors.other,
        title: 'Advice Center',
        subtitle: 'Review & respond to spiritual advice requests',
        route: '/admin/advice',
      ),
      (
        icon: Icons.auto_awesome_rounded,
        color: AppColors.education,
        title: 'Inspiration Publisher',
        subtitle: 'Create and schedule daily inspirations',
        route: '/admin/inspiration',
      ),
      (
        icon: Icons.forum_outlined,
        color: AppColors.financial,
        title: 'Forum Moderation',
        subtitle: 'Review reported posts and moderate content',
        route: '/admin/forum',
      ),
      (
        icon: Icons.menu_book_rounded,
        color: AppColors.family,
        title: 'Sermon Notes',
        subtitle: 'Publish sermon summaries for members',
        route: '/admin/sermon-notes',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('More Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // ── MODULE TILES ──
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: modules.asMap().entries.map((entry) {
                final i = entry.key;
                final m = entry.value;
                return Column(
                  children: [
                    ListTile(
                      onTap: () => context.go(m.route),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: m.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(m.icon, color: m.color, size: 22),
                      ),
                      title: Text(
                        m.title,
                        style: textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        m.subtitle,
                        style: textTheme.bodySmall,
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (i < modules.length - 1)
                      const Divider(height: 1, indent: 72),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── CHURCH SETTINGS ──
          Text(
            'Church Settings',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance_outlined,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Church Profile',
                    style: textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Name, logo, contact info',
                    style: textTheme.bodySmall,
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 1, indent: 72),
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Event Management',
                    style: textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Create and manage events',
                    style: textTheme.bodySmall,
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 1, indent: 72),
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.campaign_outlined,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Announcements',
                    style: textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Publish church announcements',
                    style: textTheme.bodySmall,
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
