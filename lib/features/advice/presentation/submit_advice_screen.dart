import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class SubmitAdviceScreen extends StatefulWidget {
  const SubmitAdviceScreen({super.key});
  @override
  State<SubmitAdviceScreen> createState() => _SubmitAdviceScreenState();
}

class _SubmitAdviceScreenState extends State<SubmitAdviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _anonymous = true;
  bool _loading = false;

  @override
  void dispose() { _titleCtrl.dispose(); _descCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your question has been submitted.')));
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
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: Text('Ask for Advice', style: GoogleFonts.bricolageGrotesque(fontSize: 20, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ask a question, request counseling, or seek biblical guidance.',
                style: GoogleFonts.schibstedGrotesk(fontSize: 14, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
            const SizedBox(height: AppSpacing.xxl),
            _label('Question Title', isDark), const SizedBox(height: AppSpacing.sm),
            TextFormField(controller: _titleCtrl, decoration: InputDecoration(hintText: 'What would you like guidance on?', fillColor: card),
                validator: (v) => v == null || v.isEmpty ? 'Enter a title' : null),
            const SizedBox(height: AppSpacing.xl),
            _label('Detailed Description', isDark), const SizedBox(height: AppSpacing.sm),
            TextFormField(controller: _descCtrl, maxLines: 6,
                decoration: InputDecoration(hintText: 'Share more details so we can help...', fillColor: card, alignLabelWithHint: true),
                validator: (v) => v == null || v.isEmpty ? 'Please describe your question' : null),
            const SizedBox(height: AppSpacing.xxl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Ask anonymously', style: GoogleFonts.schibstedGrotesk(fontSize: 14, fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.umber)),
                  Text('Your identity is kept private', style: GoogleFonts.schibstedGrotesk(fontSize: 12,
                      color: isDark ? AppColors.textMutedDark : AppColors.muted)),
                ])),
                Switch(value: _anonymous, onChanged: (v) => setState(() => _anonymous = v)),
              ]),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            SizedBox(width: double.infinity, height: AppSpacing.buttonHeight,
              child: ElevatedButton(onPressed: _loading ? null : _submit,
                  child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                      : const Text('Submit Question'))),
            const SizedBox(height: AppSpacing.huge),
          ]),
        ),
      ),
    );
  }

  Widget _label(String t, bool isDark) => Text(t, style: GoogleFonts.schibstedGrotesk(fontSize: 13, fontWeight: FontWeight.w500,
      color: isDark ? AppColors.textSecondaryDark : AppColors.umber, letterSpacing: 0.3));
}
