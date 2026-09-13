/// Feature-level Riverpod providers that bind to SupabaseDataService.
/// Each module exposes:
///   - A [FutureProvider] for initial data fetch
///   - A [StateNotifierProvider] / [NotifierProvider] for mutations
///
/// Screens consume these providers instead of calling MockDataService directly.
library;

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/models.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/services/mock_data_service.dart';
import '../../../shared/services/bible_service.dart';
import '../../../shared/services/gamification_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PRAYER REQUESTS
// ─────────────────────────────────────────────────────────────────────────────

final prayerRequestsProvider = FutureProvider<List<PrayerRequest>>((ref) async {
  try {
    final profile = await ref.watch(currentUserModelProvider.future);
    return await ref
        .read(dataServiceProvider)
        .fetchPrayerRequests(churchId: profile?.churchId);
  } catch (_) {
    return MockDataService.prayerRequests;
  }
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
      final items = await ref
          .read(dataServiceProvider)
          .fetchPrayerRequests(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (_, __) {
      state = AsyncValue.data(MockDataService.prayerRequests);
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
    final catEnum = PrayerCategory.values.firstWhere(
      (c) => c.name.toLowerCase() == category.toLowerCase(),
      orElse: () => PrayerCategory.other,
    );
    final newMock = PrayerRequest(
      id: 'pr_${DateTime.now().millisecondsSinceEpoch}',
      userId: profile?.id ?? 'user_001',
      title: title,
      description: description,
      category: catEnum,
      isAnonymous: isAnonymous,
      submitterName: isAnonymous ? null : displayName,
      anonymousDisplayName: isAnonymous ? (profile?.anonymousName ?? 'Anonymous Member') : null,
      status: PrayerStatus.pending,
      createdAt: DateTime.now(),
    );
    MockDataService.addPrayerRequest(newMock);

    try {
      await ref
          .read(dataServiceProvider)
          .submitPrayerRequest(
            title: title,
            description: description,
            category: category,
            isAnonymous: isAnonymous,
            displayName: displayName,
            churchId: profile?.churchId,
          );
    } catch (_) {}
    await _reload();
  }

  Future<void> reply({
    required String prayerRequestId,
    required String message,
  }) async {
    await ref
        .read(dataServiceProvider)
        .replyToPrayerRequest(
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
      final items = await ref
          .read(dataServiceProvider)
          .fetchPetitions(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (_, __) {
      state = AsyncValue.data(MockDataService.petitions);
    }
  }

  Future<void> submit({
    required String subject,
    required String description,
    required bool isAnonymous,
    required String displayName,
  }) async {
    final profile = await ref.read(currentUserModelProvider.future);
    final newMock = Petition(
      id: 'pet_${DateTime.now().millisecondsSinceEpoch}',
      userId: profile?.id ?? 'user_001',
      subject: subject,
      description: description,
      isAnonymous: isAnonymous,
      submitterName: isAnonymous ? null : displayName,
      anonymousDisplayName: isAnonymous ? (profile?.anonymousName ?? 'Anonymous Member') : null,
      status: PetitionStatus.pending,
      createdAt: DateTime.now(),
    );
    MockDataService.addPetition(newMock);

    try {
      await ref
          .read(dataServiceProvider)
          .submitPetition(
            subject: subject,
            description: description,
            isAnonymous: isAnonymous,
            displayName: displayName,
            churchId: profile?.churchId,
          );
    } catch (_) {}
    await _reload();
  }

  Future<void> updateStatus({
    required String id,
    required String status,
  }) async {
    await ref
        .read(dataServiceProvider)
        .updatePetitionStatus(petitionId: id, status: status);
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
      final items = await ref
          .read(dataServiceProvider)
          .fetchAdviceRequests(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (_, __) {
      state = AsyncValue.data(MockDataService.adviceRequests);
    }
  }

  Future<void> submit({
    required String title,
    required String description,
    required bool isAnonymous,
    required String displayName,
  }) async {
    final profile = await ref.read(currentUserModelProvider.future);
    final newMock = AdviceRequest(
      id: 'adv_${DateTime.now().millisecondsSinceEpoch}',
      userId: profile?.id ?? 'user_001',
      title: title,
      description: description,
      isAnonymous: isAnonymous,
      submitterName: isAnonymous ? null : displayName,
      anonymousDisplayName: isAnonymous ? (profile?.anonymousName ?? 'Anonymous Member') : null,
      status: AdviceStatus.pending,
      createdAt: DateTime.now(),
    );
    MockDataService.addAdviceRequest(newMock);

    try {
      await ref
          .read(dataServiceProvider)
          .submitAdviceRequest(
            title: title,
            description: description,
            isAnonymous: isAnonymous,
            displayName: displayName,
            churchId: profile?.churchId,
          );
    } catch (_) {}
    await _reload();
  }

  Future<void> reply({
    required String adviceRequestId,
    required String message,
    required List<String> bibleReferences,
  }) async {
    await ref
        .read(dataServiceProvider)
        .replyToAdviceRequest(
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
      final items = await ref
          .read(dataServiceProvider)
          .fetchInspirations(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (_, __) {
      state = AsyncValue.data(MockDataService.inspirations);
    }
  }

  Future<void> toggleLike({
    required String inspirationId,
    required bool currentlyLiked,
  }) async {
    await ref
        .read(dataServiceProvider)
        .toggleInspirationLike(
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
    await ref
        .read(dataServiceProvider)
        .publishInspiration(
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
// SERMON NOTES
// ─────────────────────────────────────────────────────────────────────────────

class SermonNotesNotifier extends Notifier<AsyncValue<List<SermonNote>>> {
  @override
  AsyncValue<List<SermonNote>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    final profile = await ref.read(currentUserModelProvider.future);
    try {
      final items = await ref
          .read(dataServiceProvider)
          .fetchSermonNotes(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (_, __) {
      state = AsyncValue.data(MockDataService.sermonNotes);
    }
  }

  Future<void> publish({
    required String title,
    required String preacherName,
    required String scriptureReference,
    required String content,
    required DateTime sermonDate,
    String? imageUrl,
  }) async {
    final profile = await ref.read(currentUserModelProvider.future);
    await ref
        .read(dataServiceProvider)
        .publishSermonNote(
          title: title,
          preacherName: preacherName,
          scriptureReference: scriptureReference,
          content: content,
          sermonDate: sermonDate,
          imageUrl: imageUrl,
          churchId: profile?.churchId,
        );
    await _reload();
  }

  Future<void> update({
    required String id,
    required String title,
    required String preacherName,
    required String scriptureReference,
    required String content,
    required DateTime sermonDate,
    String? imageUrl,
  }) async {
    await ref
        .read(dataServiceProvider)
        .updateSermonNote(
          id: id,
          title: title,
          preacherName: preacherName,
          scriptureReference: scriptureReference,
          content: content,
          sermonDate: sermonDate,
          imageUrl: imageUrl,
        );
    await _reload();
  }

  Future<void> delete(String id) async {
    await ref.read(dataServiceProvider).deleteSermonNote(id);
    await _reload();
  }

  Future<void> refresh() => _reload();
}

final sermonNotesNotifierProvider =
    NotifierProvider<SermonNotesNotifier, AsyncValue<List<SermonNote>>>(
      SermonNotesNotifier.new,
    );

// ─────────────────────────────────────────────────────────────────────────────
// COMMUNITY FORUM — Realtime via Supabase stream
// ─────────────────────────────────────────────────────────────────────────────

final forumPostsStreamProvider = StreamProvider<List<ForumPost>>((ref) {
  final ds = ref.watch(dataServiceProvider);
  return ds.forumPostsStream().map((rows) {
    return rows
        .where((m) => m['is_removed'] != true)
        .map(
          (m) => ForumPost(
            id: m['id'],
            title: m['title'],
            content: m['content'],
            displayName: m['display_name'] as String? ?? 'Anonymous Member',
            likeCount: m['like_count'] as int? ?? 0,
            commentCount: m['comment_count'] as int? ?? 0,
            voteScore: m['vote_score'] as int? ?? 0,
            createdAt: DateTime.parse(m['created_at']),
          ),
        )
        .toList();
  }).handleError((_, __) {
    return MockDataService.forumPosts;
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
      await ref
          .read(dataServiceProvider)
          .createForumPost(
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

  Future<void> reportPost({
    required String postId,
    required String reason,
  }) async {
    await ref
        .read(dataServiceProvider)
        .reportForumPost(postId: postId, reason: reason);
  }
}

final forumNotifierProvider = NotifierProvider<ForumNotifier, AsyncValue<void>>(
  ForumNotifier.new,
);

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
      final items = await ref
          .read(dataServiceProvider)
          .fetchEvents(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (_, __) {
      state = AsyncValue.data(MockDataService.events);
    }
  }

  Future<void> toggleRegistration({
    required String eventId,
    required bool currentlyRegistered,
  }) async {
    MockDataService.toggleEventRegistration(eventId);
    try {
      await ref
          .read(dataServiceProvider)
          .toggleEventRegistration(
            eventId: eventId,
            currentlyRegistered: currentlyRegistered,
          );
    } catch (_) {}
    await _reload();
  }

  Future<void> addEvent(ChurchEvent event) async {
    MockDataService.addEvent(event);
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
      final items = await ref
          .read(dataServiceProvider)
          .fetchAnnouncements(churchId: profile?.churchId);
      state = AsyncValue.data(items);
    } catch (_, __) {
      state = AsyncValue.data(MockDataService.announcements);
    }
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    MockDataService.addAnnouncement(announcement);
    await _reload();
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

final notificationsStreamProvider = StreamProvider<List<AppNotification>>((
  ref,
) {
  final ds = ref.watch(dataServiceProvider);
  return ds.notificationsStream().map((rows) {
    return rows
        .map(
          (m) => AppNotification(
            id: m['id'],
            userId: m['user_id'],
            type: m['type'],
            title: m['title'],
            body: m['body'],
            isRead: m['is_read'] as bool? ?? false,
            createdAt: DateTime.parse(m['created_at']),
          ),
        )
        .toList();
  }).handleError((_, __) {
    return MockDataService.notifications;
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
    NotifierProvider<NotificationsNotifier, AsyncValue<void>>(
      NotificationsNotifier.new,
    );

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
    } catch (_) {
      state = AsyncValue.data([
        MockDataService.currentUser,
        MockDataService.adminUser,
      ]);
    }
  }

  Future<void> toggleRole({
    required String userId,
    required bool makeAdmin,
  }) async {
    await ref
        .read(dataServiceProvider)
        .toggleUserRole(userId: userId, makeAdmin: makeAdmin);
    await _reload();
  }

  Future<void> refresh() => _reload();
}

final adminUsersNotifierProvider =
    NotifierProvider<AdminUsersNotifier, AsyncValue<List<UserModel>>>(
      AdminUsersNotifier.new,
    );

// ─────────────────────────────────────────────────────────────────────────────
// CHURCH FEED POSTS (SUNDAY & MEETING MOMENTS)
// ─────────────────────────────────────────────────────────────────────────────

final feedPostsProvider = FutureProvider<List<ChurchFeedPost>>((ref) async {
  try {
    final profile = await ref.watch(currentUserModelProvider.future);
    return await ref
        .read(dataServiceProvider)
        .fetchFeedPosts(churchId: profile?.churchId);
  } catch (_) {
    return MockDataService.feedPosts;
  }
});

class FeedPostsNotifier extends Notifier<AsyncValue<List<ChurchFeedPost>>> {
  @override
  AsyncValue<List<ChurchFeedPost>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    final profile = await ref.read(currentUserModelProvider.future);
    try {
      final posts = await ref
          .read(dataServiceProvider)
          .fetchFeedPosts(churchId: profile?.churchId);
      state = AsyncValue.data(posts);
    } catch (_) {
      state = AsyncValue.data(List.from(MockDataService.feedPosts));
    }
  }

  Future<void> toggleLike(String postId) async {
    // Optimistic UI update
    final currentList = state.value ?? [];
    final updatedList = currentList.map((post) {
      if (post.id == postId) {
        final newLiked = !post.isLiked;
        final newCount = newLiked ? post.likesCount + 1 : (post.likesCount > 0 ? post.likesCount - 1 : 0);
        return post.copyWith(isLiked: newLiked, likesCount: newCount);
      }
      return post;
    }).toList();

    state = AsyncValue.data(updatedList);
    MockDataService.toggleFeedPostLike(postId);

    try {
      await ref.read(dataServiceProvider).toggleFeedPostLike(postId);
    } catch (_) {
      // Keep optimistic or reload
    }
  }

  Future<void> createPost({
    required String title,
    required String caption,
    required String meetingType,
    required DateTime meetingDate,
    required List<String> imageUrls,
    List<File>? localFiles,
  }) async {
    final profile = await ref.read(currentUserModelProvider.future);
    final uploadedUrls = <String>[...imageUrls];

    // Upload local files to Supabase Storage if present
    if (localFiles != null && localFiles.isNotEmpty) {
      for (final file in localFiles) {
        try {
          final url = await ref.read(storageServiceProvider).uploadFeedImage(
            adminId: profile?.id ?? 'admin_001',
            file: file,
          );
          uploadedUrls.add(url);
        } catch (_) {
          // If upload fails (e.g. offline/demo), store path as fallback
          uploadedUrls.add(file.path);
        }
      }
    }

    final newPost = ChurchFeedPost(
      id: 'feed_${DateTime.now().millisecondsSinceEpoch}',
      churchId: profile?.churchId ?? 'church_001',
      title: title,
      caption: caption,
      imageUrls: uploadedUrls,
      meetingDate: meetingDate,
      meetingType: meetingType,
      authorName: profile?.displayName ?? 'Media Ministry',
      authorAvatarUrl: profile?.avatarUrl,
      likesCount: 0,
      isLiked: false,
      createdAt: DateTime.now(),
    );

    MockDataService.addFeedPost(newPost);

    try {
      await ref.read(dataServiceProvider).createFeedPost(
        title: title,
        caption: caption,
        imageUrls: uploadedUrls,
        meetingDate: meetingDate,
        meetingType: meetingType,
        churchId: profile?.churchId,
        authorName: profile?.displayName ?? 'Media Ministry',
        authorAvatarUrl: profile?.avatarUrl,
      );
    } catch (_) {}

    await _reload();
  }

  Future<void> deletePost(String postId) async {
    final currentList = state.value ?? [];
    state = AsyncValue.data(currentList.where((p) => p.id != postId).toList());
    MockDataService.deleteFeedPost(postId);

    try {
      await ref.read(dataServiceProvider).deleteFeedPost(postId);
    } catch (_) {}

    await _reload();
  }

  Future<void> refresh() => _reload();
}

final feedPostsNotifierProvider =
    NotifierProvider<FeedPostsNotifier, AsyncValue<List<ChurchFeedPost>>>(
      FeedPostsNotifier.new,
    );

// ─────────────────────────────────────────────────────────────────────────────
// DAILY VERSE (local rotation)
// ─────────────────────────────────────────────────────────────────────────────

final dailyVerseProvider = Provider<Map<String, String>>((ref) {
  return ref.read(dataServiceProvider).getDailyVerse();
});

// ─────────────────────────────────────────────────────────────────────────────
// BIBLE READER & READING PLANS
// ─────────────────────────────────────────────────────────────────────────────

class BibleSelectedBookNotifier extends Notifier<BibleBook> {
  @override
  BibleBook build() {
    return BibleService.books.firstWhere(
      (b) => b.name == 'John',
      orElse: () => BibleService.books.first,
    );
  }

  @override
  set state(BibleBook book) => super.state = book;
}

final bibleSelectedBookProvider =
    NotifierProvider<BibleSelectedBookNotifier, BibleBook>(
  BibleSelectedBookNotifier.new,
);

class BibleSelectedChapterNotifier extends Notifier<int> {
  @override
  int build() => 1;

  @override
  set state(int chapter) => super.state = chapter;
}

final bibleSelectedChapterNumberProvider =
    NotifierProvider<BibleSelectedChapterNotifier, int>(
  BibleSelectedChapterNotifier.new,
);

class BibleFontSizeNotifier extends Notifier<double> {
  @override
  double build() => 17.0;

  @override
  set state(double size) => super.state = size;
}

final bibleFontSizeProvider =
    NotifierProvider<BibleFontSizeNotifier, double>(
  BibleFontSizeNotifier.new,
);

final bibleCurrentChapterProvider = Provider<BibleChapter>((ref) {
  final book = ref.watch(bibleSelectedBookProvider);
  final chapterNumber = ref.watch(bibleSelectedChapterNumberProvider);
  return BibleService.getChapter(book.name, chapterNumber);
});

class ReadingPlanProgressNotifier extends Notifier<Map<String, List<int>>> {
  @override
  Map<String, List<int>> build() {
    _loadAll();
    return {};
  }

  Future<void> _loadAll() async {
    final progressMap = <String, List<int>>{};
    for (final plan in BibleService.readingPlans) {
      final days = await BibleService.getCompletedDayNumbers(plan.id);
      progressMap[plan.id] = days;
    }
    state = progressMap;
  }

  Future<void> toggleDay({
    required String planId,
    required int dayNumber,
    required bool completed,
  }) async {
    await BibleService.toggleDayCompletion(planId, dayNumber, completed);
    final current = Map<String, List<int>>.from(state);
    final list = List<int>.from(current[planId] ?? []);
    if (completed) {
      if (!list.contains(dayNumber)) list.add(dayNumber);
    } else {
      list.remove(dayNumber);
    }
    current[planId] = list;
    state = current;

    if (completed) {
      // Award devotional quest & check if plan finished
      final plan = BibleService.readingPlans.firstWhere(
        (p) => p.id == planId,
        orElse: () => BibleService.readingPlans.first,
      );
      ref.read(gamificationNotifierProvider.notifier).recordDailyAction(
            devotional: true,
            bonusXp: 20,
          );
      if (list.length >= plan.days.length) {
        ref.read(gamificationNotifierProvider.notifier).incrementBadge('wisdom_seeker');
      }
    }
  }

  Future<void> refresh() => _loadAll();
}

final readingPlanProgressNotifierProvider =
    NotifierProvider<ReadingPlanProgressNotifier, Map<String, List<int>>>(
  ReadingPlanProgressNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// PERSONAL SERMON NOTES & JOURNAL
// ─────────────────────────────────────────────────────────────────────────────

class PersonalNotesNotifier extends Notifier<AsyncValue<List<PersonalNote>>> {
  @override
  AsyncValue<List<PersonalNote>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    try {
      state = AsyncValue.data(List.from(MockDataService.personalNotes));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addNote({
    required String title,
    required String content,
    List<String> scriptures = const [],
    String? linkedSermon,
    int colorIndex = 0,
  }) async {
    final newNote = PersonalNote(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      content: content,
      scriptureReferences: scriptures,
      linkedSermonTitle: linkedSermon,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      colorIndex: colorIndex,
    );

    MockDataService.addPersonalNote(newNote);
    await _reload();

    // Gamification progress for Berean Mindset
    ref.read(gamificationNotifierProvider.notifier).recordDailyAction(
          devotional: true,
          bonusXp: 15,
        );
    ref.read(gamificationNotifierProvider.notifier).incrementBadge('berean_mind');
  }

  Future<void> updateNote(PersonalNote note) async {
    MockDataService.updatePersonalNote(note.copyWith(updatedAt: DateTime.now()));
    await _reload();
  }

  Future<void> deleteNote(String id) async {
    MockDataService.deletePersonalNote(id);
    await _reload();
  }

  Future<void> refresh() => _reload();
}

final personalNotesNotifierProvider =
    NotifierProvider<PersonalNotesNotifier, AsyncValue<List<PersonalNote>>>(
  PersonalNotesNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// TESTIMONIES & PRAISE WALL
// ─────────────────────────────────────────────────────────────────────────────

class TestimoniesNotifier extends Notifier<AsyncValue<List<Testimony>>> {
  @override
  AsyncValue<List<Testimony>> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    try {
      state = AsyncValue.data(List.from(MockDataService.testimonies));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTestimony({
    required String title,
    required String story,
    required String authorName,
    required String category,
    bool isAnonymous = false,
    String? relatedPrayerId,
  }) async {
    final testimony = Testimony(
      id: 'testimony_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      story: story,
      authorName: isAnonymous ? 'Anonymous Disciple' : authorName,
      isAnonymous: isAnonymous,
      createdAt: DateTime.now(),
      category: category,
      relatedPrayerId: relatedPrayerId,
      amenCount: 1,
    );

    MockDataService.addTestimony(testimony);
    await _reload();

    ref.read(gamificationNotifierProvider.notifier).recordDailyAction(bonusXp: 25);
    ref.read(gamificationNotifierProvider.notifier).incrementBadge('living_testimony');
  }

  Future<void> react(String id, String reactionType) async {
    MockDataService.reactToTestimony(id, reactionType);
    await _reload();

    ref.read(gamificationNotifierProvider.notifier).recordDailyAction(bonusXp: 5);
    ref.read(gamificationNotifierProvider.notifier).incrementBadge('living_testimony');
  }

  Future<void> refresh() => _reload();
}

final testimoniesNotifierProvider =
    NotifierProvider<TestimoniesNotifier, AsyncValue<List<Testimony>>>(
  TestimoniesNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// GAMIFICATION & YOUTH ENGAGEMENT (STREAKS & BADGES)
// ─────────────────────────────────────────────────────────────────────────────

class GamificationState {
  final QuestStreak streak;
  final List<MilestoneBadge> badges;

  const GamificationState({
    required this.streak,
    required this.badges,
  });

  GamificationState copyWith({
    QuestStreak? streak,
    List<MilestoneBadge>? badges,
  }) {
    return GamificationState(
      streak: streak ?? this.streak,
      badges: badges ?? this.badges,
    );
  }
}

class GamificationNotifier extends Notifier<AsyncValue<GamificationState>> {
  @override
  AsyncValue<GamificationState> build() {
    _reload();
    return const AsyncValue.loading();
  }

  Future<void> _reload() async {
    try {
      final streak = await GamificationService.loadStreak();
      final badges = await GamificationService.loadBadges();
      state = AsyncValue.data(GamificationState(streak: streak, badges: badges));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> recordDailyAction({
    bool devotional = false,
    bool bibleReading = false,
    bool prayer = false,
    int bonusXp = 10,
  }) async {
    final updatedStreak = await GamificationService.recordDailyAction(
      devotional: devotional,
      bibleReading: bibleReading,
      prayer: prayer,
      bonusXp: bonusXp,
    );

    // Check streak badges
    if (updatedStreak.currentStreak >= 3) {
      await GamificationService.incrementBadgeProgress('fervent_spirit', 3);
    }

    final badges = await GamificationService.loadBadges();
    state = AsyncValue.data(GamificationState(streak: updatedStreak, badges: badges));
  }

  Future<void> incrementBadge(String badgeId, [int amount = 1]) async {
    final updatedBadges = await GamificationService.incrementBadgeProgress(badgeId, amount);
    final streak = await GamificationService.loadStreak();
    state = AsyncValue.data(GamificationState(streak: streak, badges: updatedBadges));
  }

  Future<void> submitTriviaScore({
    required String quizId,
    required int score,
    required int totalQuestions,
  }) async {
    final xpEarned = score * 15;
    await recordDailyAction(bibleReading: true, bonusXp: xpEarned);

    if (score == totalQuestions && totalQuestions > 0) {
      await incrementBadge('bible_scholar', 1);
    }
  }

  Future<void> refresh() => _reload();
}

final gamificationNotifierProvider =
    NotifierProvider<GamificationNotifier, AsyncValue<GamificationState>>(
  GamificationNotifier.new,
);

