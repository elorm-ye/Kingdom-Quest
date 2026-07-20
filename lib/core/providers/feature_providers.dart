/// Feature-level Riverpod providers that bind to SupabaseDataService.
/// Each module exposes:
///   - A [FutureProvider] for initial data fetch
///   - A [StateNotifierProvider] / [NotifierProvider] for mutations
///
/// Screens consume these providers instead of calling MockDataService directly.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/models.dart';
import '../../../core/providers/app_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PRAYER REQUESTS
// ─────────────────────────────────────────────────────────────────────────────

final prayerRequestsProvider = FutureProvider<List<PrayerRequest>>((ref) async {
  final profile = await ref.watch(currentUserModelProvider.future);
  return ref.read(dataServiceProvider).fetchPrayerRequests(churchId: profile?.churchId);
});

class PrayerRequestsNotifier extends Notifier<AsyncValue<List<PrayerRequest>>> {
  @override
  AsyncValue<List<PrayerRequest>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    final profile = await ref.read(currentUserModelProvider.future);
    try {
      final items = await ref.read(dataServiceProvider).fetchPrayerRequests(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> submit({
    required String title,
    required String description,
    required String category,
    required bool isAnonymous,
    required String displayName,
  }) async {
    final profile = await ref.read(currentUserModelProvider.future);
    await ref.read(dataServiceProvider).submitPrayerRequest(
          title: title,
          description: description,
          category: category,
          isAnonymous: isAnonymous,
          displayName: displayName,
          churchId: profile?.churchId,
        );
    await _reload();
  }

  Future<void> reply({required String prayerRequestId, required String message}) async {
    await ref.read(dataServiceProvider).replyToPrayerRequest(
          prayerRequestId: prayerRequestId,
          message: message,
        );
    await _reload();
  }

  Future<void> markAnswered(String id) async {
    await ref.read(dataServiceProvider).markPrayerAnswered(id);
    await _reload();
  }

  Future<void> refresh() => _reload();
}

final prayerRequestsNotifierProvider =
    NotifierProvider<PrayerRequestsNotifier, AsyncValue<List<PrayerRequest>>>(
  PrayerRequestsNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// PETITIONS
// ─────────────────────────────────────────────────────────────────────────────

class PetitionsNotifier extends Notifier<AsyncValue<List<Petition>>> {
  @override
  AsyncValue<List<Petition>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    final profile = await ref.read(currentUserModelProvider.future);
    try {
      final items = await ref.read(dataServiceProvider).fetchPetitions(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> submit({
    required String subject,
    required String description,
    required bool isAnonymous,
    required String displayName,
  }) async {
    final profile = await ref.read(currentUserModelProvider.future);
    await ref.read(dataServiceProvider).submitPetition(
          subject: subject,
          description: description,
          isAnonymous: isAnonymous,
          displayName: displayName,
          churchId: profile?.churchId,
        );
    await _reload();
  }

  Future<void> updateStatus({required String id, required String status}) async {
    await ref.read(dataServiceProvider).updatePetitionStatus(petitionId: id, status: status);
    await _reload();
  }

  Future<void> refresh() => _reload();
}

final petitionsNotifierProvider =
    NotifierProvider<PetitionsNotifier, AsyncValue<List<Petition>>>(
  PetitionsNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// ADVICE
// ─────────────────────────────────────────────────────────────────────────────

class AdviceNotifier extends Notifier<AsyncValue<List<AdviceRequest>>> {
  @override
  AsyncValue<List<AdviceRequest>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    final profile = await ref.read(currentUserModelProvider.future);
    try {
      final items = await ref.read(dataServiceProvider).fetchAdviceRequests(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> submit({
    required String title,
    required String description,
    required bool isAnonymous,
    required String displayName,
  }) async {
    final profile = await ref.read(currentUserModelProvider.future);
    await ref.read(dataServiceProvider).submitAdviceRequest(
          title: title,
          description: description,
          isAnonymous: isAnonymous,
          displayName: displayName,
          churchId: profile?.churchId,
        );
    await _reload();
  }

  Future<void> reply({
    required String adviceRequestId,
    required String message,
    required List<String> bibleReferences,
  }) async {
    await ref.read(dataServiceProvider).replyToAdviceRequest(
          adviceRequestId: adviceRequestId,
          message: message,
          bibleReferences: bibleReferences,
        );
    await _reload();
  }

  Future<void> close(String id) async {
    await ref.read(dataServiceProvider).closeAdviceRequest(id);
    await _reload();
  }

  Future<void> refresh() => _reload();
}

final adviceNotifierProvider =
    NotifierProvider<AdviceNotifier, AsyncValue<List<AdviceRequest>>>(
  AdviceNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// DAILY INSPIRATION
// ─────────────────────────────────────────────────────────────────────────────

class InspirationsNotifier extends Notifier<AsyncValue<List<Inspiration>>> {
  @override
  AsyncValue<List<Inspiration>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    final profile = await ref.read(currentUserModelProvider.future);
    try {
      final items = await ref.read(dataServiceProvider).fetchInspirations(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleLike({required String inspirationId, required bool currentlyLiked}) async {
    await ref.read(dataServiceProvider).toggleInspirationLike(
          inspirationId: inspirationId,
          currentlyLiked: currentlyLiked,
        );
    await _reload();
  }

  Future<void> publish({
    required String title,
    required String content,
    required String type,
    String? bibleReference,
    String? mediaUrl,
  }) async {
    final profile = await ref.read(currentUserModelProvider.future);
    await ref.read(dataServiceProvider).publishInspiration(
          title: title,
          content: content,
          type: type,
          bibleReference: bibleReference,
          mediaUrl: mediaUrl,
          churchId: profile?.churchId,
        );
    await _reload();
  }

  Future<void> refresh() => _reload();
}

final inspirationsNotifierProvider =
    NotifierProvider<InspirationsNotifier, AsyncValue<List<Inspiration>>>(
  InspirationsNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// COMMUNITY FORUM — Realtime via Supabase stream
// ─────────────────────────────────────────────────────────────────────────────

final forumPostsStreamProvider = StreamProvider<List<ForumPost>>((ref) {
  final ds = ref.watch(dataServiceProvider);
  return ds.forumPostsStream().map((rows) {
    return rows
        .where((m) => m['is_removed'] != true)
        .map((m) => ForumPost(
              id: m['id'],
              title: m['title'],
              content: m['content'],
              displayName: m['display_name'] as String? ?? 'Anonymous Member',
              likeCount: m['like_count'] as int? ?? 0,
              commentCount: m['comment_count'] as int? ?? 0,
              voteScore: m['vote_score'] as int? ?? 0,
              createdAt: DateTime.parse(m['created_at']),
            ))
        .toList();
  });
});

class ForumNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> createPost({
    required String title,
    required String content,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final profile = await ref.read(currentUserModelProvider.future);
      await ref.read(dataServiceProvider).createForumPost(
            title: title,
            content: content,
            displayName: displayName,
            churchId: profile?.churchId,
          );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removePost(String postId) async {
    await ref.read(dataServiceProvider).removeForumPost(postId);
  }

  Future<void> dismissReport(String postId) async {
    await ref.read(dataServiceProvider).dismissForumReport(postId);
  }

  Future<void> reportPost({required String postId, required String reason}) async {
    await ref.read(dataServiceProvider).reportForumPost(postId: postId, reason: reason);
  }
}

final forumNotifierProvider =
    NotifierProvider<ForumNotifier, AsyncValue<void>>(ForumNotifier.new);

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────────────────────────────────────

class EventsNotifier extends Notifier<AsyncValue<List<ChurchEvent>>> {
  @override
  AsyncValue<List<ChurchEvent>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    final profile = await ref.read(currentUserModelProvider.future);
    try {
      final items = await ref.read(dataServiceProvider).fetchEvents(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleRegistration({required String eventId, required bool currentlyRegistered}) async {
    await ref.read(dataServiceProvider).toggleEventRegistration(
          eventId: eventId,
          currentlyRegistered: currentlyRegistered,
        );
    await _reload();
  }

  Future<void> refresh() => _reload();
}

final eventsNotifierProvider =
    NotifierProvider<EventsNotifier, AsyncValue<List<ChurchEvent>>>(
  EventsNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// ANNOUNCEMENTS
// ─────────────────────────────────────────────────────────────────────────────

class AnnouncementsNotifier extends Notifier<AsyncValue<List<Announcement>>> {
  @override
  AsyncValue<List<Announcement>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    final profile = await ref.read(currentUserModelProvider.future);
    try {
      final items = await ref.read(dataServiceProvider).fetchAnnouncements(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _reload();
}

final announcementsNotifierProvider =
    NotifierProvider<AnnouncementsNotifier, AsyncValue<List<Announcement>>>(
  AnnouncementsNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// NOTIFICATIONS — Realtime via Supabase stream
// ─────────────────────────────────────────────────────────────────────────────

final notificationsStreamProvider = StreamProvider<List<AppNotification>>((ref) {
  final ds = ref.watch(dataServiceProvider);
  return ds.notificationsStream().map((rows) {
    return rows
        .map((m) => AppNotification(
              id: m['id'],
              userId: m['user_id'],
              type: m['type'],
              title: m['title'],
              body: m['body'],
              isRead: m['is_read'] as bool? ?? false,
              createdAt: DateTime.parse(m['created_at']),
            ))
        .toList();
  });
});

class NotificationsNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> markRead(String id) async {
    await ref.read(dataServiceProvider).markNotificationRead(id);
  }

  Future<void> markAllRead() async {
    await ref.read(dataServiceProvider).markAllNotificationsRead();
  }
}

final notificationsNotifierProvider =
    NotifierProvider<NotificationsNotifier, AsyncValue<void>>(NotificationsNotifier.new);

// ─────────────────────────────────────────────────────────────────────────────
// ADMIN — Users
// ─────────────────────────────────────────────────────────────────────────────

final adminUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.read(dataServiceProvider).fetchAllUsers();
});

class AdminUsersNotifier extends Notifier<AsyncValue<List<UserModel>>> {
  @override
  AsyncValue<List<UserModel>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    try {
      final users = await ref.read(dataServiceProvider).fetchAllUsers();
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleRole({required String userId, required bool makeAdmin}) async {
    await ref.read(dataServiceProvider).toggleUserRole(userId: userId, makeAdmin: makeAdmin);
    await _reload();
  }

  Future<void> refresh() => _reload();
}

final adminUsersNotifierProvider =
    NotifierProvider<AdminUsersNotifier, AsyncValue<List<UserModel>>>(
  AdminUsersNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// DAILY VERSE (local rotation)
// ─────────────────────────────────────────────────────────────────────────────

final dailyVerseProvider = Provider<Map<String, String>>((ref) {
  return ref.read(dataServiceProvider).getDailyVerse();
});
