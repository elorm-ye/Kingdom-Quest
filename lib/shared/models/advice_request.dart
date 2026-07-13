/// Advice request status
enum AdviceStatus {
  pending('Pending'),
  inProgress('In Progress'),
  completed('Completed');

  final String label;
  const AdviceStatus(this.label);
}

/// Represents a spiritual advice request
class AdviceRequest {
  final String id;
  final String? userId;
  final String? churchId;
  final String title;
  final String description;
  final bool isAnonymous;
  final AdviceStatus status;
  final String? anonymousDisplayName;
  final String? submitterName;
  final DateTime createdAt;
  final List<AdviceResponse> responses;

  const AdviceRequest({
    required this.id,
    this.userId,
    this.churchId,
    required this.title,
    required this.description,
    this.isAnonymous = false,
    this.status = AdviceStatus.pending,
    this.anonymousDisplayName,
    this.submitterName,
    required this.createdAt,
    this.responses = const [],
  });
}

/// Admin response to advice request
class AdviceResponse {
  final String id;
  final String adviceRequestId;
  final String adminId;
  final String adminName;
  final String message;
  final List<String> bibleReferences;
  final DateTime createdAt;

  const AdviceResponse({
    required this.id,
    required this.adviceRequestId,
    required this.adminId,
    required this.adminName,
    required this.message,
    this.bibleReferences = const [],
    required this.createdAt,
  });
}
