import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/prayer_request.dart';

class SubmitPrayerScreen extends ConsumerStatefulWidget {
  const SubmitPrayerScreen({super.key});
  @override
  ConsumerState<SubmitPrayerScreen> createState() => _SubmitPrayerScreenState();
}

class _SubmitPrayerScreenState extends ConsumerState<SubmitPrayerScreen> {
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

    final currentUser = await ref.read(currentUserModelProvider.future);
    final displayName = currentUser?.displayName ?? 'Member';

    await ref.read(prayerRequestsNotifierProvider.notifier).submit(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      category: _category.name,
      isAnonymous: _anonymous,
      displayName: displayName,
    );

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
        title: const Text('Share a prayer'),
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
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              _label('Title', textTheme, colorScheme),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  hintText: 'Brief title for your prayer',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              _label('Description', textTheme, colorScheme),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descCtrl,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Share what you\'d like prayer for...',
                  alignLabelWithHint: true,
                ),
                validator: (v) => v == null || v.isEmpty
                    ? 'Please describe your prayer request'
                    : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              _label('Category', textTheme, colorScheme),
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
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                        border: selected 
                            ? null
                            : Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Text(
                        '${c.icon} ${c.label}',
                        style: textTheme.labelMedium?.copyWith(
                          color: selected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Anonymous toggle
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
                              'Send anonymously',
                              style: textTheme.titleSmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Your name stays hidden',
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
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Only ICGC's pastoral team can see this.",
                        style: textTheme.bodySmall,
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

  Widget _label(String t, TextTheme textTheme, ColorScheme colorScheme) => Text(
    t,
    style: textTheme.labelMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
      letterSpacing: 0.3,
    ),
  );
}
