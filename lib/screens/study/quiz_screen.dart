import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/screens/study/result_screen.dart';
import 'package:tabuadai9/services/app_state.dart';
import 'package:tabuadai9/services/content_service.dart';
import 'package:tabuadai9/theme/app_colors.dart';
import 'package:tabuadai9/widgets/common_widgets.dart';

class QuizScreen extends StatefulWidget {
  final SessionMode mode;
  final int grade;
  final String unit;
  final List<GeneratedExercise> exercises;
  final String title;

  const QuizScreen({
    super.key,
    required this.mode,
    required this.grade,
    required this.unit,
    required this.exercises,
    required this.title,
  });

  static Widget loader({
    required SessionMode mode,
    required int grade,
    required String unit,
    required String title,
  }) {
    return _QuizLoader(
      mode: mode,
      grade: grade,
      unit: unit,
      title: title,
    );
  }

  static Widget reviewLoader({required int maxGrade}) {
    return _ReviewLoader(maxGrade: maxGrade);
  }

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizLoader extends StatefulWidget {
  final SessionMode mode;
  final int grade;
  final String unit;
  final String title;

  const _QuizLoader({
    required this.mode,
    required this.grade,
    required this.unit,
    required this.title,
  });

  @override
  State<_QuizLoader> createState() => _QuizLoaderState();
}

class _QuizLoaderState extends State<_QuizLoader> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    final exercises = await ContentService.instance.buildSession(
      grade: widget.grade,
      unit: widget.unit,
      mode: widget.mode,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          mode: widget.mode,
          grade: widget.grade,
          unit: widget.unit,
          exercises: exercises,
          title: widget.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _ReviewLoader extends StatefulWidget {
  final int maxGrade;
  const _ReviewLoader({required this.maxGrade});

  @override
  State<_ReviewLoader> createState() => _ReviewLoaderState();
}

class _ReviewLoaderState extends State<_ReviewLoader> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    final exercises = await ContentService.instance
        .buildReviewSession(maxGrade: widget.maxGrade);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          mode: SessionMode.review,
          grade: 1,
          unit: 'revisao',
          exercises: exercises,
          title: 'Modo Revisão',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _AnswerLog {
  final GeneratedExercise exercise;
  final bool correct;
  final String userAnswer;
  const _AnswerLog({
    required this.exercise,
    required this.correct,
    required this.userAnswer,
  });
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
  int index = 0;
  int correctCount = 0;
  int exitCount = 0;
  bool showingExplain = false;
  bool lastCorrect = false;
  bool focusClean = true;
  bool voidedCurrent = false;
  final answerCtrl = TextEditingController();
  final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  late final ConfettiController confetti;
  final logs = <_AnswerLog>[];
  Timer? questionTimer;
  int secondsLeft = 45;

  GeneratedExercise get current => widget.exercises[index];

  bool get focusEnabled {
    final focus = context.read<AppState>().focus;
    if (widget.mode == SessionMode.test) return focus.enabledOnTest;
    if (widget.mode == SessionMode.challenge) return focus.enabledOnChallenge;
    return false;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    confetti = ConfettiController(duration: const Duration(seconds: 1));
    _startTimerIfNeeded();
  }

  void _startTimerIfNeeded() {
    questionTimer?.cancel();
    if (widget.mode != SessionMode.test) return;
    secondsLeft = 45;
    questionTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || showingExplain) return;
      setState(() => secondsLeft--);
      if (secondsLeft <= 0) {
        t.cancel();
        _submit(timeout: true);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    answerCtrl.dispose();
    confetti.dispose();
    questionTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!focusEnabled || showingExplain) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _onFocusLost();
    }
  }

  Future<void> _onFocusLost() async {
    focusClean = false;
    exitCount++;
    final app = context.read<AppState>();
    final settings = app.focus;
    String action = 'warn';
    if (settings.voidWholeTestOnExit) {
      action = 'void_session';
      await app.logFocusEvent(
        sessionId: sessionId,
        mode: widget.mode.name,
        action: action,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Prova anulada'),
          content: Text(app.copy.focusWarn),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }

    if (exitCount > settings.maxExitsBeforeVoid) {
      action = 'void_question';
      voidedCurrent = true;
    }
    await app.logFocusEvent(
      sessionId: sessionId,
      mode: widget.mode.name,
      action: action,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          action == 'void_question'
              ? 'Questão anulada por sair do app.'
              : app.copy.focusWarn,
        ),
        backgroundColor: AppColors.danger,
      ),
    );
    if (action == 'void_question') {
      _lockAnswer(correct: false, userAnswer: '(anulada)');
    }
  }

  Future<void> _submit({bool timeout = false}) async {
    if (showingExplain) return;
    dynamic userAnswer;
    if (timeout || voidedCurrent) {
      userAnswer = timeout ? '(tempo)' : '(anulada)';
      _lockAnswer(correct: false, userAnswer: '$userAnswer');
      return;
    }

    switch (current.type) {
      case ExerciseType.numeric:
      case ExerciseType.fillBlank:
        userAnswer = answerCtrl.text.trim();
        if (userAnswer.isEmpty) return;
        break;
      case ExerciseType.multipleChoice:
      case ExerciseType.trueFalse:
      case ExerciseType.dragOrder:
        return; // handled by option buttons
    }
    final ok = current.check(userAnswer);
    _lockAnswer(correct: ok, userAnswer: '$userAnswer');
  }

  Future<void> _lockAnswer({
    required bool correct,
    required String userAnswer,
  }) async {
    questionTimer?.cancel();
    final app = context.read<AppState>();
    await app.recordProgress(
      exercise: current,
      correct: correct,
      grade: widget.grade,
      unit: widget.unit,
    );
    logs.add(_AnswerLog(
      exercise: current,
      correct: correct,
      userAnswer: userAnswer,
    ));
    if (correct) {
      correctCount++;
      confetti.play();
    }

    final isTest = widget.mode == SessionMode.test;
    setState(() {
      lastCorrect = correct;
      showingExplain = !isTest;
      voidedCurrent = false;
      answerCtrl.clear();
    });

    if (isTest) {
      // Skip per-question explain; jump next or finish
      await Future.delayed(const Duration(milliseconds: 250));
      _goNext();
    }
  }

  void _goNext() {
    if (index >= widget.exercises.length - 1) {
      _finish();
      return;
    }
    setState(() {
      index++;
      showingExplain = false;
    });
    _startTimerIfNeeded();
  }

  Future<void> _finish() async {
    final app = context.read<AppState>();
    final unlocked = await app.finishSessionRewards(
      mode: widget.mode,
      correct: correctCount,
      total: widget.exercises.length,
      focusClean: focusClean,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          mode: widget.mode,
          title: widget.title,
          correct: correctCount,
          total: widget.exercises.length,
          unlockedKeys: unlocked,
          reviewLogs: widget.mode == SessionMode.test
              ? logs
                  .map((l) => ReviewItem(
                        question: l.exercise.question,
                        correct: l.correct,
                        explain: l.exercise
                            .explain(app.profile?.isBoy ?? true),
                        userAnswer: l.userAnswer,
                      ))
                  .toList()
              : const [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final isBoy = app.profile?.isBoy ?? true;
    final exercise = current;

    return PopScope(
      canPop: !focusEnabled,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && focusEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Modo Foco ativo — termine a sessão para sair.'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            if (widget.mode == SessionMode.test)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: Text(
                    '${secondsLeft}s',
                    style: GoogleFonts.exo2(
                      color: secondsLeft <= 10
                          ? AppColors.danger
                          : AppColors.cyan,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Stack(
          children: [
            CircuitBackground(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: showingExplain
                    ? _ExplainPane(
                        correct: lastCorrect,
                        explain: exercise.explain(isBoy),
                        copyCorrect: app.copy.correct,
                        copyWrong: app.copy.wrong,
                        nextLabel: app.copy.next,
                        onNext: _goNext,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Questão ${index + 1}/${widget.exercises.length}',
                            style: GoogleFonts.exo2(color: AppColors.grey),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: (index + 1) / widget.exercises.length,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(8),
                            color: app.theme.accent,
                            backgroundColor:
                                AppColors.grey.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 20),
                          GradientCard(
                            padding: const EdgeInsets.all(22),
                            child: Text(
                              exercise.question,
                              style: GoogleFonts.exo2(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(child: _buildInput(exercise, isBoy)),
                          if (exercise.type == ExerciseType.numeric ||
                              exercise.type == ExerciseType.fillBlank)
                            ElevatedButton(
                              onPressed: () => _submit(),
                              child: const Text('Confirmar'),
                            ),
                        ],
                      ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confetti,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: [
                  AppColors.cyan,
                  AppColors.blue,
                  app.theme.accent,
                  AppColors.coin,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(GeneratedExercise exercise, bool isBoy) {
    switch (exercise.type) {
      case ExerciseType.numeric:
      case ExerciseType.fillBlank:
        return TextField(
          controller: answerCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: exercise.type == ExerciseType.numeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'-?[0-9]'))]
              : null,
          enableInteractiveSelection: false,
          decoration: const InputDecoration(
            labelText: 'Sua resposta',
          ),
          onSubmitted: (_) => _submit(),
        );
      case ExerciseType.multipleChoice:
        return ListView(
          children: (exercise.options ?? []).map((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GradientCard(
                onTap: () => _lockAnswer(correct: exercise.check(opt), userAnswer: opt),
                child: Text(opt,
                    style: GoogleFonts.exo2(
                        fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            );
          }).toList(),
        );
      case ExerciseType.trueFalse:
        return Column(
          children: [
            GradientCard(
              onTap: () =>
                  _lockAnswer(correct: exercise.check(true), userAnswer: 'true'),
              child: Text('Verdadeiro',
                  style: GoogleFonts.exo2(
                      fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            GradientCard(
              onTap: () => _lockAnswer(
                  correct: exercise.check(false), userAnswer: 'false'),
              child: Text('Falso',
                  style: GoogleFonts.exo2(
                      fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ],
        );
      case ExerciseType.dragOrder:
        return GradientCard(
          child: Text(
            'Arraste (em breve). Por enquanto, use o quiz múltipla escolha.',
            style: GoogleFonts.exo2(),
          ),
        );
    }
  }
}

class _ExplainPane extends StatelessWidget {
  final bool correct;
  final String explain;
  final String copyCorrect;
  final String copyWrong;
  final String nextLabel;
  final VoidCallback onNext;

  const _ExplainPane({
    required this.correct,
    required this.explain,
    required this.copyCorrect,
    required this.copyWrong,
    required this.nextLabel,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientCard(
          color: (correct ? AppColors.success : AppColors.danger)
              .withValues(alpha: 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                correct ? copyCorrect : copyWrong,
                style: GoogleFonts.exo2(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                explain.isEmpty
                    ? 'Bora revisar o cálculo juntos na próxima!'
                    : explain,
                style: GoogleFonts.exo2(fontSize: 16, height: 1.4),
              ),
            ],
          ),
        ),
        const Spacer(),
        ElevatedButton(onPressed: onNext, child: Text(nextLabel)),
      ],
    );
  }
}
