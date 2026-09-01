import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/app_providers.dart';

/// Settings screen — theme, account, privacy, about.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notifPrayer = true;
  bool _notifInspiration = true;
  bool _notifEvents = true;
  bool _notifAnnouncements = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final themeMode = ref.watch(themeModeProvider);

    Widget sectionHeader(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );

    Widget settingTile({
      required IconData icon,
      required String title,
      String? subtitle,
      Widget? trailing,
      VoidCallback? onTap,
      Color? iconColor,
    }) {
      return ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 4,
        ),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: (iconColor ?? colorScheme.primary).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: iconColor ?? colorScheme.primary),
        ),
        title: Text(
          title,
          style: textTheme.titleMedium,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: textTheme.bodySmall,
              )
            : null,
        trailing:
            trailing ??
            (onTap != null
                ? Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  )
                : null),
      );
    }

    Widget notifTile(String title, bool value, ValueChanged<bool> onChanged) =>
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 0,
          ),
          title: Text(
            title,
            style: textTheme.titleMedium,
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // ── APPEARANCE ──
          sectionHeader('Appearance'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(
              child: Column(
                children: [
                  _ThemeOptionTile(
                    icon: Icons.light_mode_rounded,
                    label: 'Light',
                    selected: themeMode == ThemeMode.light,
                    theme: theme,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setTheme(ThemeMode.light),
                  ),
                  const Divider(height: 1, indent: 56),
                  _ThemeOptionTile(
                    icon: Icons.dark_mode_rounded,
                    label: 'Dark',
                    selected: themeMode == ThemeMode.dark,
                    theme: theme,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setTheme(ThemeMode.dark),
                  ),
                  const Divider(height: 1, indent: 56),
                  _ThemeOptionTile(
                    icon: Icons.contrast_rounded,
                    label: 'System Default',
                    selected: themeMode == ThemeMode.system,
                    theme: theme,
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setTheme(ThemeMode.system),
                  ),
                ],
              ),
            ),
          ),

          // ── NOTIFICATIONS ──
          sectionHeader('Notifications'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(
              child: Column(
                children: [
                  notifTile(
                    'Prayer Responses',
                    _notifPrayer,
                    (v) => setState(() => _notifPrayer = v),
                  ),
                  const Divider(height: 1, indent: 16),
                  notifTile(
                    'Daily Inspirations',
                    _notifInspiration,
                    (v) => setState(() => _notifInspiration = v),
                  ),
                  const Divider(height: 1, indent: 16),
                  notifTile(
                    'Event Reminders',
                    _notifEvents,
                    (v) => setState(() => _notifEvents = v),
                  ),
                  const Divider(height: 1, indent: 16),
                  notifTile(
                    'Announcements',
                    _notifAnnouncements,
                    (v) => setState(() => _notifAnnouncements = v),
                  ),
                ],
              ),
            ),
          ),

          // ── ACCOUNT ──
          sectionHeader('Account'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(
              child: Column(
                children: [
                  settingTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  settingTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Change Password',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  settingTile(
                    icon: Icons.church_outlined,
                    title: 'My Church',
                    subtitle: 'Kingdom Quest Youth',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // ── ADMIN PANEL (admin-role only) ──
          Consumer(
            builder: (context, ref, _) {
              final userAsync = ref.watch(currentUserModelProvider);
              return userAsync.when(
                data: (user) {
                  if (user == null || !user.isAdmin) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionHeader('Admin'),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: Card(
                          child: settingTile(
                            icon: Icons.admin_panel_settings_rounded,
                            iconColor: AppColors.healing,
                            title: 'Admin Dashboard',
                            subtitle: 'Manage content, users & church settings',
                            onTap: () => context.go('/admin'),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),

          // ── PRIVACY ──
          sectionHeader('Privacy & Security'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(
              child: Column(
                children: [
                  settingTile(
                    icon: Icons.visibility_off_outlined,
                    title: 'Anonymous Forum',
                    subtitle: 'Identity is always hidden',
                    trailing: const SizedBox.shrink(),
                  ),
                  const Divider(height: 1, indent: 56),
                  settingTile(
                    icon: Icons.shield_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  settingTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // ── ABOUT ──
          sectionHeader('About'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(
              child: Column(
                children: [
                  settingTile(
                    icon: Icons.info_outline_rounded,
                    title: 'App Version',
                    subtitle: '1.0.0 (Build 1)',
                    trailing: const SizedBox.shrink(),
                  ),
                  const Divider(height: 1, indent: 56),
                  settingTile(
                    icon: Icons.star_outline_rounded,
                    title: 'Rate the App',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  settingTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Contact Support',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── SIGN OUT ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(
              child: settingTile(
                icon: Icons.logout_rounded,
                title: 'Sign Out',
                iconColor: colorScheme.error,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Sign Out?'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(ctx);
                            await ref.read(authNotifierProvider.notifier).signOut();
                            if (context.mounted) context.go('/login');
                          },
                          child: Text(
                            'Sign Out',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final ThemeData theme;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 4,
      ),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary.withValues(alpha: 0.12) : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
      ),
      title: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      trailing: selected
          ? Icon(
              Icons.check_circle_rounded,
              color: theme.colorScheme.primary,
              size: 20,
            )
          : null,
    );
  }
}
