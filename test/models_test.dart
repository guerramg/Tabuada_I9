import 'package:flutter_test/flutter_test.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/models/profile.dart';
import 'package:tabuadai9/services/content_service.dart';
import 'package:tabuadai9/services/ops_bank.dart';
import 'package:tabuadai9/services/session_mix.dart';
import 'package:tabuadai9/services/tabuada_service.dart';

void main() {
  test('numeric template generates consistent answer', () {
    final tpl = ExerciseTemplate(
      id: 't1',
      bncc: 'EF03MA01',
      topic: 'mul',
      difficulty: 1,
      type: ExerciseType.numeric,
      template: true,
      questionTemplate: '{a} x {b}',
      aMin: 3,
      aMax: 3,
      bMin: 4,
      bMax: 4,
      op: 'mul',
      explainTemplateBoy: '{a}x{b}={answer}',
      explainTemplateGirl: '{a}x{b}={answer}',
    );
    final ex = tpl.generate();
    expect(ex.answer, 12);
    expect(ex.check(12), isTrue);
    expect(ex.check(11), isFalse);
  });

  test('budget daily slice and pools', () {
    const b = BudgetSettings(monthlyCapI9: 3000, pctDaily: 50, pctExtras: 20, pctMonthBonus: 30);
    expect(b.dailySlice(30), 50);
    expect(b.extrasPool, 600);
    expect(b.monthBonusPool, 900);
    expect(b.capReais, 30.0);
  });

  test('true false check', () {
    final tpl = ExerciseTemplate(
      id: 'tf',
      bncc: 'EF01MA01',
      topic: 't',
      difficulty: 1,
      type: ExerciseType.trueFalse,
      template: false,
      question: '2+2=4',
      answer: true,
      explainBoy: 'ok',
      explainGirl: 'ok',
    );
    final ex = tpl.generate();
    expect(ex.check(true), isTrue);
    expect(ex.check('verdadeiro'), isTrue);
    expect(ex.check(false), isFalse);
  });

  test('session mix 75/25 and ops preference from 5th grade', () {
    ExerciseTemplate tpl(String id, {String? op, String topic = 'x'}) =>
        ExerciseTemplate(
          id: id,
          bncc: 'EF05MA01',
          topic: topic,
          difficulty: 1,
          type: op == null ? ExerciseType.multipleChoice : ExerciseType.numeric,
          template: false,
          question: op == null ? 'Qual figura?' : 'Calcule 2+2',
          op: op,
          answer: '1',
          explainBoy: 'ok',
          explainGirl: 'ok',
        );

    final focusPool = [
      tpl('geo1', topic: 'geometria'),
      tpl('mul1', op: 'mul', topic: 'problemas'),
      tpl('add1', op: 'add', topic: 'problemas'),
      tpl('div1', op: 'div', topic: 'problemas'),
    ];
    final belowPool = [
      tpl('below1', op: 'add', topic: 'contagem'),
      tpl('below2', op: 'sub', topic: 'contagem'),
    ];

    expect(SessionMix.focusCount(8, 5), 6);
    expect(SessionMix.focusCount(5, 1), 5);
    expect(SessionMix.isOpsProblem(tpl('a', op: 'mul')), isTrue);
    expect(SessionMix.isOpsProblem(tpl('g', topic: 'geometria')), isFalse);

    final picked = SessionMix.pick(
      focusPool: focusPool,
      belowPool: belowPool,
      take: 4,
      focusGrade: 5,
    );
    expect(picked.length, 4);
    final focusIds = {'geo1', 'mul1', 'add1', 'div1'};
    final fromFocus = picked.where((t) => focusIds.contains(t.id)).length;
    expect(fromFocus, 3);
    final opsFromFocus = picked
        .where((t) => focusIds.contains(t.id) && SessionMix.isOpsProblem(t))
        .length;
    expect(opsFromFocus, 3);
  });

  test('ano foco 5 never unlocks years 6-9', () {
    final p = Profile(
      id: 1,
      name: 'Rafa',
      avatarIndex: 0,
      gender: 'boy',
      currentGrade: 9,
      maxGrade: 9,
      focusGrade: 5,
      parentPin: '1234',
      createdAt: DateTime(2026, 1, 1),
    );
    expect(p.studyCeiling, 5);
    expect(p.studyGrade, 5);
    expect(p.isGradeUnlocked(5), isTrue);
    expect(p.isGradeUnlocked(4), isTrue);
    expect(p.isGradeUnlocked(6), isFalse);
    expect(p.isGradeUnlocked(9), isFalse);
    final lowered = p.copyWith(focusGrade: 5);
    expect(lowered.currentGrade, 5);
    expect(lowered.maxGrade, 9);
  });

  test('study year is focus, never maxGrade above focus', () {
    expect(ContentService.resolveStudyYear(5, 9), 5);
    expect(ContentService.resolveStudyYear(5, 5), 5);
    expect(ContentService.resolveStudyYear(8, 5), 5);
    expect(ContentService.resolveStudyYear(1, 9), 1);
  });

  test('session mix prefers mul/div over geometry', () {
    ExerciseTemplate tpl(String id, {String? op, String topic = 'x'}) =>
        ExerciseTemplate(
          id: id,
          bncc: 'EF05MA01',
          topic: topic,
          difficulty: 1,
          type: op == null ? ExerciseType.multipleChoice : ExerciseType.numeric,
          template: false,
          question: op == null ? 'Qual figura?' : 'Calcule',
          op: op,
          answer: '1',
          explainBoy: 'ok',
          explainGirl: 'ok',
        );
    expect(SessionMix.isCoreSkill(tpl('m', op: 'mul')), isTrue);
    expect(SessionMix.isCoreSkill(tpl('d', op: 'div')), isTrue);
    expect(SessionMix.isCoreSkill(tpl('g', topic: 'geometria')), isFalse);

    final picked = SessionMix.pick(
      focusPool: [
        tpl('geo1', topic: 'geometria'),
        tpl('geo2', topic: 'geometria'),
        tpl('mul1', op: 'mul'),
        tpl('div1', op: 'div'),
      ],
      belowPool: [tpl('b1', op: 'add')],
      take: 4,
      focusGrade: 5,
    );
    final focusCore = picked
        .where((t) => t.id == 'mul1' || t.id == 'div1')
        .length;
    expect(focusCore, 2);
  });

  test('tabuada bank respects focus year and answers', () {
    expect(TabuadaService.maxTable(2), 5);
    expect(TabuadaService.maxTable(3), 10);
    expect(TabuadaService.maxTable(5), 12);
    final quiz = TabuadaService.buildSession(
      focusGrade: 5,
      table: 7,
      op: 'mul',
      count: 8,
      sequential: true,
    );
    expect(quiz.length, 8);
    expect(quiz.first.question, 'Quanto é 7 × 1?');
    expect(quiz.first.answer, 7);
    expect(quiz.first.check(7), isTrue);
    final div = TabuadaService.buildSession(
      focusGrade: 5,
      table: 8,
      op: 'div',
      count: 1,
      sequential: true,
    );
    expect(div.single.answer, 1);
    expect(div.single.check(1), isTrue);
  });

  test('ops bank for 5th grade is mul/div/problems heavy', () {
    final bank = OpsBank.forGrade(5, unit: 'numeros');
    expect(bank.length, greaterThan(6));
    expect(bank.where(SessionMix.isCoreSkill).length, greaterThan(4));
  });
}
