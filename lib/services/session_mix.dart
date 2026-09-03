import 'package:tabuadai9/models/exercise.dart';

/// Mixes questions by parent "ano foco":
/// 75% from the focus year, 25% from years below.
/// From 5º to 9º, the 75% block prefers operations and word problems.
class SessionMix {
  static const double focusShare = 0.75;

  static const ops = {'add', 'sub', 'mul', 'div'};

  static bool isOpsProblem(ExerciseTemplate t) {
    if (t.op != null && ops.contains(t.op)) return true;
    if (t.type == ExerciseType.numeric) return true;
    final topic = t.topic.toLowerCase();
    if (topic.contains('problema') ||
        topic.contains('oper') ||
        topic.contains('conta') ||
        topic.contains('calculo') ||
        topic.contains('cálculo')) {
      return true;
    }
    final q = '${t.question ?? ''} ${t.questionTemplate ?? ''}'.toLowerCase();
    if (RegExp(r'[+\-×x÷/*]').hasMatch(q)) return true;
    const hints = [
      'calcule',
      'quanto é',
      'quanto e',
      'mais',
      'menos',
      'vezes',
      'divid',
      'soma',
      'resto',
      'produto',
      'problema',
    ];
    return hints.any(q.contains);
  }

  static int focusCount(int take, int focusGrade) {
    if (take <= 0) return 0;
    if (focusGrade <= 1) return take;
    final n = (take * focusShare).round();
    return n.clamp(1, take);
  }

  static List<ExerciseTemplate> pick({
    required List<ExerciseTemplate> focusPool,
    required List<ExerciseTemplate> belowPool,
    required int take,
    required int focusGrade,
  }) {
    if (take <= 0) return [];
    final wantFocus = focusCount(take, focusGrade);
    final wantBelow = take - wantFocus;

    final orderedFocus = _orderFocusPool(focusPool, focusGrade);

    final below = List<ExerciseTemplate>.from(belowPool)..shuffle();

    final picked = <ExerciseTemplate>[];
    picked.addAll(_takeUnique(orderedFocus, wantFocus));
    picked.addAll(_takeUnique(below, wantBelow, skip: picked));

    if (picked.length < take) {
      final fallback = [...orderedFocus, ...below];
      picked.addAll(_takeUnique(fallback, take - picked.length, skip: picked));
    }
    picked.shuffle();
    return picked.take(take).toList();
  }

  static List<ExerciseTemplate> _orderFocusPool(
    List<ExerciseTemplate> focusPool,
    int focusGrade,
  ) {
    if (focusGrade < 5) {
      return List<ExerciseTemplate>.from(focusPool)..shuffle();
    }
    final preferred = focusPool.where(isOpsProblem).toList()..shuffle();
    final other = focusPool.where((t) => !isOpsProblem(t)).toList()..shuffle();
    return [...preferred, ...other];
  }

  static List<ExerciseTemplate> _takeUnique(
    List<ExerciseTemplate> source,
    int n, {
    List<ExerciseTemplate> skip = const [],
  }) {
    final skipIds = skip.map((e) => e.id).toSet();
    final out = <ExerciseTemplate>[];
    for (final t in source) {
      if (out.length >= n) break;
      if (skipIds.contains(t.id)) continue;
      out.add(t);
      skipIds.add(t.id);
    }
    return out;
  }
}
