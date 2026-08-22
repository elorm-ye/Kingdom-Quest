/// Represents a sermon note published by an admin.
/// Mirrors the `sermon_notes` Supabase table.
class SermonNote {
  final String id;
  final String adminId;
  final String? churchId;
  final String title;
  final String preacherName;
  final String scriptureReference;
  final String content;
  final DateTime sermonDate;
  final String? imageUrl;
  final DateTime? publishedAt;
  final DateTime createdAt;

  const SermonNote({
    required this.id,
    required this.adminId,
    this.churchId,
    required this.title,
    required this.preacherName,
    required this.scriptureReference,
    required this.content,
    required this.sermonDate,
    this.imageUrl,
    this.publishedAt,
    required this.createdAt,
  });
}
