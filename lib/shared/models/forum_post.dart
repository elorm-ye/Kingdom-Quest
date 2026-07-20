/// Represents an anonymous forum post (privacy-preserving)
class ForumPost {
  final String id;
  final String? churchId;
  final String title;
  final String content;
  final String
  displayName; // "Anonymous Member" / "Anonymous Sister" / "Anonymous Brother"
  final int likeCount;
  final int commentCount;
  final int voteScore;
  final bool isLikedByUser;
  final bool isReported;
  final DateTime createdAt;

  const ForumPost({
    required this.id,
    this.churchId,
    required this.title,
    required this.content,
    required this.displayName,
    this.likeCount = 0,
    this.commentCount = 0,
    this.voteScore = 0,
    this.isLikedByUser = false,
    this.isReported = false,
    required this.createdAt,
  });
}

/// Anonymous comment on a forum post
class ForumComment {
  final String id;
  final String postId;
  final String content;
  final String displayName;
  final int likeCount;
  final bool isLikedByUser;
  final DateTime createdAt;
  final List<ForumComment> replies;

  const ForumComment({
    required this.id,
    required this.postId,
    required this.content,
    required this.displayName,
    this.likeCount = 0,
    this.isLikedByUser = false,
    required this.createdAt,
    this.replies = const [],
  });
}
