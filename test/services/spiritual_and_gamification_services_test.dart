import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kingdom_quest/shared/services/bible_service.dart';
import 'package:kingdom_quest/shared/services/gamification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('BibleService Tests', () {
    test('contains all 66 canonical books (39 OT, 27 NT)', () {
      expect(BibleService.books.length, 66);
      final ot = BibleService.books.where((b) => b.testament == 'OT').toList();
      final nt = BibleService.books.where((b) => b.testament == 'NT').toList();
      expect(ot.length, 39);
      expect(nt.length, 27);
    });

    test('retrieves curated chapter accurately for John 1', () {
      final chapter = BibleService.getChapter('John', 1);
      expect(chapter.bookName, 'John');
      expect(chapter.chapterNumber, 1);
      expect(chapter.verses.isNotEmpty, true);
      expect(chapter.verses.first.text, contains('In the beginning was the Word'));
      expect(chapter.verses.first.reference, 'John 1:1');
    });

    test('generates devotional verses for chapters without manual transcriptions', () {
      final chapter = BibleService.getChapter('Leviticus', 5);
      expect(chapter.bookName, 'Leviticus');
      expect(chapter.chapterNumber, 5);
      expect(chapter.verses.isNotEmpty, true);
      expect(chapter.verses.first.reference, 'Leviticus 5:1');
    });

    test('search finds matching scriptures with correct references', () {
      final results = BibleService.search('peace');
      expect(results.isNotEmpty, true);
      expect(results.any((v) => v.text.toLowerCase().contains('peace')), true);
    });

    test('curated youth reading plans have valid structure and daily items', () {
      expect(BibleService.readingPlans.length, greaterThanOrEqualTo(3));
      for (final plan in BibleService.readingPlans) {
        expect(plan.id.isNotEmpty, true);
        expect(plan.title.isNotEmpty, true);
        expect(plan.days.isNotEmpty, true);
        for (final day in plan.days) {
          expect(day.dayNumber, greaterThan(0));
          expect(day.scriptureRef.isNotEmpty, true);
          expect(day.reflection.isNotEmpty, true);
          expect(day.prayerPrompt.isNotEmpty, true);
        }
      }
    });

    test('persists reading plan completion status', () async {
      final planId = BibleService.readingPlans.first.id;
      final initial = await BibleService.getCompletedDayNumbers(planId);
      expect(initial, isEmpty);

      await BibleService.toggleDayCompletion(planId, 1, true);
      final afterDay1 = await BibleService.getCompletedDayNumbers(planId);
      expect(afterDay1, contains(1));

      await BibleService.toggleDayCompletion(planId, 1, false);
      final afterUntoggle = await BibleService.getCompletedDayNumbers(planId);
      expect(afterUntoggle, isNot(contains(1)));
    });
  });

  group('GamificationService Tests', () {
    test('loads default badges with 8 initial achievements', () async {
      final badges = await GamificationService.loadBadges();
      expect(badges.length, 8);
      expect(badges.any((b) => b.id == 'first_steps' && b.isUnlocked), true);
      expect(badges.any((b) => b.id == 'shield_of_faith'), true);
      expect(badges.any((b) => b.id == 'bible_scholar'), true);
    });

    test('records daily action and increments streak & XP points', () async {
      final initial = await GamificationService.loadStreak();
      expect(initial.currentStreak, greaterThanOrEqualTo(1));

      final updated = await GamificationService.recordDailyAction(
        devotional: true,
        bibleReading: true,
        bonusXp: 25,
      );

      expect(updated.completedDevotionalToday, true);
      expect(updated.completedBibleReadingToday, true);
      expect(updated.xpPoints, greaterThan(initial.xpPoints));
    });

    test('increments badge progress and unlocks when target is reached', () async {
      final updatedBadges = await GamificationService.incrementBadgeProgress('berean_mind', 5);
      final berean = updatedBadges.firstWhere((b) => b.id == 'berean_mind');
      expect(berean.progress, greaterThanOrEqualTo(5));
      expect(berean.isUnlocked, true);
    });

    test('weekly trivia challenge has multiple choice questions with explanations', () {
      expect(GamificationService.weeklyQuizzes.isNotEmpty, true);
      for (final quiz in GamificationService.weeklyQuizzes) {
        expect(quiz.title.isNotEmpty, true);
        expect(quiz.questions.isNotEmpty, true);
        for (final q in quiz.questions) {
          expect(q.options.length, greaterThanOrEqualTo(4));
          expect(q.correctOptionIndex, inInclusiveRange(0, q.options.length - 1));
          expect(q.explanation.isNotEmpty, true);
          expect(q.scriptureReference.isNotEmpty, true);
        }
      }
    });
  });
}
