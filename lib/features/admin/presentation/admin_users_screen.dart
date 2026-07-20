import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/mock_data_service.dart';

/// Admin user management — view members, assign roles.
class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late List<UserModel> _users;
  String _search = '';

  @override
  void initState() {
    super.initState();
    // Populate with a mix of mock users
    _users = [
      MockDataService.currentUser,
      UserModel(
        id: 'u2',
        email: 'grace@example.com',
        displayName: 'Grace Mensah',
        role: UserRole.member,
        gender: Gender.female,
        bio: 'Youth group leader',
        createdAt: DateTime(2024, 3, 10),
      ),
      UserModel(
        id: 'u3',
        email: 'kwame@example.com',
        displayName: 'Kwame Asante',
        role: UserRole.member,
        gender: Gender.male,
        createdAt: DateTime(2024, 5, 22),
      ),
      UserModel(
        id: 'u4',
        email: 'abena@example.com',
        displayName: 'Abena Boateng',
        role: UserRole.admin,
        gender: Gender.female,
        createdAt: DateTime(2024, 1, 5),
      ),
      UserModel(
        id: 'u5',
        email: 'kofi@example.com',
        displayName: 'Kofi Agyeman',
        role: UserRole.member,
        gender: Gender.male,
        createdAt: DateTime(2024, 7, 1),
      ),
      UserModel(
        id: 'u6',
        email: 'ama@example.com',
        displayName: 'Ama Darko',
        role: UserRole.member,
        gender: Gender.female,
        createdAt: DateTime(2024, 6, 15),
      ),
      UserModel(
        id: 'u7',
        email: 'yaw@example.com',
        displayName: 'Yaw Osei',
        role: UserRole.member,
        gender: Gender.male,
        createdAt: DateTime(2024, 8, 3),
      ),
      UserModel(
        id: 'u8',
        email: 'akua@example.com',
        displayName: 'Akua Frimpong',
        role: UserRole.member,
        gender: Gender.female,
        createdAt: DateTime(2024, 9, 20),
      ),
    ];
  }

  void _toggleRole(int idx) {
    final u = _users[idx];
    setState(() {
      _users[idx] = u.copyWith(
        role: u.role == UserRole.admin ? UserRole.member : UserRole.admin,
      );
    });
  }

  List<UserModel> get _filtered {
    if (_search.isEmpty) return _users;
    final q = _search.toLowerCase();
    return _users
        .where(
          (u) =>
              u.displayName.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;

    final admins = _users.where((u) => u.isAdmin).length;
    final members = _users.length - admins;

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
                _StatChip(label: '${_users.length} Total', color: primary),
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
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final u = _filtered[i];
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
                            if (action == 'toggle') _toggleRole(i);
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
