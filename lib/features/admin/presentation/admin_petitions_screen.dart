import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/mock_data_service.dart';

/// Admin petitions screen — update status, view details.
class AdminPetitionsScreen extends StatefulWidget {
  const AdminPetitionsScreen({super.key});

  @override
  State<AdminPetitionsScreen> createState() => _AdminPetitionsScreenState();
}

class _AdminPetitionsScreenState extends State<AdminPetitionsScreen> {
  late List<Petition> _petitions;

  @override
  void initState() {
    super.initState();
    _petitions = List.from(MockDataService.petitions);
  }

  void _updateStatus(int idx, PetitionStatus newStatus) {
    final p = _petitions[idx];
    setState(() {
      _petitions[idx] = Petition(
        id: p.id,
        userId: p.userId,
        churchId: p.churchId,
        subject: p.subject,
        description: p.description,
        isAnonymous: p.isAnonymous,
        submitterName: p.submitterName,
        anonymousDisplayName: p.anonymousDisplayName,
        status: newStatus,
        createdAt: p.createdAt,
        updatedAt: DateTime.now(),
      );
    });
  }

  Color _statusColor(PetitionStatus s) {
    switch (s) {
      case PetitionStatus.pending:
        return AppColors.muted;
      case PetitionStatus.underReview:
        return AppColors.burntAmber;
      case PetitionStatus.resolved:
        return AppColors.sage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Petitions',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Chip(
              label: Text(
                '${_petitions.length} total',
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 11,
                  color: primary,
                ),
              ),
              backgroundColor: primary.withValues(alpha: 0.1),
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: _petitions.isEmpty
          ? Center(
              child: Text(
                'No petitions yet',
                style: GoogleFonts.schibstedGrotesk(color: textMuted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: _petitions.length,
              itemBuilder: (ctx, i) {
                final p = _petitions[i];
                final statusColor = _statusColor(p.status);
                final name = p.isAnonymous
                    ? (p.anonymousDisplayName ?? 'Anonymous Member')
                    : (p.submitterName ?? 'Member');

                return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusCard,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.2 : 0.05,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusFull,
                                    ),
                                  ),
                                  child: Text(
                                    p.status.label,
                                    style: GoogleFonts.schibstedGrotesk(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  p.isAnonymous
                                      ? Icons.person_off_outlined
                                      : Icons.person_outline,
                                  size: 13,
                                  color: textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  name,
                                  style: GoogleFonts.schibstedGrotesk(
                                    fontSize: 11,
                                    color: textMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              p.subject,
                              style: GoogleFonts.bricolageGrotesque(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p.description,
                              style: GoogleFonts.schibstedGrotesk(
                                fontSize: 13,
                                color: textMuted,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            // Status update buttons
                            Row(
                              children: [
                                Text(
                                  'Update:',
                                  style: GoogleFonts.schibstedGrotesk(
                                    fontSize: 11,
                                    color: textMuted,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                ...PetitionStatus.values.map((s) {
                                  final isActive = p.status == s;
                                  final sc = _statusColor(s);
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: GestureDetector(
                                      onTap: isActive
                                          ? null
                                          : () => _updateStatus(i, s),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? sc
                                              : sc.withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(
                                            AppSpacing.radiusFull,
                                          ),
                                          border: Border.all(
                                            color: sc.withValues(alpha: 0.4),
                                          ),
                                        ),
                                        child: Text(
                                          s.label,
                                          style: GoogleFonts.schibstedGrotesk(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: isActive ? Colors.white : sc,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate(delay: Duration(milliseconds: i * 60))
                    .fadeIn(duration: 350.ms)
                    .slideY(begin: 0.1, end: 0);
              },
            ),
    );
  }
}
