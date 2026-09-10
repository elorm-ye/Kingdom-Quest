import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../shared/models/event.dart';
import '../../../shared/services/mock_data_service.dart';
import '../../profile/presentation/widgets/edit_profile_sheet.dart';

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
          Consumer(
            builder: (context, ref, _) {
              final user = ref.watch(currentUserModelProvider).value;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Card(
                  child: Column(
                    children: [
                      settingTile(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        subtitle: user?.displayName ?? 'Update your profile information',
                        onTap: () {
                          if (user != null) {
                            showEditProfileSheet(context, user, ref);
                          }
                        },
                      ),
                      const Divider(height: 1, indent: 56),
                      settingTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change Password',
                        onTap: () => _showChangePasswordDialog(context),
                      ),
                      const Divider(height: 1, indent: 56),
                      settingTile(
                        icon: Icons.church_outlined,
                        title: 'My Church',
                        subtitle: MockDataService.churchProfile['name'] ?? 'Kingdom Quest Youth',
                        onTap: () => _showChurchProfileDialog(
                          context,
                          isAdmin: user?.isAdmin == true,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
                          child: Column(
                            children: [
                              settingTile(
                                icon: Icons.admin_panel_settings_rounded,
                                iconColor: AppColors.healing,
                                title: 'Admin Dashboard',
                                subtitle: 'Manage content, users & church overview',
                                onTap: () => context.go('/admin'),
                              ),
                              const Divider(height: 1, indent: 56),
                              settingTile(
                                icon: Icons.church_rounded,
                                iconColor: colorScheme.primary,
                                title: 'Church Profile',
                                subtitle: 'Edit church name, motto & contact info',
                                onTap: () => _showChurchProfileDialog(context, isAdmin: true),
                              ),
                              const Divider(height: 1, indent: 56),
                              settingTile(
                                icon: Icons.event_available_rounded,
                                iconColor: AppColors.family,
                                title: 'Event Management',
                                subtitle: 'Create and publish church events',
                                onTap: () => _showCreateEventDialog(context),
                              ),
                              const Divider(height: 1, indent: 56),
                              settingTile(
                                icon: Icons.campaign_rounded,
                                iconColor: AppColors.thanksgiving,
                                title: 'Manage Announcements',
                                subtitle: 'Post new announcements to members',
                                onTap: () => _showCreateAnnouncementDialog(
                                  context,
                                  user.displayName,
                                ),
                              ),
                            ],
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
                    subtitle: 'Identity is always hidden for members',
                    trailing: const SizedBox.shrink(),
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
                    icon: Icons.support_agent_outlined,
                    title: 'Contact Support',
                    subtitle: 'Get help from the church admin team',
                    onTap: () => _showContactSupportDialog(context),
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

  void _showChurchProfileDialog(BuildContext context, {required bool isAdmin}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final nameCtrl = TextEditingController(text: MockDataService.churchProfile['name']);
    final mottoCtrl = TextEditingController(text: MockDataService.churchProfile['motto']);
    final locCtrl = TextEditingController(text: MockDataService.churchProfile['location']);
    final phoneCtrl = TextEditingController(text: MockDataService.churchProfile['phone']);
    final emailCtrl = TextEditingController(text: MockDataService.churchProfile['email']);
    final serviceCtrl = TextEditingController(text: MockDataService.churchProfile['serviceTimes']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSection)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xl + bottomInset),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAdmin ? 'Edit Church Profile' : 'Church Information',
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (isAdmin) ...[
                    Text('Church Name', style: textTheme.labelMedium),
                    const SizedBox(height: 4),
                    TextFormField(controller: nameCtrl),
                    const SizedBox(height: AppSpacing.md),
                    Text('Motto / Vision', style: textTheme.labelMedium),
                    const SizedBox(height: 4),
                    TextFormField(controller: mottoCtrl),
                    const SizedBox(height: AppSpacing.md),
                    Text('Location / Address', style: textTheme.labelMedium),
                    const SizedBox(height: 4),
                    TextFormField(controller: locCtrl),
                    const SizedBox(height: AppSpacing.md),
                    Text('Phone Number', style: textTheme.labelMedium),
                    const SizedBox(height: 4),
                    TextFormField(controller: phoneCtrl),
                    const SizedBox(height: AppSpacing.md),
                    Text('Email', style: textTheme.labelMedium),
                    const SizedBox(height: 4),
                    TextFormField(controller: emailCtrl),
                    const SizedBox(height: AppSpacing.md),
                    Text('Service Times', style: textTheme.labelMedium),
                    const SizedBox(height: 4),
                    TextFormField(controller: serviceCtrl, maxLines: 3),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            MockDataService.churchProfile['name'] = nameCtrl.text.trim();
                            MockDataService.churchProfile['motto'] = mottoCtrl.text.trim();
                            MockDataService.churchProfile['location'] = locCtrl.text.trim();
                            MockDataService.churchProfile['phone'] = phoneCtrl.text.trim();
                            MockDataService.churchProfile['email'] = emailCtrl.text.trim();
                            MockDataService.churchProfile['serviceTimes'] = serviceCtrl.text.trim();
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Church profile updated successfully!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Save Church Profile'),
                      ),
                    ),
                  ] else ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MockDataService.churchProfile['name'] ?? 'Kingdom Quest Youth',
                              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              MockDataService.churchProfile['denomination'] ?? '',
                              style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              '"${MockDataService.churchProfile['motto'] ?? ''}"',
                              style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 18),
                                const SizedBox(width: 8),
                                Expanded(child: Text(MockDataService.churchProfile['location'] ?? '', style: textTheme.bodyMedium)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined, size: 18),
                                const SizedBox(width: 8),
                                Text(MockDataService.churchProfile['phone'] ?? '', style: textTheme.bodyMedium),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.email_outlined, size: 18),
                                const SizedBox(width: 8),
                                Text(MockDataService.churchProfile['email'] ?? '', style: textTheme.bodyMedium),
                              ],
                            ),
                            const Divider(height: 24),
                            Text('Service Times', style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(MockDataService.churchProfile['serviceTimes'] ?? '', style: textTheme.bodyMedium?.copyWith(height: 1.5)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCreateEventDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final recurringCtrl = TextEditingController(text: 'Weekly');
    bool isRecurring = false;
    final selectedDate = DateTime.now().add(const Duration(days: 3));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('Add Church Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Event Title', hintText: 'e.g. Youth Prayer Vigil'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: locCtrl,
                  decoration: const InputDecoration(labelText: 'Location', hintText: 'e.g. Main Auditorium'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description', hintText: 'Brief details about the event'),
                ),
                const SizedBox(height: AppSpacing.sm),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Recurring Event'),
                  value: isRecurring,
                  onChanged: (v) => setDlgState(() => isRecurring = v ?? false),
                ),
                if (isRecurring)
                  TextField(
                    controller: recurringCtrl,
                    decoration: const InputDecoration(labelText: 'Pattern', hintText: 'e.g. Weekly, Monthly'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final title = titleCtrl.text.trim();
                if (title.isEmpty) return;
                final newEv = ChurchEvent(
                  id: 'ev_${DateTime.now().millisecondsSinceEpoch}',
                  title: title,
                  description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : 'Join us for this church event.',
                  location: locCtrl.text.trim().isNotEmpty ? locCtrl.text.trim() : 'Main Campus',
                  startTime: selectedDate,
                  endTime: selectedDate.add(const Duration(hours: 2)),
                  isRecurring: isRecurring,
                  recurringPattern: isRecurring ? recurringCtrl.text.trim() : null,
                  createdBy: 'admin_001',
                  registrationCount: 0,
                  isRegistered: false,
                  createdAt: DateTime.now(),
                );
                ref.read(eventsNotifierProvider.notifier).addEvent(newEv);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Event "$title" created and published!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateAnnouncementDialog(BuildContext context, String adminName) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    bool isPinned = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('Publish Announcement'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Announcement Title', hintText: 'e.g. Youth Camp Registration'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: contentCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Announcement Content', hintText: 'Details for church members'),
                ),
                const SizedBox(height: AppSpacing.sm),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Pin Announcement to Top'),
                  value: isPinned,
                  onChanged: (v) => setDlgState(() => isPinned = v ?? false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final title = titleCtrl.text.trim();
                final content = contentCtrl.text.trim();
                if (title.isEmpty || content.isEmpty) return;
                final newAnn = Announcement(
                  id: 'ann_${DateTime.now().millisecondsSinceEpoch}',
                  adminId: 'admin_001',
                  adminName: adminName,
                  title: title,
                  content: content,
                  isPinned: isPinned,
                  createdAt: DateTime.now(),
                );
                ref.read(announcementsNotifierProvider.notifier).addAnnouncement(newAnn);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Announcement "$title" published!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password', hintText: 'Min 6 characters'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (passCtrl.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password must be at least 6 characters.')),
                );
                return;
              }
              if (passCtrl.text != confirmCtrl.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match.')),
                );
                return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password changed successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Need help with your Kingdom Quest app account or church activities?'),
            SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.email_outlined),
              title: Text('Email Support'),
              subtitle: Text('youth@kingdomquest.app'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone_outlined),
              title: Text('Church Office Phone'),
              subtitle: Text('+233 30 268 8000'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.access_time_rounded),
              title: Text('Office Hours'),
              subtitle: Text('Mon - Fri: 8:00 AM - 5:00 PM'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
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
