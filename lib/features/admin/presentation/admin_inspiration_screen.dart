import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/services/mock_data_service.dart';

/// Admin inspiration publisher — create and publish daily inspiration posts.
class AdminInspirationScreen extends StatefulWidget {
  const AdminInspirationScreen({super.key});

  @override
  State<AdminInspirationScreen> createState() => _AdminInspirationScreenState();
}

class _AdminInspirationScreenState extends State<AdminInspirationScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _bibleRefController = TextEditingController();
  String _selectedType = 'motivation';
  bool _isPublishing = false;
  bool _published = false;

  final _types = [
    (
      value: 'motivation',
      label: 'Motivation',
      icon: Icons.local_fire_department_rounded,
      color: AppColors.terracotta,
    ),
    (
      value: 'devotional',
      label: 'Devotional',
      icon: Icons.menu_book_rounded,
      color: AppColors.sage,
    ),
    (
      value: 'verse',
      label: 'Bible Verse',
      icon: Icons.format_quote_rounded,
      color: AppColors.burntAmber,
    ),
    (
      value: 'challenge',
      label: 'Challenge',
      icon: Icons.emoji_events_rounded,
      color: const Color(0xFF6B7FD4),
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _bibleRefController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty)
      return;
    setState(() => _isPublishing = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _isPublishing = false;
      _published = true;
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _published = false;
      _titleController.clear();
      _contentController.clear();
      _bibleRefController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.burntAmber : AppColors.terracotta;
    final bg = isDark ? AppColors.umberNight : AppColors.sand;
    final surface = isDark ? AppColors.espresso : AppColors.linen;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.umber;
    final textMuted = isDark ? AppColors.textMutedDark : AppColors.muted;

    final recentInspirations = MockDataService.inspirations.take(3).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Inspiration Publisher',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── TYPE SELECTOR ──
            Text(
              'Post Type',
              style: GoogleFonts.schibstedGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _types.map((t) {
                  final active = _selectedType == t.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = t.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: active ? t.color : surface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusCard,
                        ),
                        border: active
                            ? null
                            : Border.all(color: t.color.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            t.icon,
                            size: 18,
                            color: active ? Colors.white : t.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            t.label,
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: active ? Colors.white : t.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: AppSpacing.lg),

            // ── COMPOSE FORM ──
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _titleController,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Give your post a title...',
                      hintStyle: GoogleFonts.schibstedGrotesk(
                        color: textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    'Content',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _contentController,
                    maxLines: 6,
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 14,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write your message...',
                      hintStyle: GoogleFonts.schibstedGrotesk(color: textMuted),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    'Bible Reference (optional)',
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _bibleRefController,
                    style: GoogleFonts.schibstedGrotesk(
                      fontSize: 14,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Philippians 4:13',
                      hintStyle: GoogleFonts.schibstedGrotesk(color: textMuted),
                      prefixIcon: HugeIcon(
                        icon: HugeIcons.strokeRoundedBook01,
                        size: 18,
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 100.ms).fadeIn(duration: 350.ms),

            const SizedBox(height: AppSpacing.lg),

            // ── PUBLISH BUTTON ──
            SizedBox(
              width: double.infinity,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _published
                    ? Container(
                        key: const ValueKey('success'),
                        height: AppSpacing.buttonHeight,
                        decoration: BoxDecoration(
                          color: AppColors.sage,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusChip,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                              color: Colors.white,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Published!',
                              style: GoogleFonts.schibstedGrotesk(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ElevatedButton.icon(
                        key: const ValueKey('publish'),
                        onPressed: _isPublishing ? null : _publish,
                        icon: _isPublishing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const HugeIcon(
                                icon: HugeIcons.strokeRoundedSent,
                                size: 18,
                              ),
                        label: Text(
                          _isPublishing ? 'Publishing...' : 'Publish Now',
                          style: GoogleFonts.schibstedGrotesk(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            AppSpacing.buttonHeight,
                          ),
                        ),
                      ),
              ),
            ).animate(delay: 150.ms).fadeIn(duration: 350.ms),

            const SizedBox(height: AppSpacing.xl),

            // ── RECENT POSTS ──
            Text(
              'Recent Posts',
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...recentInspirations.asMap().entries.map((e) {
              final ins = e.value;
              return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusCard,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedSparkles,
                            size: 18,
                            color: primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ins.title,
                                style: GoogleFonts.schibstedGrotesk(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                ins.type.label,
                                style: GoogleFonts.schibstedGrotesk(
                                  fontSize: 11,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.sage.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Live',
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 10,
                              color: AppColors.sage,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate(delay: Duration(milliseconds: 200 + e.key * 60))
                  .fadeIn(duration: 300.ms);
            }),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
