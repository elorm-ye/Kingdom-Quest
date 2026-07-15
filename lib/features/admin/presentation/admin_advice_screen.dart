import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/mock_data_service.dart';

/// Admin advice moderation — respond to and close advice requests.
class AdminAdviceScreen extends StatefulWidget {
  const AdminAdviceScreen({super.key});

  @override
  State<AdminAdviceScreen> createState() => _AdminAdviceScreenState();
}

class _AdminAdviceScreenState extends State<AdminAdviceScreen> {
  late List<AdviceRequest> _requests;
  final _replyController = TextEditingController();
  final _bibleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requests = List.from(MockDataService.adviceRequests);
  }

  @override
  void dispose() {
    _replyController.dispose();
    _bibleController.dispose();
    super.dispose();
  }

  void _closeRequest(int idx) {
    final r = _requests[idx];
    setState(() {
      _requests[idx] = AdviceRequest(
        id: r.id, userId: r.userId, churchId: r.churchId,
        title: r.title, description: r.description,
        isAnonymous: r.isAnonymous, anonymousDisplayName: r.anonymousDisplayName,
        status: AdviceStatus.completed, responses: r.responses, createdAt: r.createdAt,
      );
    });
  }

  void _showReplySheet(BuildContext context, int idx, bool isDark, Color primary, Color surface, Color textPrimary, Color textMuted) {
    _replyController.clear();
    _bibleController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSection))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.lg, bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: textMuted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: AppSpacing.lg),
            Text('Spiritual Response', style: GoogleFonts.bricolageGrotesque(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary)),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _replyController,
              maxLines: 4,
              style: GoogleFonts.schibstedGrotesk(fontSize: 14, color: textPrimary),
              decoration: InputDecoration(hintText: 'Write pastoral guidance...', hintStyle: GoogleFonts.schibstedGrotesk(color: textMuted)),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _bibleController,
              style: GoogleFonts.schibstedGrotesk(fontSize: 14, color: textPrimary),
              decoration: InputDecoration(
                hintText: 'Bible references (e.g. John 3:16, Psalm 23)',
                hintStyle: GoogleFonts.schibstedGrotesk(color: textMuted, fontSize: 13),
                prefixIcon: Icon(Icons.menu_book_rounded, color: primary, size: 18),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_replyController.text.trim().isNotEmpty) {
                    Navigator.pop(ctx);
                    _closeRequest(idx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Response sent', style: GoogleFonts.schibstedGrotesk())),
                    );
                  }
                },
                child: Text('Send Response', style: GoogleFonts.schibstedGrotesk(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(AdviceStatus s) {
    switch (s) {
      case AdviceStatus.pending: return AppColors.muted;
      case AdviceStatus.inProgress: return AppColors.burntAmber;
      case AdviceStatus.completed: return AppColors.sage;
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
        title: Text('Advice Center', style: GoogleFonts.bricolageGrotesque(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _requests.length,
        itemBuilder: (ctx, i) {
          final r = _requests[i];
          final sc = _statusColor(r.status);
          final name = r.isAnonymous ? (r.anonymousDisplayName ?? 'Anonymous Member') : 'Member';

          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: sc.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
                        child: Text(r.status.label, style: GoogleFonts.schibstedGrotesk(fontSize: 10, fontWeight: FontWeight.w700, color: sc)),
                      ),
                      const Spacer(),
                      Text(name, style: GoogleFonts.schibstedGrotesk(fontSize: 11, color: textMuted)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(r.title, style: GoogleFonts.bricolageGrotesque(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary)),
                  const SizedBox(height: 4),
                  Text(r.description, style: GoogleFonts.schibstedGrotesk(fontSize: 13, color: textMuted, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpacing.md),
                  if (r.status != AdviceStatus.completed)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => _closeRequest(i),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            side: BorderSide(color: textMuted.withValues(alpha: 0.4)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
                          ),
                          child: Text('Close', style: GoogleFonts.schibstedGrotesk(fontSize: 11, color: textMuted)),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        ElevatedButton.icon(
                          onPressed: () => _showReplySheet(context, i, isDark, primary, surface, textPrimary, textMuted),
                          icon: const Icon(Icons.reply_rounded, size: 14),
                          label: Text('Respond', style: GoogleFonts.schibstedGrotesk(fontSize: 11, fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 14, color: AppColors.sage),
                        const SizedBox(width: 4),
                        Text('Closed', style: GoogleFonts.schibstedGrotesk(fontSize: 11, color: AppColors.sage, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  if (r.responses.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ...r.responses.map((resp) => Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(color: primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(AppSpacing.radiusChip)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(resp.message, style: GoogleFonts.schibstedGrotesk(fontSize: 12, color: textMuted, height: 1.4)),
                          if (resp.bibleReferences.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 4,
                              children: resp.bibleReferences.map((ref) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                child: Text(ref, style: GoogleFonts.schibstedGrotesk(fontSize: 10, color: primary)),
                              )).toList(),
                            ),
                          ],
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ).animate(delay: Duration(milliseconds: i * 60)).fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0);
        },
      ),
    );
  }
}
