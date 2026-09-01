import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

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
      appBar: AppBar(
        title: const Text('Members'),
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
                _StatChip(label: '${users.length} Total', color: colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                _StatChip(
                  label: '$members Members',
                  color: AppColors.education,
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatChip(label: '$admins Admins', color: AppColors.healing),
              ],
            ),
          ),

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
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () => setState(() => _search = ''),
                      )
                    : null,
              ),
            ),
          ),

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
                final avatarColor = isAdmin ? AppColors.healing : colorScheme.primary;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Card(
                    shape: isAdmin
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                            side: BorderSide(color: AppColors.healing.withValues(alpha: 0.5), width: 1.5),
                          )
                        : null,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 6,
                      ),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: avatarColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            u.displayName.substring(0, 1).toUpperCase(),
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            u.displayName,
                            style: textTheme.titleMedium,
                          ),
                          if (isAdmin) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.healing.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Admin',
                                style: textTheme.labelSmall?.copyWith(
                                  fontSize: 9,
                                  color: AppColors.healing,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        u.email,
                        style: textTheme.bodySmall,
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded, size: 18),
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
                                  color: isAdmin ? colorScheme.error : AppColors.healing,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isAdmin ? 'Revoke Admin' : 'Make Admin',
                                  style: textTheme.labelMedium?.copyWith(
                                    color: isAdmin ? colorScheme.error : AppColors.healing,
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
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Send Message',
                                  style: textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
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
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
