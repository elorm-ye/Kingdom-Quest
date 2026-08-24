import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../core/providers/feature_providers.dart';

/// Admin user management — view members, assign roles.
class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;

    final asyncUsers = ref.watch(adminUsersNotifierProvider);
    final users = asyncUsers.value ?? [];

    List<UserModel> filtered() {
      if (_search.isEmpty) return users;
      final q = _search.toLowerCase();
      return users
          .where(
            (u) =>
                u.displayName.toLowerCase().contains(q) ||
                u.email.toLowerCase().contains(q),
          )
          .toList();
    }

    final admins = users.where((u) => u.isAdmin).length;
    final members = users.length - admins;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Members',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── HEADER STATS ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                _StatChip(label: '${users.length} Total', color: primary),
                const SizedBox(width: AppSpacing.sm),
                _StatChip(
                  label: '$members Members',
                  color: const Color(0xFF6B7FD4),
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatChip(label: '$admins Admins', color: AppColors.sage),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          // ── SEARCH ──
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: GoogleFonts.schibstedGrotesk(
                fontSize: 14,
                color: textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search members...',
                hintStyle: GoogleFonts.schibstedGrotesk(color: textMuted),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: textMuted,
                  size: 20,
                ),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: textMuted,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _search = ''),
                      )
                    : null,
              ),
            ),
          ).animate(delay: 50.ms).fadeIn(duration: 300.ms),

          // ── MEMBERS LIST ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              itemCount: filtered().length,
              itemBuilder: (ctx, i) {
                final u = filtered()[i];
                final isAdmin = u.role == UserRole.admin;

                return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusCard,
                        ),
                        border: isAdmin
                            ? Border.all(
                                color: AppColors.sage.withValues(alpha: 0.3),
                                width: 1,
                              )
                            : null,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 6,
                        ),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isAdmin
                                  ? [AppColors.sage, AppColors.oliveClay]
                                  : [
                                      AppColors.terracotta,
                                      AppColors.burntAmber,
                                    ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              u.displayName.substring(0, 1).toUpperCase(),
                              style: GoogleFonts.bricolageGrotesque(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              u.displayName,
                              style: GoogleFonts.schibstedGrotesk(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            if (isAdmin) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.sage.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Admin',
                                  style: GoogleFonts.schibstedGrotesk(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.sage,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          u.email,
                          style: GoogleFonts.schibstedGrotesk(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          color: surface,
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: textMuted,
                            size: 18,
                          ),
                          onSelected: (action) {
                            if (action == 'toggle') {
                            ref.read(adminUsersNotifierProvider.notifier).toggleRole(
                              userId: u.id,
                              makeAdmin: !u.isAdmin,
                            );
                          }
                          },
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              value: 'toggle',
                              child: Row(
                                children: [
                                  Icon(
                                    isAdmin
                                        ? Icons.person_rounded
                                        : Icons.admin_panel_settings_rounded,
                                    size: 16,
                                    color: isAdmin
                                        ? AppColors.alert
                                        : AppColors.sage,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isAdmin ? 'Revoke Admin' : 'Make Admin',
                                    style: GoogleFonts.schibstedGrotesk(
                                      fontSize: 13,
                                      color: isAdmin
                                          ? AppColors.alert
                                          : AppColors.sage,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'message',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 16,
                                    color: textMuted,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Send Message',
                                    style: GoogleFonts.schibstedGrotesk(
                                      fontSize: 13,
                                      color: textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate(delay: Duration(milliseconds: i * 40))
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.05, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.schibstedGrotesk(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
