import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

class SubmitAdviceScreen extends ConsumerStatefulWidget {
  const SubmitAdviceScreen({super.key});
  @override
  ConsumerState<SubmitAdviceScreen> createState() => _SubmitAdviceScreenState();
}

class _SubmitAdviceScreenState extends ConsumerState<SubmitAdviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _anonymous = true;
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

    final currentUser = await ref.read(currentUserModelProvider.future);
    final displayName = currentUser?.displayName ?? 'Member';

    await ref.read(adviceNotifierProvider.notifier).submit(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      isAnonymous: _anonymous,
      displayName: displayName,
    );

    if (mounted) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your question has been submitted.')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text('Ask for Advice'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ask a question, request counseling, or seek biblical guidance.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _label('Question Title', textTheme, colorScheme),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  hintText: 'What would you like guidance on?',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: AppSpacing.xl),
              _label('Detailed Description', textTheme, colorScheme),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descCtrl,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Share more details so we can help...',
                  alignLabelWithHint: true,
                ),
                validator: (v) => v == null || v.isEmpty
                    ? 'Please describe your question'
                    : null,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ask anonymously',
                              style: textTheme.titleSmall,
                            ),
                            Text(
                              'Your identity is kept private',
                              style: textTheme.bodySmall,
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
                      : const Text('Submit Question'),
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t, TextTheme textTheme, ColorScheme colorScheme) => Text(
    t,
    style: textTheme.labelMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
      letterSpacing: 0.3,
    ),
  );
}
