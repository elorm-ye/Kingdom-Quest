import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/gamification_models.dart';
import '../../../shared/services/gamification_service.dart';
import '../../../shared/widgets/app_pop_scope.dart';

class TriviaQuizScreen extends ConsumerStatefulWidget {
  const TriviaQuizScreen({super.key});

  @override
  ConsumerState<TriviaQuizScreen> createState() => _TriviaQuizScreenState();
}

class _TriviaQuizScreenState extends ConsumerState<TriviaQuizScreen> {
  TriviaQuiz? _selectedQuiz;
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _answered = false;
  int _score = 0;
  bool _quizCompleted = false;

  Timer? _timer;
  int _secondsLeft = 15;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startQuiz(TriviaQuiz quiz) {
    setState(() {
      _selectedQuiz = quiz;
      _currentQuestionIndex = 0;
      _selectedOptionIndex = null;
      _answered = false;
      _score = 0;
      _quizCompleted = false;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    final timeLimit = _selectedQuiz?.timePerQuestionSeconds ?? 15;
    setState(() {
      _secondsLeft = timeLimit;
      _answered = false;
      _selectedOptionIndex = null;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
        _onTimeOut();
      }
    });
  }

  void _onTimeOut() {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedOptionIndex = -1; // Timed out
    });
  }

  void _selectOption(int optionIndex) {
    if (_answered) return;
    _timer?.cancel();
    final quiz = _selectedQuiz!;
    final question = quiz.questions[_currentQuestionIndex];
    final isCorrect = optionIndex == question.correctOptionIndex;

    setState(() {
      _answered = true;
      _selectedOptionIndex = optionIndex;
      if (isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    final quiz = _selectedQuiz!;
    if (_currentQuestionIndex < quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _startTimer();
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    _timer?.cancel();
    setState(() {
      _quizCompleted = true;
    });

    final quiz = _selectedQuiz!;
    ref.read(gamificationNotifierProvider.notifier).submitTriviaScore(
          quizId: quiz.id,
          score: _score,
          totalQuestions: quiz.questions.length,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPopScope(
      fallbackRoute: '/quests',
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(fallbackRoute: '/quests'),
          title: Text(_selectedQuiz == null ? 'Weekly Bible Trivia' : _selectedQuiz!.title),
        ),
        body: _selectedQuiz == null
            ? _buildQuizSelector(theme)
            : _quizCompleted
                ? _buildScoreCard(theme)
                : _buildActiveQuiz(theme),
      ),
    );
  }

  Widget _buildQuizSelector(ThemeData theme) {
    final quizzes = GamificationService.weeklyQuizzes;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.terracotta, AppColors.burntAmber],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('👑', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 10),
              Text(
                'Weekly Scripture Challenge',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Test your Bible knowledge against the clock! Earn XP and unlock the "Bible Scholar" milestone badge.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(220),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        Text(
          'Choose a Challenge',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),

        ...quizzes.map((quiz) {
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor.withAlpha(50)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.terracotta.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          quiz.category,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.terracotta,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text(
                        '${quiz.timePerQuestionSeconds}s / question',
                        style: theme.textTheme.labelSmall?.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    quiz.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quiz.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${quiz.questions.length} Questions',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.terracotta,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _startQuiz(quiz),
                        child: const Text('Start Quiz'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActiveQuiz(ThemeData theme) {
    final quiz = _selectedQuiz!;
    final question = quiz.questions[_currentQuestionIndex];
    final total = quiz.questions.length;
    final timeLimit = quiz.timePerQuestionSeconds;
    final timePercent = (_secondsLeft / timeLimit).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress & Timer bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of $total',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.muted,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 18,
                    color: _secondsLeft <= 5 ? AppColors.alert : AppColors.terracotta,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_secondsLeft}s',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _secondsLeft <= 5 ? AppColors.alert : AppColors.terracotta,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Countdown visual line
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: timePercent,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                _secondsLeft <= 5 ? AppColors.alert : AppColors.terracotta,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(70),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor.withAlpha(40)),
            ),
            child: Text(
              question.question,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Options
          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, optIdx) {
                final optionText = question.options[optIdx];
                final isCorrect = optIdx == question.correctOptionIndex;
                final isSelected = _selectedOptionIndex == optIdx;

                Color borderColor = theme.dividerColor.withAlpha(50);
                Color bgColor = theme.colorScheme.surface;
                Widget? trailingIcon;

                if (_answered) {
                  if (isCorrect) {
                    borderColor = AppColors.sage;
                    bgColor = AppColors.sage.withAlpha(25);
                    trailingIcon = const Icon(Icons.check_circle, color: AppColors.sage);
                  } else if (isSelected) {
                    borderColor = AppColors.alert;
                    bgColor = AppColors.alert.withAlpha(25);
                    trailingIcon = const Icon(Icons.cancel, color: AppColors.alert);
                  }
                }

                return InkWell(
                  onTap: _answered ? null : () => _selectOption(optIdx),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor, width: isSelected || isCorrect ? 2 : 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            String.fromCharCode(65 + optIdx), // A, B, C, D
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            optionText,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ?trailingIcon,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Explanation Banner & Next Button
          if (_answered) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.burntAmber.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.burntAmber.withAlpha(60)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book, size: 16, color: AppColors.burntAmber),
                      const SizedBox(width: 6),
                      Text(
                        question.scriptureReference,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.burntAmber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    question.explanation,
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.terracotta,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _nextQuestion,
                child: Text(
                  _currentQuestionIndex < total - 1 ? 'Next Question' : 'View Results',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreCard(ThemeData theme) {
    final quiz = _selectedQuiz!;
    final total = quiz.questions.length;
    final isPerfect = _score == total && total > 0;
    final percent = total > 0 ? (_score / total * 100).round() : 0;
    final xpEarned = _score * 15;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isPerfect ? '👑' : (_score >= (total / 2) ? '🎉' : '📖'),
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              isPerfect
                  ? 'Bible Scholar Achievement!'
                  : (_score >= (total / 2) ? 'Great Knowledge!' : 'Keep Studying the Word!'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You scored $_score out of $total ($percent%)',
              style: theme.textTheme.titleMedium?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.terracotta.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.terracotta.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    '+$xpEarned XP Points Earned',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.terracotta,
                    ),
                  ),
                ],
              ),
            ),
            if (isPerfect) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.sage.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.military_tech, color: AppColors.sage, size: 20),
                    SizedBox(width: 6),
                    Text(
                      '"Bible Scholar" Badge Unlocked!',
                      style: TextStyle(
                        color: AppColors.sage,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _startQuiz(quiz),
                    child: const Text('Try Again'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.terracotta,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedQuiz = null;
                      });
                    },
                    child: const Text('More Quizzes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
