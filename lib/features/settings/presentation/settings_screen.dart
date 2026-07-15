import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/services/mock_data_service.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;
    final divider = isDark ? const Color(0xFF3D2E25) : const Color(0xFFE5D9C9);

    Widget sectionHeader(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.schibstedGrotesk(fontSize: 11, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 0.8),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 4),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: (iconColor ?? primary).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: iconColor ?? primary),
        ),
        title: Text(title, style: GoogleFonts.schibstedGrotesk(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary)),
        subtitle: subtitle != null ? Text(subtitle, style: GoogleFonts.schibstedGrotesk(fontSize: 12, color: textMuted)) : null,
        trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right_rounded, color: textMuted, size: 20) : null),
      );
    }

    Widget notifTile(String title, bool value, ValueChanged<bool> onChanged) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 0),
      title: Text(title, style: GoogleFonts.schibstedGrotesk(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: primary,
      ),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        title: Text('Settings', style: GoogleFonts.bricolageGrotesque(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary)),
      ),
      body: ListView(
        children: [
          // ── APPEARANCE ──
          sectionHeader('Appearance').animate().fadeIn(duration: 300.ms),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
            child: Column(
              children: [
                // Theme mode tiles
                _ThemeOptionTile(
                  icon: Icons.light_mode_rounded,
                  label: 'Light',
                  selected: themeMode == ThemeMode.light,
                  primary: primary,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  onTap: () => ref.read(themeModeProvider.notifier).setTheme(ThemeMode.light),
                ),
                Divider(height: 1, color: divider, indent: 56),
                _ThemeOptionTile(
                  icon: Icons.dark_mode_rounded,
                  label: 'Dark',
                  selected: themeMode == ThemeMode.dark,
                  primary: primary,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  onTap: () => ref.read(themeModeProvider.notifier).setTheme(ThemeMode.dark),
                ),
                Divider(height: 1, color: divider, indent: 56),
                _ThemeOptionTile(
                  icon: Icons.contrast_rounded,
                  label: 'System Default',
                  selected: themeMode == ThemeMode.system,
                  primary: primary,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  onTap: () => ref.read(themeModeProvider.notifier).setTheme(ThemeMode.system),
                ),
              ],
            ),
          ).animate(delay: 50.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),

          // ── NOTIFICATIONS ──
          sectionHeader('Notifications').animate(delay: 80.ms).fadeIn(duration: 300.ms),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
            child: Column(
              children: [
                notifTile('Prayer Responses', _notifPrayer, (v) => setState(() => _notifPrayer = v)),
                Divider(height: 1, color: divider, indent: 16),
                notifTile('Daily Inspirations', _notifInspiration, (v) => setState(() => _notifInspiration = v)),
                Divider(height: 1, color: divider, indent: 16),
                notifTile('Event Reminders', _notifEvents, (v) => setState(() => _notifEvents = v)),
                Divider(height: 1, color: divider, indent: 16),
                notifTile('Announcements', _notifAnnouncements, (v) => setState(() => _notifAnnouncements = v)),
              ],
            ),
          ).animate(delay: 120.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),

          // ── ACCOUNT ──
          sectionHeader('Account').animate(delay: 160.ms).fadeIn(duration: 300.ms),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
            child: Column(
              children: [
                settingTile(icon: Icons.person_outline_rounded, title: 'Edit Profile', onTap: () {}),
                Divider(height: 1, color: divider, indent: 56),
                settingTile(icon: Icons.lock_outline_rounded, title: 'Change Password', onTap: () {}),
                Divider(height: 1, color: divider, indent: 56),
                settingTile(icon: Icons.church_outlined, title: 'My Church', subtitle: 'Kingdom Quest Youth', onTap: () {}),
              ],
            ),
          ).animate(delay: 180.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),

          // ── ADMIN PANEL (admin-role only) ──
          if (MockDataService.currentUser.isAdmin) ...[  
            sectionHeader('Admin').animate(delay: 200.ms).fadeIn(duration: 300.ms),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
              child: settingTile(
                icon: Icons.admin_panel_settings_rounded,
                iconColor: AppColors.sage,
                title: 'Admin Dashboard',
                subtitle: 'Manage content, users & church settings',
                onTap: () => context.go('/admin'),
              ),
            ).animate(delay: 210.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
          ],

          // ── PRIVACY ──
          sectionHeader('Privacy & Security').animate(delay: 220.ms).fadeIn(duration: 300.ms),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
            child: Column(
              children: [
                settingTile(icon: Icons.visibility_off_outlined, title: 'Anonymous Forum', subtitle: 'Identity is always hidden', trailing: const SizedBox.shrink()),
                Divider(height: 1, color: divider, indent: 56),
                settingTile(icon: Icons.shield_outlined, title: 'Privacy Policy', onTap: () {}),
                Divider(height: 1, color: divider, indent: 56),
                settingTile(icon: Icons.description_outlined, title: 'Terms of Service', onTap: () {}),
              ],
            ),
          ).animate(delay: 240.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),

          // ── ABOUT ──
          sectionHeader('About').animate(delay: 280.ms).fadeIn(duration: 300.ms),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
            child: Column(
              children: [
                settingTile(icon: Icons.info_outline_rounded, title: 'App Version', subtitle: '1.0.0 (Build 1)', trailing: const SizedBox.shrink()),
                Divider(height: 1, color: divider, indent: 56),
                settingTile(icon: Icons.star_outline_rounded, title: 'Rate the App', onTap: () {}),
                Divider(height: 1, color: divider, indent: 56),
                settingTile(icon: Icons.support_agent_outlined, title: 'Contact Support', onTap: () {}),
              ],
            ),
          ).animate(delay: 300.ms).fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),

          const SizedBox(height: AppSpacing.lg),

          // ── SIGN OUT ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
              child: settingTile(
                icon: Icons.logout_rounded,
                title: 'Sign Out',
                iconColor: AppColors.alert,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: surface,
                      title: Text('Sign Out?', style: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w700, color: textPrimary)),
                      content: Text('Are you sure you want to sign out?', style: GoogleFonts.schibstedGrotesk(color: textMuted)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.schibstedGrotesk(color: textMuted))),
                        TextButton(
                          onPressed: () { Navigator.pop(ctx); },
                          child: Text('Sign Out', style: GoogleFonts.schibstedGrotesk(color: AppColors.alert, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ).animate(delay: 340.ms).fadeIn(duration: 350.ms),

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
  final Color primary;
  final Color textPrimary;
  final Color textMuted;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.primary,
    required this.textPrimary,
    required this.textMuted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: selected ? primary.withValues(alpha: 0.15) : primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: selected ? primary : textMuted),
      ),
      title: Text(label, style: GoogleFonts.schibstedGrotesk(fontSize: 14, fontWeight: selected ? FontWeight.w600 : FontWeight.w500, color: selected ? primary : textPrimary)),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: primary, size: 20)
          : null,
    );
  }
}
