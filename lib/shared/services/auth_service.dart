import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/models/models.dart';

/// Low-level Supabase Auth operations.
/// Consumed by [AuthNotifier] in the feature layer.
class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  // ── Auth State ──────────────────────────────────────────────────────────

  /// Stream of auth state changes (sign-in, sign-out, token refresh, …)
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// The currently signed-in Supabase user, or null.
  User? get currentUser => _client.auth.currentUser;

  /// True if a user is currently signed in.
  bool get isSignedIn => currentUser != null;

  // ── Sign Up ──────────────────────────────────────────────────────────────

  /// Creates a new account and profile row.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
    required String gender,
  }) async {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'display_name': displayName,
        'gender': gender,
      },
    );
  }

  // ── Sign In ──────────────────────────────────────────────────────────────

  /// Signs in with email + password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ── Sign Out ─────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ── Password Reset ───────────────────────────────────────────────────────

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // ── Profile ──────────────────────────────────────────────────────────────

  /// Fetches the profile row for [userId].
  Future<UserModel?> fetchProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select('*, churches(id, name, theme_color)')
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    return _profileFromMap(data, currentUser!.email ?? '');
  }

  /// Updates the profile display_name, bio, and gender.
  Future<void> updateProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? gender,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['display_name'] = displayName;
    if (bio != null) updates['bio'] = bio;
    if (gender != null) updates['gender'] = gender;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await _client.from('profiles').update(updates).eq('id', userId);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static UserModel _profileFromMap(Map<String, dynamic> data, String email) {
    final roleStr = data['role'] as String? ?? 'member';
    final genderStr = data['gender'] as String? ?? 'preferNotToSay';

    return UserModel(
      id: data['id'] as String,
      email: email,
      displayName: data['display_name'] as String? ?? 'Member',
      avatarUrl: data['avatar_url'] as String?,
      bio: data['bio'] as String?,
      role: roleStr == 'admin' ? UserRole.admin : UserRole.member,
      churchId: data['church_id'] as String?,
      gender: genderStr == 'male'
          ? Gender.male
          : genderStr == 'female'
              ? Gender.female
              : Gender.preferNotToSay,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
