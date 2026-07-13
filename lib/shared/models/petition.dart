/// Petition status
enum PetitionStatus {
  pending('Pending'),
  underReview('Under Review'),
  resolved('Resolved');

  final String label;
  const PetitionStatus(this.label);
}

/// Represents a petition (church-related concern)
class Petition {
  final String id;
  final String? userId;
  final String? churchId;
  final String subject;
  final String description;
  final bool isAnonymous;
  final PetitionStatus status;
  final String? anonymousDisplayName;
  final String? submitterName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Petition({
    required this.id,
    this.userId,
    this.churchId,
    required this.subject,
    required this.description,
    this.isAnonymous = false,
    this.status = PetitionStatus.pending,
    this.anonymousDisplayName,
    this.submitterName,
    required this.createdAt,
    this.updatedAt,
  });
}
