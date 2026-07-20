import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/models.dart';
import '../../../core/providers/app_providers.dart';

/// Manages profile update and avatar upload for the current user.
class ProfileNotifier extends Notifier<AsyncValue<UserModel?>> {
  @override
  AsyncValue<UserModel?> build() {
    _load();
    return const AsyncValue.loading();
  }

  Future<void> _load() async {
    try {
      final user = await ref.read(currentUserModelProvider.future);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? gender,
  }) async {
    final currentUser = ref.read(currentSupabaseUserProvider);
    if (currentUser == null) return;

    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).updateProfile(
            userId: currentUser.id,
            displayName: displayName,
            bio: bio,
            gender: gender,
          );
      await _load();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Uploads a new avatar image and updates the profile avatar_url.
  Future<void> uploadAvatar(File imageFile) async {
    final currentUser = ref.read(currentSupabaseUserProvider);
    if (currentUser == null) return;

    state = const AsyncValue.loading();
    try {
      final url = await ref.read(storageServiceProvider).uploadAvatar(
            userId: currentUser.id,
            file: imageFile,
          );
      await ref.read(authServiceProvider).updateProfile(
            userId: currentUser.id,
            avatarUrl: url,
          );
      await _load();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _load();
}

final profileNotifierProvider =
    NotifierProvider<ProfileNotifier, AsyncValue<UserModel?>>(ProfileNotifier.new);
