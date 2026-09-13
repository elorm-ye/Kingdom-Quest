class PersonalNote {
  final String id;
  final String title;
  final String content;
  final List<String> scriptureReferences;
  final String? linkedSermonTitle;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int colorIndex;

  const PersonalNote({
    required this.id,
    required this.title,
    required this.content,
    this.scriptureReferences = const [],
    this.linkedSermonTitle,
    required this.createdAt,
    required this.updatedAt,
    this.colorIndex = 0,
  });

  PersonalNote copyWith({
    String? id,
    String? title,
    String? content,
    List<String>? scriptureReferences,
    String? linkedSermonTitle,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? colorIndex,
  }) {
    return PersonalNote(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      scriptureReferences: scriptureReferences ?? this.scriptureReferences,
      linkedSermonTitle: linkedSermonTitle ?? this.linkedSermonTitle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'scriptureReferences': scriptureReferences,
    'linkedSermonTitle': linkedSermonTitle,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'colorIndex': colorIndex,
  };

  factory PersonalNote.fromJson(Map<String, dynamic> json) => PersonalNote(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    scriptureReferences: (json['scriptureReferences'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [],
    linkedSermonTitle: json['linkedSermonTitle'] as String?,
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    colorIndex: json['colorIndex'] as int? ?? 0,
  );
}
