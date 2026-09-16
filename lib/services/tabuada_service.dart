import 'dart:math';

import 'package:tabuadai9/models/exercise.dart';

/// Dedicated multiplication-table trainer (treino de tabuada).
class TabuadaService {
  static int maxTable(int focusGrade) {
    if (focusGrade <= 2) return 5;
    if (focusGrade <= 3) return 10;
    return 12;
  }

  static int timesThrough(int focusGrade) => focusGrade <= 2 ? 10 : 10;

  static List<int> tablesFor(int focusGrade) =>
      List<int>.generate(maxTable(focusGrade), (i) => i + 1);

  static List<(int, int, int)> rowsFor(int table, {int through = 10}) {
    return [
      for (var b = 0; b <= through; b++) (table, b, table * b),
    ];
  }

  static List<GeneratedExercise> buildSession({
    required int focusGrade,
    int? table,
    required String op, // mul | div | mixed
    required int count,
    bool sequential = false,
    Random? random,
  }) {
    final rng = random ?? Random();
    final maxT = maxTable(focusGrade);
    final through = timesThrough(focusGrade);
    final tables = table == null
        ? tablesFor(focusGrade)
        : [table.clamp(1, maxT).toInt()];

    final pool = <GeneratedExercise>[];
    for (final t in tables) {
      for (var b = 1; b <= through; b++) {
        final product = t * b;
        if (op == 'div' || (op == 'mixed' && rng.nextBool())) {
          pool.add(_div(t, b, product));
        } else {
          pool.add(_mul(t, b, product));
        }
        if (op == 'mixed') {
          pool.add(_mul(t, b, product));
        }
      }
    }
    if (sequential) {
      return pool.take(count).toList();
    }
    pool.shuffle(rng);
    return pool.take(count).toList();
  }

  static GeneratedExercise _mul(int a, int b, int product) {
    return GeneratedExercise(
      id: 'tabuada_mul_${a}_$b',
      bncc: 'TABUADA',
      topic: 'tabuada',
      type: ExerciseType.numeric,
      question: 'Quanto é $a × $b?',
      answer: product,
      explainBoy: 'Tabuada do $a: $a × $b = $product. Mandou a real!',
      explainGirl: 'Tabuada do $a: $a × $b = $product. Arrasou!',
      xp: 10,
      a: a,
      b: b,
    );
  }

  static GeneratedExercise _div(int a, int b, int product) {
    return GeneratedExercise(
      id: 'tabuada_div_${product}_$a',
      bncc: 'TABUADA',
      topic: 'tabuada',
      type: ExerciseType.numeric,
      question: 'Quanto é $product ÷ $a?',
      answer: b,
      explainBoy: 'Inversa da tabuada: $product ÷ $a = $b porque $a × $b = $product.',
      explainGirl: 'Inversa da tabuada: $product ÷ $a = $b porque $a × $b = $product.',
      xp: 12,
      a: product,
      b: a,
    );
  }
}
