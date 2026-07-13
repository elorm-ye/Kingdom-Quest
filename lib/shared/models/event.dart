/// Represents a church event
class ChurchEvent {
  final String id;
  final String? churchId;
  final String title;
  final String description;
  final String? location;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isRecurring;
  final String? recurringPattern;
  final String? imageUrl;
  final String createdBy;
  final int registrationCount;
  final bool isRegistered;
  final DateTime createdAt;

  const ChurchEvent({
    required this.id,
    this.churchId,
    required this.title,
    required this.description,
    this.location,
    required this.startTime,
    this.endTime,
    this.isRecurring = false,
    this.recurringPattern,
    this.imageUrl,
    required this.createdBy,
    this.registrationCount = 0,
    this.isRegistered = false,
    required this.createdAt,
  });
}

/// Church announcement
class Announcement {
  final String id;
  final String? churchId;
  final String adminId;
  final String adminName;
  final String title;
  final String content;
  final List<String> mediaUrls;
  final bool isPinned;
  final DateTime createdAt;

  const Announcement({
    required this.id,
    this.churchId,
    required this.adminId,
    required this.adminName,
    required this.title,
    required this.content,
    this.mediaUrls = const [],
    this.isPinned = false,
    required this.createdAt,
  });
}

/// App notification
class AppNotification {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });
}
