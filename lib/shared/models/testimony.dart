class Testimony {
  final String id;
  final String title;
  final String story;
  final String authorName;
  final bool isAnonymous;
  final DateTime createdAt;
  final String category; // 'Healing', 'Provision', 'Academics', 'Faith', 'Family', 'Deliverance'
  final String? relatedPrayerId;
  final int amenCount;
  final int praiseCount;
  final int heartCount;
  final List<String> userReactions;

  const Testimony({
    required this.id,
    required this.title,
    required this.story,
    required this.authorName,
    this.isAnonymous = false,
    required this.createdAt,
    required this.category,
    this.relatedPrayerId,
    this.amenCount = 0,
    this.praiseCount = 0,
    this.heartCount = 0,
    this.userReactions = const [],
  });

  Testimony copyWith({
    String? id,
    String? title,
    String? story,
    String? authorName,
    bool? isAnonymous,
    DateTime? createdAt,
    String? category,
    String? relatedPrayerId,
    int? amenCount,
    int? praiseCount,
    int? heartCount,
    List<String>? userReactions,
  }) {
    return Testimony(
      id: id ?? this.id,
      title: title ?? this.title,
      story: story ?? this.story,
      authorName: authorName ?? this.authorName,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      relatedPrayerId: relatedPrayerId ?? this.relatedPrayerId,
      amenCount: amenCount ?? this.amenCount,
      praiseCount: praiseCount ?? this.praiseCount,
      heartCount: heartCount ?? this.heartCount,
      userReactions: userReactions ?? this.userReactions,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'story': story,
    'authorName': authorName,
    'isAnonymous': isAnonymous,
    'createdAt': createdAt.toIso8601String(),
    'category': category,
    'relatedPrayerId': relatedPrayerId,
    'amenCount': amenCount,
    'praiseCount': praiseCount,
    'heartCount': heartCount,
    'userReactions': userReactions,
  };

  factory Testimony.fromJson(Map<String, dynamic> json) => Testimony(
    id: json['id'] as String,
    title: json['title'] as String,
    story: json['story'] as String,
    authorName: json['authorName'] as String? ?? 'Member',
    isAnonymous: json['isAnonymous'] as bool? ?? false,
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    category: json['category'] as String? ?? 'Faith',
    relatedPrayerId: json['relatedPrayerId'] as String?,
    amenCount: json['amenCount'] as int? ?? 0,
    praiseCount: json['praiseCount'] as int? ?? 0,
    heartCount: json['heartCount'] as int? ?? 0,
    userReactions: (json['userReactions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
  );
}
