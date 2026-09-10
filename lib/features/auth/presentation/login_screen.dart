import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = true;
  bool _hasSavedCredentials = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final savedEmail = await _storage.read(key: 'saved_email');
      final savedPass = await _storage.read(key: 'saved_password');
      final rememberFlag = await _storage.read(key: 'remember_me');
      if (savedEmail != null && savedEmail.isNotEmpty) {
        setState(() {
          _emailCtrl.text = savedEmail;
          if (savedPass != null) _passCtrl.text = savedPass;
          _hasSavedCredentials = true;
          _rememberMe = rememberFlag != 'false';
        });
      }
    } catch (_) {}
  }

  Future<void> _saveCredentials(String email, String password) async {
    try {
      if (_rememberMe) {
        await _storage.write(key: 'saved_email', value: email);
        await _storage.write(key: 'saved_password', value: password);
        await _storage.write(key: 'remember_me', value: 'true');
      } else {
        await _storage.delete(key: 'saved_email');
        await _storage.delete(key: 'saved_password');
        await _storage.write(key: 'remember_me', value: 'false');
      }
    } catch (_) {}
  }

  Future<void> _clearSavedCredentials() async {
    try {
      await _storage.delete(key: 'saved_email');
      await _storage.delete(key: 'saved_password');
      await _storage.delete(key: 'remember_me');
      setState(() {
        _hasSavedCredentials = false;
        _emailCtrl.clear();
        _passCtrl.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved login credentials cleared.')),
        );
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    final ok = await ref
        .read(authNotifierProvider.notifier)
        .signIn(email: email, password: password);

    if (!mounted) return;
    if (ok) {
      await _saveCredentials(email, password);
      final demoUser = ref.read(demoUserModelProvider);
      final user = await ref.read(currentUserModelProvider.future);
      final isAdmin = demoUser?.isAdmin == true ||
          user?.isAdmin == true ||
          email.toLowerCase().contains('admin');
      if (mounted) {
        context.go(isAdmin ? '/admin' : '/home');
      }
    } else {
      final msg =
          ref.read(authNotifierProvider.notifier).errorMessage ??
          'Sign in failed.';
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
      const SnackBar(
        content: Text('Password reset email sent. Check your inbox.'),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.huge),
              // Brand mark
              Center(child: _mark(theme)),
              const SizedBox(height: AppSpacing.xxxl),
              Text(
                'Welcome back',
                style: textTheme.displayLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Sign in to continue your journey',
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Email', theme),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'your@email.com',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          size: 20,
                        ),
                      ),
                      validator: (v) => v == null || !v.contains('@')
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _label('Password', theme),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) => v != null && v.length >= 6
                          ? null
                          : 'Min 6 characters',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (v) => setState(() => _rememberMe = v ?? true),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        GestureDetector(
                          onTap: () => setState(() => _rememberMe = !_rememberMe),
                          child: Text(
                            'Remember me',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _forgotPassword,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot password?',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_hasSavedCredentials) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(Icons.lock_clock_outlined, size: 14, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Saved account ready',
                            style: textTheme.labelSmall?.copyWith(color: colorScheme.primary),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: _clearSavedCredentials,
                            child: Text(
                              'Clear saved',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.error,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _login,
                        child: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : const Text('Sign In'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _dividerRow(
                theme,
                text: 'or test app without backend',
              ),
              const SizedBox(height: AppSpacing.xl),
              // Demo Test buttons
              Row(
                children: [
                  Expanded(
                    child: _socialBtn(
                      Icons.person_outline_rounded,
                      'Demo Member',
                      () async {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signInAsDemo(isAdmin: false);
                        if (context.mounted) context.go('/home');
                      },
                      theme,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _socialBtn(
                      Icons.admin_panel_settings_outlined,
                      'Demo Admin',
                      () async {
                        await ref
                            .read(authNotifierProvider.notifier)
                            .signInAsDemo(isAdmin: true);
                        if (context.mounted) context.go('/admin');
                      },
                      theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/register'),
                    child: Text(
                      'Sign Up',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mark(ThemeData theme) => Container(
    width: 72,
    height: 72,
    decoration: BoxDecoration(
      color: theme.colorScheme.primary,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
    ),
    child: Center(
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: Center(
          child: Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _label(String t, ThemeData theme) => Text(
    t,
    style: theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurface,
    ),
  );

  Widget _dividerRow(ThemeData theme, {String text = 'or continue with'}) => Row(
    children: [
      Expanded(
        child: Divider(),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      Expanded(
        child: Divider(),
      ),
    ],
  );

  Widget _socialBtn(
    IconData icon,
    String label,
    VoidCallback onTap,
    ThemeData theme,
  ) => FilledButton.tonalIcon(
    onPressed: onTap,
    icon: Icon(icon, size: 20),
    label: Text(label),
  );
}
