/// Supabase configuration constants.
/// These values come from your Supabase project dashboard:
/// Settings → API → Project URL & Project API Keys
///
/// ⚠️  REPLACE THE PLACEHOLDER VALUES BELOW WITH YOUR REAL CREDENTIALS
///     before running the app against the live backend.
library;

class SupabaseConfig {
  SupabaseConfig._();

  // ── Fill in your project values ──────────────────────────────────────────
  static const String supabaseUrl = 'https://your-project-ref.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
  // ─────────────────────────────────────────────────────────────────────────

  /// Storage bucket for user avatars
  static const String avatarBucket = 'avatars';

  /// Storage bucket for inspiration media (images / videos)
  static const String inspirationBucket = 'inspiration-media';

  /// Realtime channel names
  static const String forumChannel = 'forum-posts';
  static const String notificationsChannel = 'user-notifications';

  /// Default church ID used when a user hasn't joined a specific church
  static const String defaultChurchId = 'church_001';
}
