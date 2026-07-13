/// Prayer request categories
enum PrayerCategory {
  healing('Healing', '💚'),
  family('Family', '🏠'),
  financial('Financial', '💰'),
  education('Education', '📚'),
  spiritualGrowth('Spiritual Growth', '🌱'),
  thanksgiving('Thanksgiving', '🙏'),
  other('Other', '✨');

  final String label;
  final String icon;
  const PrayerCategory(this.label, this.icon);
}

/// Prayer request status
enum PrayerStatus {
  pending('Pending'),
  praying('Being Prayed For'),
  answered('Answered');

  final String label;
  const PrayerStatus(this.label);
}

/// Represents a prayer request submitted by a member
class PrayerRequest {
  final String id;
  final String? userId;
  final String? churchId;
  final String title;
  final String description;
  final PrayerCategory category;
  final bool isAnonymous;
  final PrayerStatus status;
  final String? anonymousDisplayName;
  final String? submitterName;
  final int prayerCount;
  final DateTime createdAt;
  final List<PrayerResponse> responses;

  const PrayerRequest({
    required this.id,
    this.userId,
    this.churchId,
    required this.title,
    required this.description,
    required this.category,
    this.isAnonymous = false,
    this.status = PrayerStatus.pending,
    this.anonymousDisplayName,
    this.submitterName,
    this.prayerCount = 0,
    required this.createdAt,
    this.responses = const [],
  });
}

/// Admin response to a prayer request
class PrayerResponse {
  final String id;
  final String prayerRequestId;
  final String adminId;
  final String adminName;
  final String message;
  final DateTime createdAt;

  const PrayerResponse({
    required this.id,
    required this.prayerRequestId,
    required this.adminId,
    required this.adminName,
    required this.message,
    required this.createdAt,
  });
}
