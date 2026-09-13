import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gamification_models.dart';

class GamificationService {
  static const String _streakKey = 'user_quest_streak_v1';
  static const String _badgesKey = 'user_milestone_badges_v1';

  // ─────────────────────────────────────────────────────────────────────────
  // DEFAULT MILESTONE BADGES
  // ─────────────────────────────────────────────────────────────────────────
  static final List<MilestoneBadge> defaultBadges = [
    const MilestoneBadge(
      id: 'first_steps',
      name: 'First Steps',
      description: 'Begin your spiritual journey on Kingdom Quest',
      iconEmoji: '🌱',
      category: 'General',
      progress: 1,
      target: 1,
      isUnlocked: true,
    ),
    const MilestoneBadge(
      id: 'shield_of_faith',
      name: 'Shield of Faith',
      description: 'Lift a brother or sister in prayer or share a prayer request',
      iconEmoji: '🛡️',
      category: 'Prayer',
      progress: 0,
      target: 1,
      isUnlocked: false,
    ),
    const MilestoneBadge(
      id: 'fervent_spirit',
      name: 'Fervent in Spirit',
      description: 'Reach a 3-day continuous devotional streak',
      iconEmoji: '🔥',
      category: 'Devotion',
      progress: 0,
      target: 3,
      isUnlocked: false,
    ),
    const MilestoneBadge(
      id: 'berean_mind',
      name: 'Berean Mindset',
      description: 'Read 5 chapters in the Bible Reader',
      iconEmoji: '📖',
      category: 'Scripture',
      progress: 0,
      target: 5,
      isUnlocked: false,
    ),
    const MilestoneBadge(
      id: 'living_testimony',
      name: 'Living Testimony',
      description: 'Celebrate God\'s goodness by sharing or reacting to a testimony',
      iconEmoji: '🙌',
      category: 'Community',
      progress: 0,
      target: 1,
      isUnlocked: false,
    ),
    const MilestoneBadge(
      id: 'wisdom_seeker',
      name: 'Wisdom Seeker',
      description: 'Complete all days in any reading plan',
      iconEmoji: '💡',
      category: 'Scripture',
      progress: 0,
      target: 1,
      isUnlocked: false,
    ),
    const MilestoneBadge(
      id: 'prayer_warrior',
      name: 'Prayer Warrior',
      description: 'Pray for 10 prayer requests on the prayer wall',
      iconEmoji: '⚔️',
      category: 'Prayer',
      progress: 0,
      target: 10,
      isUnlocked: false,
    ),
    const MilestoneBadge(
      id: 'bible_scholar',
      name: 'Bible Scholar',
      description: 'Score 100% on any weekly Bible Trivia quiz',
      iconEmoji: '👑',
      category: 'Scripture',
      progress: 0,
      target: 1,
      isUnlocked: false,
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // STREAK MANAGEMENT WITH LOCAL PERSISTENCE
  // ─────────────────────────────────────────────────────────────────────────
  static Future<QuestStreak> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_streakKey);
    if (raw == null) {
      // First time user
      final initial = QuestStreak(
        currentStreak: 1,
        longestStreak: 1,
        lastActiveDate: DateTime.now(),
        completedDevotionalToday: true,
        xpPoints: 50,
      );
      await saveStreak(initial);
      return initial;
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final streak = QuestStreak.fromJson(json);

      // Check date delta
      final now = DateTime.now();
      final lastDate = streak.lastActiveDate;
      if (lastDate == null) return streak;

      final diffDays = DateTime(now.year, now.month, now.day)
          .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
          .inDays;

      if (diffDays == 0) {
        // Same day
        return streak;
      } else if (diffDays == 1) {
        // Yesterday was active, today reset daily task checks
        final updated = streak.copyWith(
          completedDevotionalToday: false,
          completedBibleReadingToday: false,
          completedPrayerToday: false,
        );
        await saveStreak(updated);
        return updated;
      } else {
        // Missed more than 1 day: streak resets to 1
        final resetStreak = streak.copyWith(
          currentStreak: 1,
          completedDevotionalToday: false,
          completedBibleReadingToday: false,
          completedPrayerToday: false,
        );
        await saveStreak(resetStreak);
        return resetStreak;
      }
    } catch (_) {
      return const QuestStreak(currentStreak: 1, longestStreak: 1);
    }
  }

  static Future<void> saveStreak(QuestStreak streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_streakKey, jsonEncode(streak.toJson()));
  }

  static Future<QuestStreak> recordDailyAction({
    bool devotional = false,
    bool bibleReading = false,
    bool prayer = false,
    int bonusXp = 10,
  }) async {
    final current = await loadStreak();
    final now = DateTime.now();

    final newDevotional = devotional || current.completedDevotionalToday;
    final newBible = bibleReading || current.completedBibleReadingToday;
    final newPrayer = prayer || current.completedPrayerToday;

    // If active today and not incremented today
    final isFirstActionToday = current.lastActiveDate == null ||
        DateTime(now.year, now.month, now.day)
                .difference(DateTime(
                  current.lastActiveDate!.year,
                  current.lastActiveDate!.month,
                  current.lastActiveDate!.day,
                ))
                .inDays >
            0;

    int newStreak = current.currentStreak;
    if (isFirstActionToday) {
      newStreak += 1;
    }

    final newLongest = newStreak > current.longestStreak ? newStreak : current.longestStreak;

    final updated = current.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongest,
      lastActiveDate: now,
      completedDevotionalToday: newDevotional,
      completedBibleReadingToday: newBible,
      completedPrayerToday: newPrayer,
      xpPoints: current.xpPoints + bonusXp,
    );

    await saveStreak(updated);
    return updated;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BADGE PERSISTENCE & PROGRESS
  // ─────────────────────────────────────────────────────────────────────────
  static Future<List<MilestoneBadge>> loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_badgesKey);
    if (raw == null) {
      await saveBadges(defaultBadges);
      return defaultBadges;
    }

    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((e) => MilestoneBadge.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return defaultBadges;
    }
  }

  static Future<void> saveBadges(List<MilestoneBadge> badges) async {
    final prefs = await SharedPreferences.getInstance();
    final list = badges.map((b) => b.toJson()).toList();
    await prefs.setString(_badgesKey, jsonEncode(list));
  }

  static Future<List<MilestoneBadge>> incrementBadgeProgress(String badgeId, [int amount = 1]) async {
    final badges = await loadBadges();
    final updated = badges.map((b) {
      if (b.id == badgeId) {
        final newProgress = b.progress + amount;
        final unlocked = newProgress >= b.target;
        return b.copyWith(
          progress: newProgress,
          isUnlocked: b.isUnlocked || unlocked,
          unlockedAt: (b.isUnlocked || unlocked) ? (b.unlockedAt ?? DateTime.now()) : null,
        );
      }
      return b;
    }).toList();

    await saveBadges(updated);
    return updated;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WEEKLY BIBLE TRIVIA & QUIZZES BANK
  // ─────────────────────────────────────────────────────────────────────────
  static final List<TriviaQuiz> weeklyQuizzes = [
    const TriviaQuiz(
      id: 'heroes_of_faith',
      title: 'Heroes of Faith Challenge',
      description: 'Test your knowledge on iconic men and women of God',
      category: 'Old & New Testament',
      timePerQuestionSeconds: 15,
      questions: [
        TriviaQuestion(
          id: 'q1',
          question: 'What young shepherd boy defeated the giant Goliath with a sling and a stone?',
          options: ['Solomon', 'David', 'Jonathan', 'Samuel'],
          correctOptionIndex: 1,
          explanation: 'David defeated Goliath in 1 Samuel 17 declaring that the battle belongs to the Lord!',
          scriptureReference: '1 Samuel 17:45-50',
        ),
        TriviaQuestion(
          id: 'q2',
          question: 'Which queen risked her life by approaching the king uninvited to save her people?',
          options: ['Ruth', 'Deborah', 'Esther', 'Rebekah'],
          correctOptionIndex: 2,
          explanation: 'Esther said, "If I perish, I perish," and interceded for the Jewish people in Persia.',
          scriptureReference: 'Esther 4:14-16',
        ),
        TriviaQuestion(
          id: 'q3',
          question: 'Who walked on water with Jesus until fear caused him to begin sinking?',
          options: ['John', 'Peter', 'James', 'Andrew'],
          correctOptionIndex: 1,
          explanation: 'Peter stepped out of the boat in faith in Matthew 14, and Jesus reached out to save him.',
          scriptureReference: 'Matthew 14:28-31',
        ),
        TriviaQuestion(
          id: 'q4',
          question: 'How many days and nights did Jesus fast in the wilderness before His ministry began?',
          options: ['7 days', '21 days', '40 days', '50 days'],
          correctOptionIndex: 2,
          explanation: 'Jesus fasted for forty days and forty nights and overcame the devil\'s temptations with scripture.',
          scriptureReference: 'Matthew 4:1-4',
        ),
        TriviaQuestion(
          id: 'q5',
          question: 'What is described in Hebrews 11:1 as "the substance of things hoped for, the evidence of things not seen"?',
          options: ['Love', 'Patience', 'Faith', 'Wisdom'],
          correctOptionIndex: 2,
          explanation: 'Faith is the foundational anchor of our relationship with God, without which it is impossible to please Him.',
          scriptureReference: 'Hebrews 11:1, 6',
        ),
      ],
    ),
    const TriviaQuiz(
      id: 'parables_teachings',
      title: 'Parables & Kingdom Secrets',
      description: 'Explore the profound parables spoken by Jesus Christ',
      category: 'Gospels & Teachings',
      timePerQuestionSeconds: 15,
      questions: [
        TriviaQuestion(
          id: 'p1',
          question: 'In the Parable of the Prodigal Son, what did the loving father give his returning son first?',
          options: ['A scolding', 'A robe, ring, and sandals', 'A bag of coins', 'Chores to do'],
          correctOptionIndex: 1,
          explanation: 'The father celebrated his return immediately with honor, symbolizing God\'s unconditional grace.',
          scriptureReference: 'Luke 15:22-24',
        ),
        TriviaQuestion(
          id: 'p2',
          question: 'Jesus said faith as small as what tiny seed can move mountains?',
          options: ['Apple seed', 'Mustard seed', 'Pomegranate seed', 'Grain of wheat'],
          correctOptionIndex: 1,
          explanation: 'Even mustard-seed faith has supernatural potency when placed in an almighty God.',
          scriptureReference: 'Matthew 17:20',
        ),
        TriviaQuestion(
          id: 'p3',
          question: 'Who stopped and showed mercy to the wounded man traveling to Jericho after others passed by?',
          options: ['The Priest', 'The Levite', 'The Good Samaritan', 'The Pharisee'],
          correctOptionIndex: 2,
          explanation: 'The Samaritan bandaged his wounds and paid for his lodging, illustrating true neighborly love.',
          scriptureReference: 'Luke 10:33-35',
        ),
        TriviaQuestion(
          id: 'p4',
          question: 'According to Matthew 6:33, what should kingdom believers seek first above all worries?',
          options: ['Earthly wealth', 'The kingdom of God and His righteousness', 'Popularity', 'A long life'],
          correctOptionIndex: 1,
          explanation: 'Seek first His kingdom, and all our daily needs will be provided by our loving Father.',
          scriptureReference: 'Matthew 6:33',
        ),
        TriviaQuestion(
          id: 'p5',
          question: 'Which piece of the Armor of God is used to extinguish all the flaming arrows of the evil one?',
          options: ['Belt of truth', 'Helmet of salvation', 'Shield of faith', 'Sword of the Spirit'],
          correctOptionIndex: 2,
          explanation: 'In Ephesians 6:16, Paul instructs us above all to take up the shield of faith.',
          scriptureReference: 'Ephesians 6:16',
        ),
      ],
    ),
  ];
}
