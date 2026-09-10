import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../shared/services/mock_data_service.dart';

void showEditProfileSheet(BuildContext context, UserModel user, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSection)),
    ),
    builder: (ctx) => _EditProfileSheetContent(user: user, rootRef: ref),
  );
}

class _EditProfileSheetContent extends StatefulWidget {
  final UserModel user;
  final WidgetRef rootRef;
  const _EditProfileSheetContent({required this.user, required this.rootRef});

  @override
  State<_EditProfileSheetContent> createState() => _EditProfileSheetContentState();
}

class _EditProfileSheetContentState extends State<_EditProfileSheetContent> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _phoneCtrl;
  late Gender _selectedGender;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.displayName);
    _bioCtrl = TextEditingController(text: widget.user.bio ?? '');
    _phoneCtrl = TextEditingController(text: widget.user.phone ?? '');
    _selectedGender = widget.user.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Display name cannot be empty.')),
      );
      return;
    }

    setState(() => _saving = true);

    final updated = widget.user.copyWith(
      displayName: name,
      bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      gender: _selectedGender,
    );

    widget.rootRef.read(demoUserModelProvider.notifier).set(updated);
    if (widget.user.isAdmin) {
      MockDataService.adminUser = updated;
    } else {
      MockDataService.currentUser = updated;
    }

    try {
      await widget.rootRef.read(authServiceProvider).updateProfile(
        userId: widget.user.id,
        displayName: name,
        bio: _bioCtrl.text.trim(),
        gender: _selectedGender.name,
      );
    } catch (_) {}

    if (mounted) {
      setState(() => _saving = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Profile',
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Display Name
            Text('Display Name', style: textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Your name',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Phone
            Text('Phone Number', style: textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '+233 XX XXX XXXX',
                prefixIcon: Icon(Icons.phone_outlined, size: 20),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Gender
            Text('Gender', style: textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            SegmentedButton<Gender>(
              segments: const [
                ButtonSegment(value: Gender.male, label: Text('Male')),
                ButtonSegment(value: Gender.female, label: Text('Female')),
                ButtonSegment(value: Gender.preferNotToSay, label: Text('Other')),
              ],
              selected: {_selectedGender},
              onSelectionChanged: (set) {
                if (set.isNotEmpty) setState(() => _selectedGender = set.first);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            // Bio
            Text('Bio / About You', style: textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _bioCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Share a bit about yourself...',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
