import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../models/models.dart';
import '../../core/supabase/supabase_config.dart';

/// Supabase-backed data service that replaces MockDataService.
/// All methods throw [PostgrestException] or [StorageException] on failure
/// — callers should wrap calls in try/catch.
class SupabaseDataService {
  SupabaseDataService(this._client);

  final SupabaseClient _client;

  // ─────────────────────────────────────────────────────────────────────────
  // BIBLE VERSE  (still local — no DB table needed for this)
  // ─────────────────────────────────────────────────────────────────────────

  static const List<Map<String, String>> _bibleVerses = [
    {'text': '"Seek first his kingdom, and all these things will be given to you."', 'reference': 'Matthew 6:33'},
    {'text': '"For I know the plans I have for you, declares the Lord, plans to prosper you."', 'reference': 'Jeremiah 29:11'},
    {'text': '"I can do all things through Christ who strengthens me."', 'reference': 'Philippians 4:13'},
    {'text': '"The Lord is my shepherd; I shall not want."', 'reference': 'Psalm 23:1'},
    {'text': '"Trust in the Lord with all your heart and lean not on your own understanding."', 'reference': 'Proverbs 3:5'},
    {'text': '"Be strong and courageous. Do not be afraid; for the Lord your God will be with you."', 'reference': 'Joshua 1:9'},
    {'text': '"Cast all your anxiety on him because he cares for you."', 'reference': '1 Peter 5:7'},
    {'text': '"The Lord is close to the brokenhearted and saves those who are crushed in spirit."', 'reference': 'Psalm 34:18'},
  ];

  Map<String, String> getDailyVerse() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return _bibleVerses[dayOfYear % _bibleVerses.length];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PRAYER REQUESTS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<PrayerRequest>> fetchPrayerRequests({String? churchId}) async {
    var query = _client
        .from('prayer_requests')
        .select('*, prayer_responses(*)');

    if (churchId != null) {
      final data = await query
          .eq('church_id', churchId)
          .order('created_at', ascending: false);
      return (data as List).map((m) => _prayerRequestFromMap(m)).toList();
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List).map((m) => _prayerRequestFromMap(m)).toList();
  }

  Future<void> submitPrayerRequest({
    required String title,
    required String description,
    required String category,
    required bool isAnonymous,
    required String displayName,
    String? churchId,
  }) async {
    final user = _client.auth.currentUser;
    await _client.from('prayer_requests').insert({
      'user_id': isAnonymous ? null : user?.id,
      'church_id': churchId ?? SupabaseConfig.defaultChurchId,
      'title': title,
      'description': description,
      'category': category,
      'is_anonymous': isAnonymous,
      'display_name': displayName,
    });
  }

  Future<void> replyToPrayerRequest({
    required String prayerRequestId,
    required String message,
  }) async {
    final user = _client.auth.currentUser!;
    await _client.from('prayer_responses').insert({
      'prayer_request_id': prayerRequestId,
      'admin_id': user.id,
      'message': message,
    });
    // Bump status to 'praying'
    await _client
        .from('prayer_requests')
        .update({'status': 'praying'})
        .eq('id', prayerRequestId);
  }

  Future<void> markPrayerAnswered(String prayerRequestId) async {
    await _client
        .from('prayer_requests')
        .update({'status': 'answered'})
        .eq('id', prayerRequestId);
  }

  Future<void> incrementPrayerCount(String prayerRequestId) async {
    await _client.rpc('increment_prayer_count', params: {'request_id': prayerRequestId});
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PETITIONS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<Petition>> fetchPetitions({String? churchId}) async {
    if (churchId != null) {
      final data = await _client
          .from('petitions')
          .select()
          .eq('church_id', churchId)
          .order('created_at', ascending: false);
      return (data as List).map((m) => _petitionFromMap(m)).toList();
    }
    final data = await _client
        .from('petitions')
        .select()
        .order('created_at', ascending: false);
    return (data as List).map((m) => _petitionFromMap(m)).toList();
  }

  Future<void> submitPetition({
    required String subject,
    required String description,
    required bool isAnonymous,
    required String displayName,
    String? churchId,
  }) async {
    final user = _client.auth.currentUser;
    await _client.from('petitions').insert({
      'user_id': isAnonymous ? null : user?.id,
      'church_id': churchId ?? SupabaseConfig.defaultChurchId,
      'subject': subject,
      'description': description,
      'is_anonymous': isAnonymous,
      'display_name': displayName,
    });
  }

  Future<void> updatePetitionStatus({
    required String petitionId,
    required String status,
  }) async {
    await _client
        .from('petitions')
        .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', petitionId);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ADVICE
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<AdviceRequest>> fetchAdviceRequests({String? churchId}) async {
    if (churchId != null) {
      final data = await _client
          .from('advice_requests')
          .select('*, advice_responses(*)')
          .eq('church_id', churchId)
          .order('created_at', ascending: false);
      return (data as List).map((m) => _adviceRequestFromMap(m)).toList();
    }
    final data = await _client
        .from('advice_requests')
        .select('*, advice_responses(*)')
        .order('created_at', ascending: false);
    return (data as List).map((m) => _adviceRequestFromMap(m)).toList();
  }

  Future<void> submitAdviceRequest({
    required String title,
    required String description,
    required bool isAnonymous,
    required String displayName,
    String? churchId,
  }) async {
    final user = _client.auth.currentUser;
    await _client.from('advice_requests').insert({
      'user_id': isAnonymous ? null : user?.id,
      'church_id': churchId ?? SupabaseConfig.defaultChurchId,
      'title': title,
      'description': description,
      'is_anonymous': isAnonymous,
      'display_name': displayName,
    });
  }

  Future<void> replyToAdviceRequest({
    required String adviceRequestId,
    required String message,
    required List<String> bibleReferences,
  }) async {
    final user = _client.auth.currentUser!;
    await _client.from('advice_responses').insert({
      'advice_request_id': adviceRequestId,
      'admin_id': user.id,
      'message': message,
      'bible_references': bibleReferences,
    });
    await _client
        .from('advice_requests')
        .update({'status': 'in_progress'})
        .eq('id', adviceRequestId);
  }

  Future<void> closeAdviceRequest(String adviceRequestId) async {
    await _client
        .from('advice_requests')
        .update({'status': 'completed'})
        .eq('id', adviceRequestId);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // INSPIRATIONS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<Inspiration>> fetchInspirations({String? churchId}) async {
    final userId = _client.auth.currentUser?.id;

    final List<dynamic> data;
    if (churchId != null) {
      data = await _client
          .from('inspirations')
          .select('*, inspiration_reactions(user_id)')
          .eq('church_id', churchId)
          .order('published_at', ascending: false);
    } else {
      data = await _client
          .from('inspirations')
          .select('*, inspiration_reactions(user_id)')
          .order('published_at', ascending: false);
    }

    return data.map((m) {
      final reactions = m['inspiration_reactions'] as List? ?? [];
      final liked = reactions.any((r) => r['user_id'] == userId);
      return _inspirationFromMap(m, liked);
    }).toList();
  }

  Future<void> publishInspiration({
    required String title,
    required String content,
    required String type,
    String? bibleReference,
    String? mediaUrl,
    String? churchId,
  }) async {
    final user = _client.auth.currentUser!;
    await _client.from('inspirations').insert({
      'admin_id': user.id,
      'church_id': churchId ?? SupabaseConfig.defaultChurchId,
      'title': title,
      'content': content,
      'type': type,
      'bible_reference': bibleReference,
      'media_url': mediaUrl,
      'published_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> toggleInspirationLike({
    required String inspirationId,
    required bool currentlyLiked,
  }) async {
    final userId = _client.auth.currentUser!.id;
    if (currentlyLiked) {
      await _client
          .from('inspiration_reactions')
          .delete()
          .eq('inspiration_id', inspirationId)
          .eq('user_id', userId);
      await _client.rpc('decrement_inspiration_likes', params: {'insp_id': inspirationId});
    } else {
      await _client.from('inspiration_reactions').insert({
        'inspiration_id': inspirationId,
        'user_id': userId,
        'reaction_type': 'like',
      });
      await _client.rpc('increment_inspiration_likes', params: {'insp_id': inspirationId});
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FORUM POSTS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<ForumPost>> fetchForumPosts({String? churchId}) async {
    final List<dynamic> data;
    if (churchId != null) {
      data = await _client
          .from('forum_posts')
          .select()
          .eq('is_removed', false)
          .eq('church_id', churchId)
          .order('vote_score', ascending: false);
    } else {
      data = await _client
          .from('forum_posts')
          .select()
          .eq('is_removed', false)
          .order('vote_score', ascending: false);
    }
    return data.map((m) => _forumPostFromMap(m)).toList();
  }

  Future<List<ForumPost>> fetchReportedPosts() async {
    final data = await _client
        .from('forum_posts')
        .select('*, forum_reports(id)')
        .eq('is_removed', false)
        .order('created_at', ascending: false);

    return (data as List)
        .where((m) => (m['forum_reports'] as List? ?? []).isNotEmpty)
        .map((m) => _forumPostFromMap(m))
        .toList();
  }

  Future<void> createForumPost({
    required String title,
    required String content,
    required String displayName,
    String? churchId,
  }) async {
    final userId = _client.auth.currentUser!.id;
    final token = _generateAnonymousToken(userId);

    await _client.from('forum_posts').insert({
      'anonymous_token': token,
      'church_id': churchId ?? SupabaseConfig.defaultChurchId,
      'title': title,
      'content': content,
      'display_name': displayName,
    });
  }

  Future<void> removeForumPost(String postId) async {
    await _client
        .from('forum_posts')
        .update({'is_removed': true})
        .eq('id', postId);
  }

  Future<void> dismissForumReport(String postId) async {
    await _client
        .from('forum_reports')
        .delete()
        .eq('post_id', postId);
  }

  Future<void> reportForumPost({required String postId, required String reason}) async {
    final userId = _client.auth.currentUser!.id;
    final token = _generateAnonymousToken(userId);
    await _client.from('forum_reports').insert({
      'post_id': postId,
      'reason': reason,
      'reporter_token': token,
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // EVENTS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<ChurchEvent>> fetchEvents({String? churchId}) async {
    final userId = _client.auth.currentUser?.id;

    final List<dynamic> data;
    if (churchId != null) {
      data = await _client
          .from('events')
          .select('*, event_registrations(user_id)')
          .eq('church_id', churchId)
          .order('start_time', ascending: true);
    } else {
      data = await _client
          .from('events')
          .select('*, event_registrations(user_id)')
          .order('start_time', ascending: true);
    }

    return data.map((m) {
      final regs = m['event_registrations'] as List? ?? [];
      final isRegistered = regs.any((r) => r['user_id'] == userId);
      return _eventFromMap(m, isRegistered);
    }).toList();
  }

  Future<void> createEvent({
    required String title,
    required String description,
    required String location,
    required DateTime startTime,
    required DateTime endTime,
    bool isRecurring = false,
    String? recurringPattern,
    String? churchId,
  }) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('events').insert({
      'church_id': churchId ?? SupabaseConfig.defaultChurchId,
      'title': title,
      'description': description,
      'location': location,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_recurring': isRecurring,
      'recurring_pattern': recurringPattern,
      'created_by': userId,
    });
  }

  Future<void> toggleEventRegistration({
    required String eventId,
    required bool currentlyRegistered,
  }) async {
    final userId = _client.auth.currentUser!.id;
    if (currentlyRegistered) {
      await _client
          .from('event_registrations')
          .delete()
          .eq('event_id', eventId)
          .eq('user_id', userId);
      await _client.rpc('decrement_event_registration', params: {'ev_id': eventId});
    } else {
      await _client.from('event_registrations').insert({
        'event_id': eventId,
        'user_id': userId,
      });
      await _client.rpc('increment_event_registration', params: {'ev_id': eventId});
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ANNOUNCEMENTS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<Announcement>> fetchAnnouncements({String? churchId}) async {
    final List<dynamic> data;
    if (churchId != null) {
      data = await _client
          .from('announcements')
          .select('*, profiles(display_name)')
          .eq('church_id', churchId)
          .order('is_pinned', ascending: false)
          .order('created_at', ascending: false);
    } else {
      data = await _client
          .from('announcements')
          .select('*, profiles(display_name)')
          .order('is_pinned', ascending: false)
          .order('created_at', ascending: false);
    }
    return data.map((m) => _announcementFromMap(m)).toList();
  }

  Future<void> createAnnouncement({
    required String title,
    required String content,
    bool isPinned = false,
    String? churchId,
  }) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('announcements').insert({
      'church_id': churchId ?? SupabaseConfig.defaultChurchId,
      'admin_id': userId,
      'title': title,
      'content': content,
      'is_pinned': isPinned,
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // NOTIFICATIONS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<AppNotification>> fetchNotifications() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List).map((m) => _notificationFromMap(m)).toList();
  }

  Future<void> markNotificationRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> markAllNotificationsRead() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ADMIN — Users
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<UserModel>> fetchAllUsers() async {
    final data = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);

    return (data as List).map((m) {
      return _profileFromMap(m, '');
    }).toList();
  }

  Future<void> toggleUserRole({
    required String userId,
    required bool makeAdmin,
  }) async {
    await _client
        .from('profiles')
        .update({'role': makeAdmin ? 'admin' : 'member'})
        .eq('id', userId);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // REALTIME STREAMS
  // ─────────────────────────────────────────────────────────────────────────

  /// Supabase realtime stream of forum_posts table changes.
  Stream<List<Map<String, dynamic>>> forumPostsStream() {
    return _client
        .from('forum_posts')
        .stream(primaryKey: ['id'])
        .eq('is_removed', false)
        .order('vote_score', ascending: false);
  }

  /// Supabase realtime stream of notifications for the current user.
  Stream<List<Map<String, dynamic>>> notificationsStream() {
    final userId = _client.auth.currentUser?.id ?? '';
    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ANONYMOUS TOKEN  (one-way, cannot be reversed)
  // ─────────────────────────────────────────────────────────────────────────

  /// Generates a SHA-256 hash used as the anonymous forum token.
  /// The salt is a constant stored server-side in Edge Functions;
  /// here we use a hardcoded app-level salt as a fallback.
  static String _generateAnonymousToken(String userId) {
    const salt = 'kq-forum-salt-2026';
    final bytes = utf8.encode('$userId:$salt');
    return sha256.convert(bytes).toString();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // MAPPING HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  static PrayerRequest _prayerRequestFromMap(Map<String, dynamic> m) {
    final responses = (m['prayer_responses'] as List? ?? []).map((r) {
      return PrayerResponse(
        id: r['id'],
        prayerRequestId: r['prayer_request_id'],
        adminId: r['admin_id'],
        adminName: r['admin_name'] ?? 'Admin',
        message: r['message'],
        createdAt: DateTime.parse(r['created_at']),
      );
    }).toList();

    final categoryStr = m['category'] as String? ?? 'other';
    final statusStr = m['status'] as String? ?? 'pending';

    return PrayerRequest(
      id: m['id'],
      userId: m['user_id'],
      churchId: m['church_id'],
      title: m['title'],
      description: m['description'],
      category: _parsePrayerCategory(categoryStr),
      isAnonymous: m['is_anonymous'] as bool? ?? false,
      submitterName: m['is_anonymous'] == false ? m['display_name'] as String? : null,
      anonymousDisplayName: m['is_anonymous'] == true ? m['display_name'] as String? : null,
      status: _parsePrayerStatus(statusStr),
      prayerCount: m['prayer_count'] as int? ?? 0,
      createdAt: DateTime.parse(m['created_at']),
      responses: responses,
    );
  }

  static Petition _petitionFromMap(Map<String, dynamic> m) {
    return Petition(
      id: m['id'],
      userId: m['user_id'],
      subject: m['subject'],
      description: m['description'],
      isAnonymous: m['is_anonymous'] as bool? ?? false,
      submitterName: m['is_anonymous'] == false ? m['display_name'] : null,
      anonymousDisplayName: m['is_anonymous'] == true ? m['display_name'] : null,
      status: _parsePetitionStatus(m['status'] as String? ?? 'pending'),
      createdAt: DateTime.parse(m['created_at']),
      updatedAt: m['updated_at'] != null ? DateTime.parse(m['updated_at']) : null,
    );
  }

  static AdviceRequest _adviceRequestFromMap(Map<String, dynamic> m) {
    final responses = (m['advice_responses'] as List? ?? []).map((r) {
      return AdviceResponse(
        id: r['id'],
        adviceRequestId: r['advice_request_id'],
        adminId: r['admin_id'],
        adminName: r['admin_name'] ?? 'Admin',
        message: r['message'],
        bibleReferences: List<String>.from(r['bible_references'] ?? []),
        createdAt: DateTime.parse(r['created_at']),
      );
    }).toList();

    return AdviceRequest(
      id: m['id'],
      userId: m['user_id'],
      title: m['title'],
      description: m['description'],
      isAnonymous: m['is_anonymous'] as bool? ?? false,
      anonymousDisplayName: m['is_anonymous'] == true ? m['display_name'] : null,
      status: _parseAdviceStatus(m['status'] as String? ?? 'pending'),
      createdAt: DateTime.parse(m['created_at']),
      responses: responses,
    );
  }

  static Inspiration _inspirationFromMap(Map<String, dynamic> m, bool isLiked) {
    final mediaUrl = m['media_url'] as String?;
    return Inspiration(
      id: m['id'],
      adminId: m['admin_id'],
      adminName: m['admin_name'] ?? 'Admin',
      title: m['title'],
      content: m['content'],
      type: _parseInspirationType(m['type'] as String? ?? 'motivation'),
      bibleReference: m['bible_reference'],
      mediaUrls: mediaUrl != null ? [mediaUrl] : const [],
      publishedAt: m['published_at'] != null ? DateTime.parse(m['published_at']) : null,
      likeCount: m['like_count'] as int? ?? 0,
      commentCount: m['comment_count'] as int? ?? 0,
      isLikedByUser: isLiked,
      createdAt: DateTime.parse(m['created_at']),
    );
  }

  static ForumPost _forumPostFromMap(Map<String, dynamic> m) {
    return ForumPost(
      id: m['id'],
      title: m['title'],
      content: m['content'],
      displayName: m['display_name'] as String? ?? 'Anonymous Member',
      likeCount: m['like_count'] as int? ?? 0,
      commentCount: m['comment_count'] as int? ?? 0,
      voteScore: m['vote_score'] as int? ?? 0,
      createdAt: DateTime.parse(m['created_at']),
    );
  }

  static ChurchEvent _eventFromMap(Map<String, dynamic> m, bool isRegistered) {
    return ChurchEvent(
      id: m['id'],
      title: m['title'],
      description: m['description'],
      location: m['location'],
      startTime: DateTime.parse(m['start_time']),
      endTime: DateTime.parse(m['end_time']),
      isRecurring: m['is_recurring'] as bool? ?? false,
      recurringPattern: m['recurring_pattern'],
      createdBy: m['created_by'],
      registrationCount: m['registration_count'] as int? ?? 0,
      isRegistered: isRegistered,
      createdAt: DateTime.parse(m['created_at']),
    );
  }

  static Announcement _announcementFromMap(Map<String, dynamic> m) {
    final profileData = m['profiles'] as Map<String, dynamic>?;
    return Announcement(
      id: m['id'],
      adminId: m['admin_id'],
      adminName: profileData?['display_name'] as String? ?? 'Admin',
      title: m['title'],
      content: m['content'],
      isPinned: m['is_pinned'] as bool? ?? false,
      createdAt: DateTime.parse(m['created_at']),
    );
  }

  static AppNotification _notificationFromMap(Map<String, dynamic> m) {
    return AppNotification(
      id: m['id'],
      userId: m['user_id'],
      type: m['type'],
      title: m['title'],
      body: m['body'],
      isRead: m['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(m['created_at']),
    );
  }

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

  // ── Enum parsers ─────────────────────────────────────────────────────────

  static PrayerCategory _parsePrayerCategory(String s) {
    return PrayerCategory.values.firstWhere(
      (e) => e.name == s,
      orElse: () => PrayerCategory.other,
    );
  }

  static PrayerStatus _parsePrayerStatus(String s) {
    return PrayerStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => PrayerStatus.pending,
    );
  }

  static PetitionStatus _parsePetitionStatus(String s) {
    const map = {
      'pending': PetitionStatus.pending,
      'under_review': PetitionStatus.underReview,
      'resolved': PetitionStatus.resolved,
    };
    return map[s] ?? PetitionStatus.pending;
  }

  static AdviceStatus _parseAdviceStatus(String s) {
    const map = {
      'pending': AdviceStatus.pending,
      'in_progress': AdviceStatus.inProgress,
      'completed': AdviceStatus.completed,
    };
    return map[s] ?? AdviceStatus.pending;
  }

  static InspirationType _parseInspirationType(String s) {
    return InspirationType.values.firstWhere(
      (e) => e.name == s,
      orElse: () => InspirationType.motivation,
    );
  }
}
