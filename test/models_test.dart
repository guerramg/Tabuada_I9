import 'package:flutter_test/flutter_test.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/models/profile.dart';

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
}
