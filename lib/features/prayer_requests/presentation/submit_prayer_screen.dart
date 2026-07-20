import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/prayer_request.dart';

class SubmitPrayerScreen extends StatefulWidget {
  const SubmitPrayerScreen({super.key});
  @override
  State<SubmitPrayerScreen> createState() => _SubmitPrayerScreenState();
}

class _SubmitPrayerScreenState extends State<SubmitPrayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  PrayerCategory _category = PrayerCategory.other;
  bool _anonymous = false;
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prayer request submitted. We\'re praying with you.'),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppColors.espresso : AppColors.linen;

    return Scaffold(
      backgroundColor: isDark ? AppColors.umberNight : AppColors.sand,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Share a prayer',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What\'s on your heart?',
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 14,
                  color: isDark ? AppColors.textMutedDark : AppColors.muted,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              _label('Title', isDark),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  hintText: 'Brief title for your prayer',
                  fillColor: card,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              _label('Description', isDark),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descCtrl,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Share what you\'d like prayer for...',
                  fillColor: card,
                  alignLabelWithHint: true,
                ),
                validator: (v) => v == null || v.isEmpty
                    ? 'Please describe your prayer request'
                    : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              _label('Category', isDark),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: PrayerCategory.values.map((c) {
                  final selected = _category == c;
                  return GestureDetector(
                    onTap: () => setState(() => _category = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? (isDark
                                  ? AppColors.burntAmber
                                  : AppColors.terracotta)
                            : card,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                      ),
                      child: Text(
                        '${c.icon} ${c.label}',
                        style: GoogleFonts.schibstedGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: selected
                              ? Colors.white
                              : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.umber),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Anonymous toggle
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send anonymously',
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.umber,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Your name stays hidden',
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textMutedDark
                                  : AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _anonymous,
                      onChanged: (v) => setState(() => _anonymous = v),
                    ),
                  ],
                ),
              ),
              if (_anonymous)
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 13,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Only ICGC's pastoral team can see this.",
                        style: GoogleFonts.schibstedGrotesk(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.xxxl),

              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Send'),
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t, bool isDark) => Text(
    t,
    style: GoogleFonts.schibstedGrotesk(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.textSecondaryDark : AppColors.umber,
      letterSpacing: 0.3,
    ),
  );
}
