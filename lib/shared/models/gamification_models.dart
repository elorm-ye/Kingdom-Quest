class QuestStreak {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActiveDate;
  final bool completedDevotionalToday;
  final bool completedBibleReadingToday;
  final bool completedPrayerToday;
  final int xpPoints;

  const QuestStreak({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    this.completedDevotionalToday = false,
    this.completedBibleReadingToday = false,
    this.completedPrayerToday = false,
    this.xpPoints = 0,
  });

  QuestStreak copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActiveDate,
    bool? completedDevotionalToday,
    bool? completedBibleReadingToday,
    bool? completedPrayerToday,
    int? xpPoints,
  }) {
    return QuestStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      completedDevotionalToday: completedDevotionalToday ?? this.completedDevotionalToday,
      completedBibleReadingToday: completedBibleReadingToday ?? this.completedBibleReadingToday,
      completedPrayerToday: completedPrayerToday ?? this.completedPrayerToday,
      xpPoints: xpPoints ?? this.xpPoints,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'lastActiveDate': lastActiveDate?.toIso8601String(),
    'completedDevotionalToday': completedDevotionalToday,
    'completedBibleReadingToday': completedBibleReadingToday,
    'completedPrayerToday': completedPrayerToday,
    'xpPoints': xpPoints,
  };

  factory QuestStreak.fromJson(Map<String, dynamic> json) => QuestStreak(
    currentStreak: json['currentStreak'] as int? ?? 0,
    longestStreak: json['longestStreak'] as int? ?? 0,
    lastActiveDate: json['lastActiveDate'] != null
        ? DateTime.tryParse(json['lastActiveDate'] as String)
        : null,
    completedDevotionalToday: json['completedDevotionalToday'] as bool? ?? false,
    completedBibleReadingToday: json['completedBibleReadingToday'] as bool? ?? false,
    completedPrayerToday: json['completedPrayerToday'] as bool? ?? false,
    xpPoints: json['xpPoints'] as int? ?? 0,
  );
}

class MilestoneBadge {
  final String id;
  final String name;
  final String description;
  final String iconEmoji;
  final String category; // 'Prayer', 'Scripture', 'Community', 'Devotion'
  final int progress;
  final int target;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const MilestoneBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconEmoji,
    required this.category,
    required this.progress,
    required this.target,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  MilestoneBadge copyWith({
    String? id,
    String? name,
    String? description,
    String? iconEmoji,
    String? category,
    int? progress,
    int? target,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return MilestoneBadge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      category: category ?? this.category,
      progress: progress ?? this.progress,
      target: target ?? this.target,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'iconEmoji': iconEmoji,
    'category': category,
    'progress': progress,
    'target': target,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };

  factory MilestoneBadge.fromJson(Map<String, dynamic> json) => MilestoneBadge(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    iconEmoji: json['iconEmoji'] as String? ?? '🏆',
    category: json['category'] as String? ?? 'General',
    progress: json['progress'] as int? ?? 0,
    target: json['target'] as int? ?? 1,
    isUnlocked: json['isUnlocked'] as bool? ?? false,
    unlockedAt: json['unlockedAt'] != null
        ? DateTime.tryParse(json['unlockedAt'] as String)
        : null,
  );
}

class TriviaQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String scriptureReference;

  const TriviaQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.scriptureReference,
  });
}

class TriviaQuiz {
  final String id;
  final String title;
  final String description;
  final String category;
  final int timePerQuestionSeconds;
  final List<TriviaQuestion> questions;

  const TriviaQuiz({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.timePerQuestionSeconds = 15,
    required this.questions,
  });

  String get subtitle => description;
}
