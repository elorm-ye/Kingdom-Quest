import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String _gender = 'preferNotToSay';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _loading = false);
      context.go('/home');
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
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: AppSpacing.xxl),
              Text('Join Kingdom Quest',
                  style: GoogleFonts.bricolageGrotesque(fontSize: 24, fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.umber))
                  .animate().fadeIn(duration: 500.ms),
              const SizedBox(height: AppSpacing.sm),
              Text('A safe, sacred space for young people',
                  style: GoogleFonts.schibstedGrotesk(fontSize: 14, color: isDark ? AppColors.textMutedDark : AppColors.muted))
                  .animate(delay: 100.ms).fadeIn(duration: 500.ms),
              const SizedBox(height: AppSpacing.xxxl),

              _label('Full Name', isDark),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(hintText: 'Enter your name', fillColor: card,
                    prefixIcon: Icon(Icons.person_outline, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
                validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              _label('Email', isDark),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'your@email.com', fillColor: card,
                    prefixIcon: Icon(Icons.email_outlined, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
                validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              _label('Gender', isDark),
              const SizedBox(height: AppSpacing.sm),
              Container(
                decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(AppSpacing.radiusChip)),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: const InputDecoration(border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, fillColor: Colors.transparent),
                  dropdownColor: card,
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Brother')),
                    DropdownMenuItem(value: 'female', child: Text('Sister')),
                    DropdownMenuItem(value: 'preferNotToSay', child: Text('Prefer not to say')),
                  ],
                  onChanged: (v) => setState(() => _gender = v ?? 'preferNotToSay'),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              _label('Password', isDark),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(hintText: 'Min 6 characters', fillColor: card,
                    prefixIcon: Icon(Icons.lock_outline, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.muted),
                    suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20,
                            color: isDark ? AppColors.textMutedDark : AppColors.muted),
                        onPressed: () => setState(() => _obscure = !_obscure))),
                validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
              ),
              const SizedBox(height: AppSpacing.xl),

              _label('Confirm Password', isDark),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _confirmCtrl,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Re-enter password', fillColor: card,
                    prefixIcon: Icon(Icons.lock_outline, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
                validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: AppSpacing.xxxl),

              SizedBox(
                width: double.infinity, height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    child: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                        : const Text('Create Account')),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Already have an account? ',
                    style: GoogleFonts.schibstedGrotesk(fontSize: 14, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
                GestureDetector(
                    onTap: () => context.pop(),
                    child: Text('Sign In',
                        style: GoogleFonts.schibstedGrotesk(fontSize: 14, fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.accentLinkDark : AppColors.terracotta))),
              ])),
              const SizedBox(height: AppSpacing.huge),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _label(String t, bool isDark) => Text(t,
      style: GoogleFonts.schibstedGrotesk(fontSize: 13, fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textSecondaryDark : AppColors.umber, letterSpacing: 0.3));
}
