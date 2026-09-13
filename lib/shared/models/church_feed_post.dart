/// Represents a church feed post for Sunday services and church meetings.
class ChurchFeedPost {
  final String id;
  final String? churchId;
  final String title;
  final String caption;
  final List<String> imageUrls;
  final DateTime meetingDate;
  final String meetingType;
  final String authorName;
  final String? authorAvatarUrl;
  final int likesCount;
  final bool isLiked;
  final DateTime createdAt;

  const ChurchFeedPost({
    required this.id,
    this.churchId,
    required this.title,
    required this.caption,
    required this.imageUrls,
    required this.meetingDate,
    this.meetingType = 'Sunday Service',
    required this.authorName,
    this.authorAvatarUrl,
    this.likesCount = 0,
    this.isLiked = false,
    required this.createdAt,
  });

  ChurchFeedPost copyWith({
    String? id,
    String? churchId,
    String? title,
    String? caption,
    List<String>? imageUrls,
    DateTime? meetingDate,
    String? meetingType,
    String? authorName,
    String? authorAvatarUrl,
    int? likesCount,
    bool? isLiked,
    DateTime? createdAt,
  }) {
    return ChurchFeedPost(
      id: id ?? this.id,
      churchId: churchId ?? this.churchId,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      imageUrls: imageUrls ?? this.imageUrls,
      meetingDate: meetingDate ?? this.meetingDate,
      meetingType: meetingType ?? this.meetingType,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'church_id': churchId,
      'title': title,
      'caption': caption,
      'image_urls': imageUrls,
      'meeting_date': meetingDate.toIso8601String().split('T').first,
      'meeting_type': meetingType,
      'author_name': authorName,
      'author_avatar_url': authorAvatarUrl,
      'likes_count': likesCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ChurchFeedPost.fromMap(Map<String, dynamic> map, {bool isLiked = false}) {
    final rawImages = map['image_urls'];
    List<String> images = [];
    if (rawImages is List) {
      images = rawImages.map((e) => e.toString()).toList();
    } else if (rawImages is String && rawImages.isNotEmpty) {
      images = [rawImages];
    }

    return ChurchFeedPost(
      id: map['id']?.toString() ?? '',
      churchId: map['church_id']?.toString(),
      title: map['title']?.toString() ?? '',
      caption: map['caption']?.toString() ?? '',
      imageUrls: images,
      meetingDate: map['meeting_date'] != null
          ? DateTime.tryParse(map['meeting_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      meetingType: map['meeting_type']?.toString() ?? 'Sunday Service',
      authorName: map['author_name']?.toString() ?? 'Media Ministry',
      authorAvatarUrl: map['author_avatar_url']?.toString(),
      likesCount: (map['likes_count'] as num?)?.toInt() ?? 0,
      isLiked: isLiked,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
