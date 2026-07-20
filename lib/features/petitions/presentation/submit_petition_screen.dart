import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class SubmitPetitionScreen extends StatefulWidget {
  const SubmitPetitionScreen({super.key});
  @override
  State<SubmitPetitionScreen> createState() => _SubmitPetitionScreenState();
}

class _SubmitPetitionScreenState extends State<SubmitPetitionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _anonymous = false;
  bool _loading = false;

  @override
  void dispose() {
    _subjectCtrl.dispose();
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
        const SnackBar(content: Text('Petition submitted successfully.')),
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
          'Submit Petition',
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
                'Share a concern, report an issue, or suggest an improvement.',
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 14,
                  color: isDark ? AppColors.textMutedDark : AppColors.muted,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _label('Subject', isDark),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _subjectCtrl,
                decoration: InputDecoration(
                  hintText: 'What is this about?',
                  fillColor: card,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter a subject' : null,
              ),
              const SizedBox(height: AppSpacing.xl),
              _label('Description', isDark),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descCtrl,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe in detail...',
                  fillColor: card,
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Describe your petition' : null,
              ),
              const SizedBox(height: AppSpacing.xxl),
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
                            'Submit anonymously',
                            style: GoogleFonts.schibstedGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.umber,
                            ),
                          ),
                          Text(
                            'Your identity will be hidden',
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
                      : const Text('Submit Petition'),
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
