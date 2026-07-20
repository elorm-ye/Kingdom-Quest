import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase/supabase_config.dart';

/// Handles file uploads to Supabase Storage.
class StorageService {
  StorageService(this._client);

  final SupabaseClient _client;

  /// Uploads a new avatar for [userId] and returns the public URL.
  /// The file is stored at `avatars/{userId}/avatar.{ext}`
  Future<String> uploadAvatar({
    required String userId,
    required File file,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final path = '$userId/avatar.$ext';

    await _client.storage
        .from(SupabaseConfig.avatarBucket)
        .upload(path, file, fileOptions: const FileOptions(upsert: true));

    return _client.storage.from(SupabaseConfig.avatarBucket).getPublicUrl(path);
  }

  /// Uploads inspiration media and returns the public URL.
  Future<String> uploadInspirationMedia({
    required String adminId,
    required File file,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final name = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final path = '$adminId/$name';

    await _client.storage
        .from(SupabaseConfig.inspirationBucket)
        .upload(path, file, fileOptions: const FileOptions(upsert: false));

    return _client.storage
        .from(SupabaseConfig.inspirationBucket)
        .getPublicUrl(path);
  }

  /// Deletes an avatar file given its public URL (best-effort).
  Future<void> deleteAvatar(String publicUrl) async {
    try {
      final uri = Uri.parse(publicUrl);
      // Extract the path segment after the bucket name
      final segments = uri.pathSegments;
      final bucketIndex = segments.indexOf(SupabaseConfig.avatarBucket);
      if (bucketIndex == -1) return;
      final filePath = segments.sublist(bucketIndex + 1).join('/');
      await _client.storage.from(SupabaseConfig.avatarBucket).remove([
        filePath,
      ]);
    } catch (_) {
      // Non-critical; ignore failures
    }
  }
}
