import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await ref.read(authNotifierProvider.notifier).signIn(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );

    if (!mounted) return;
    if (ok) {
      context.go('/home');
    } else {
      final msg = ref.read(authNotifierProvider.notifier).errorMessage ?? 'Sign in failed.';
      _showError(msg);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showError('Enter your email above first, then tap Forgot Password.');
      return;
    }
    await ref.read(authNotifierProvider.notifier).resetPassword(email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset email sent. Check your inbox.')),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.alert,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppColors.espresso : AppColors.linen;

    return Scaffold(
      backgroundColor: isDark ? AppColors.umberNight : AppColors.sand,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.huge),
              // Brand mark
              Center(child: _mark(isDark))
                  .animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9), duration: 600.ms),
              const SizedBox(height: AppSpacing.xxxl),
              Text('Welcome back',
                  style: GoogleFonts.bricolageGrotesque(
                      fontSize: 28, fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.umber))
                  .animate(delay: 200.ms).fadeIn(duration: 500.ms),
              const SizedBox(height: AppSpacing.sm),
              Text('Sign in to continue your journey',
                  style: GoogleFonts.schibstedGrotesk(
                      fontSize: 14, color: isDark ? AppColors.textMutedDark : AppColors.muted))
                  .animate(delay: 300.ms).fadeIn(duration: 500.ms),
              const SizedBox(height: AppSpacing.xxxl),
              Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _label('Email', isDark),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'your@email.com', fillColor: card,
                        prefixIcon: Icon(Icons.email_outlined,
                            color: isDark ? AppColors.textMutedDark : AppColors.muted, size: 20)),
                    validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _label('Password', isDark),
                  const SizedBox(height: AppSpacing.sm),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                        hintText: 'Enter your password', fillColor: card,
                        prefixIcon: Icon(Icons.lock_outline,
                            color: isDark ? AppColors.textMutedDark : AppColors.muted, size: 20),
                        suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: isDark ? AppColors.textMutedDark : AppColors.muted, size: 20),
                            onPressed: () => setState(() => _obscure = !_obscure))),
                    validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: _forgotPassword,
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Text('Forgot password?',
                            style: GoogleFonts.schibstedGrotesk(fontSize: 13, fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.accentLinkDark : AppColors.terracotta))),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SizedBox(
                    width: double.infinity, height: AppSpacing.buttonHeight,
                    child: ElevatedButton(
                        onPressed: isLoading ? null : _login,
                        child: isLoading
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(Colors.white)))
                            : const Text('Sign In')),
                  ),
                ]),
              ).animate(delay: 400.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, duration: 500.ms),
              const SizedBox(height: AppSpacing.xxl),
              _dividerRow(isDark).animate(delay: 600.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: AppSpacing.xl),
              // Social buttons (Google sign-in placeholder — wire up later)
              Row(children: [
                Expanded(child: _socialBtn(Icons.g_mobiledata_rounded, 'Google', () {
                  _showError('Google sign-in coming soon.');
                }, isDark, card)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _socialBtn(Icons.phone_outlined, 'Phone', () {
                  _showError('Phone sign-in coming soon.');
                }, isDark, card)),
              ]).animate(delay: 700.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: AppSpacing.xxxl),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Don't have an account? ",
                    style: GoogleFonts.schibstedGrotesk(
                        fontSize: 14, color: isDark ? AppColors.textMutedDark : AppColors.muted)),
                GestureDetector(
                    onTap: () => context.push('/register'),
                    child: Text('Sign Up',
                        style: GoogleFonts.schibstedGrotesk(fontSize: 14, fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.accentLinkDark : AppColors.terracotta))),
              ]).animate(delay: 800.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: AppSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mark(bool isDark) => Container(
    width: 72, height: 72,
    decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
    child: Center(child: Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: AppColors.linen.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18),
              bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6))),
      child: Center(child: Container(width: 14, height: 14,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: const BoxDecoration(color: AppColors.terracotta, shape: BoxShape.circle))),
    )),
  );

  Widget _label(String t, bool isDark) => Text(t,
      style: GoogleFonts.schibstedGrotesk(fontSize: 13, fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textSecondaryDark : AppColors.umber, letterSpacing: 0.3));

  Widget _dividerRow(bool isDark) => Row(children: [
    Expanded(child: Divider(color: isDark ? const Color(0xFF4A3A30) : const Color(0xFFD9CEBD))),
    Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Text('or continue with',
            style: GoogleFonts.schibstedGrotesk(
                fontSize: 12, color: isDark ? AppColors.textMutedDark : AppColors.muted))),
    Expanded(child: Divider(color: isDark ? const Color(0xFF4A3A30) : const Color(0xFFD9CEBD))),
  ]);

  Widget _socialBtn(IconData icon, String label, VoidCallback onTap, bool isDark, Color card) =>
      Material(
        color: card, borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
            child: Container(height: AppSpacing.buttonHeight, alignment: Alignment.center,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(icon, size: 22, color: isDark ? AppColors.textPrimaryDark : AppColors.umber),
                  const SizedBox(width: AppSpacing.sm),
                  Text(label, style: GoogleFonts.schibstedGrotesk(fontSize: 14, fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.umber)),
                ]))),
      );
}
