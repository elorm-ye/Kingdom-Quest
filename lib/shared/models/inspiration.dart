/// Inspiration type
enum InspirationType {
  motivation('Daily Motivation'),
  devotional('Devotional'),
  verse('Bible Verse'),
  encouragement('Encouragement'),
  challenge('Weekly Challenge');

  final String label;
  const InspirationType(this.label);
}

/// Represents a daily inspiration post created by admin
class Inspiration {
  final String id;
  final String adminId;
  final String adminName;
  final String? churchId;
  final String title;
  final String content;
  final InspirationType type;
  final List<String> mediaUrls;
  final String? bibleReference;
  final DateTime? scheduledAt;
  final DateTime? publishedAt;
  final int likeCount;
  final int commentCount;
  final bool isLikedByUser;
  final DateTime createdAt;

  const Inspiration({
    required this.id,
    required this.adminId,
    required this.adminName,
    this.churchId,
    required this.title,
    required this.content,
    required this.type,
    this.mediaUrls = const [],
    this.bibleReference,
    this.scheduledAt,
    this.publishedAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLikedByUser = false,
    required this.createdAt,
  });
}

/// Comment on an inspiration post
class InspirationComment {
  final String id;
  final String inspirationId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String content;
  final DateTime createdAt;

  const InspirationComment({
    required this.id,
    required this.inspirationId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.content,
    required this.createdAt,
  });
}
