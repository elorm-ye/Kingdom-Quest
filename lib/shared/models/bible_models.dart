class BibleBook {
  final String id;
  final String name;
  final String abbreviation;
  final String testament; // 'OT' or 'NT'
  final int chaptersCount;
  final String category; // 'Law', 'History', 'Poetry', 'Prophets', 'Gospels', 'Epistles', etc.

  const BibleBook({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.testament,
    required this.chaptersCount,
    required this.category,
  });
}

class BibleVerse {
  final int number;
  final String text;
  final String reference;

  const BibleVerse({
    required this.number,
    required this.text,
    required this.reference,
  });
}

class BibleChapter {
  final String bookName;
  final int chapterNumber;
  final List<BibleVerse> verses;

  const BibleChapter({
    required this.bookName,
    required this.chapterNumber,
    required this.verses,
  });
}

class PlanDay {
  final int dayNumber;
  final String title;
  final String scriptureRef;
  final String reflection;
  final String prayerPrompt;
  bool isCompleted;

  PlanDay({
    required this.dayNumber,
    required this.title,
    required this.scriptureRef,
    required this.reflection,
    required this.prayerPrompt,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'dayNumber': dayNumber,
    'title': title,
    'scriptureRef': scriptureRef,
    'reflection': reflection,
    'prayerPrompt': prayerPrompt,
    'isCompleted': isCompleted,
  };

  factory PlanDay.fromJson(Map<String, dynamic> json) => PlanDay(
    dayNumber: json['dayNumber'] as int,
    title: json['title'] as String,
    scriptureRef: json['scriptureRef'] as String,
    reflection: json['reflection'] as String,
    prayerPrompt: json['prayerPrompt'] as String? ?? '',
    isCompleted: json['isCompleted'] as bool? ?? false,
  );
}

class ReadingPlan {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String category;
  final int durationDays;
  final List<PlanDay> days;

  const ReadingPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.durationDays,
    required this.days,
  });

  int get completedDays => days.where((d) => d.isCompleted).length;
  double get progressPercentage =>
      durationDays == 0 ? 0.0 : (completedDays / durationDays).clamp(0.0, 1.0);
}
