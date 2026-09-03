import 'dart:math';

enum ExerciseType { numeric, multipleChoice, trueFalse, dragOrder, fillBlank }

enum SessionMode { daily, quiz, challenge, test, review }

class LessonSlide {
  final String titleBoy;
  final String titleGirl;
  final String bodyBoy;
  final String bodyGirl;

  const LessonSlide({
    required this.titleBoy,
    required this.titleGirl,
    required this.bodyBoy,
    required this.bodyGirl,
  });

  factory LessonSlide.fromJson(Map<String, dynamic> json) => LessonSlide(
        titleBoy: json['title_boy'] as String? ?? json['title'] as String? ?? '',
        titleGirl:
            json['title_girl'] as String? ?? json['title'] as String? ?? '',
        bodyBoy: json['body_boy'] as String? ?? json['body'] as String? ?? '',
        bodyGirl: json['body_girl'] as String? ?? json['body'] as String? ?? '',
      );

  String title(bool isBoy) => isBoy ? titleBoy : titleGirl;
  String body(bool isBoy) => isBoy ? bodyBoy : bodyGirl;
}

class LessonTopic {
  final String id;
  final String name;
  final String bncc;

  const LessonTopic({
    required this.id,
    required this.name,
    required this.bncc,
  });

  factory LessonTopic.fromJson(Map<String, dynamic> json) => LessonTopic(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        bncc: json['bncc'] as String? ?? '',
      );
}

class LessonContent {
  final String unit;
  final int grade;
  final String title;
  final String titleBoy;
  final String titleGirl;
  final List<LessonSlide> slides;
  final List<LessonTopic> topics;

  const LessonContent({
    required this.unit,
    required this.grade,
    required this.title,
    required this.titleBoy,
    required this.titleGirl,
    required this.slides,
    required this.topics,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) => LessonContent(
        unit: json['unit'] as String? ?? '',
        grade: json['grade'] as int? ?? 1,
        title: json['title'] as String? ?? '',
        titleBoy: json['title_boy'] as String? ?? json['title'] as String? ?? '',
        titleGirl:
            json['title_girl'] as String? ?? json['title'] as String? ?? '',
        slides: ((json['slides'] as List?) ?? [])
            .map((e) => LessonSlide.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        topics: ((json['topics'] as List?) ?? [])
            .map((e) => LessonTopic.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  String displayTitle(bool isBoy) => isBoy ? titleBoy : titleGirl;
}

class ExerciseTemplate {
  final String id;
  final String bncc;
  final String topic;
  final int difficulty;
  final ExerciseType type;
  final bool template;
  final String? question;
  final String? questionTemplate;
  final int? aMin;
  final int? aMax;
  final int? bMin;
  final int? bMax;
  final String? op;
  final List<String>? options;
  final dynamic answer;
  final String? explainBoy;
  final String? explainGirl;
  final String? explainTemplateBoy;
  final String? explainTemplateGirl;
  final int xp;

  const ExerciseTemplate({
    required this.id,
    required this.bncc,
    required this.topic,
    required this.difficulty,
    required this.type,
    required this.template,
    this.question,
    this.questionTemplate,
    this.aMin,
    this.aMax,
    this.bMin,
    this.bMax,
    this.op,
    this.options,
    this.answer,
    this.explainBoy,
    this.explainGirl,
    this.explainTemplateBoy,
    this.explainTemplateGirl,
    this.xp = 10,
  });

  factory ExerciseTemplate.fromJson(Map<String, dynamic> json) {
    ExerciseType parseType(String? raw) {
      switch (raw) {
        case 'multiple_choice':
          return ExerciseType.multipleChoice;
        case 'true_false':
          return ExerciseType.trueFalse;
        case 'drag_order':
          return ExerciseType.dragOrder;
        case 'fill_blank':
          return ExerciseType.fillBlank;
        default:
          return ExerciseType.numeric;
      }
    }

    return ExerciseTemplate(
      id: json['id'] as String? ?? '',
      bncc: json['bncc'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      difficulty: json['difficulty'] as int? ?? 1,
      type: parseType(json['type'] as String?),
      template: json['template'] as bool? ?? false,
      question: json['question'] as String?,
      questionTemplate: json['question_template'] as String?,
      aMin: json['a_min'] as int?,
      aMax: json['a_max'] as int?,
      bMin: json['b_min'] as int?,
      bMax: json['b_max'] as int?,
      op: json['op'] as String?,
      options: (json['options'] as List?)?.map((e) => '$e').toList(),
      answer: json['answer'],
      explainBoy: json['explain_boy'] as String?,
      explainGirl: json['explain_girl'] as String?,
      explainTemplateBoy: json['explain_template_boy'] as String?,
      explainTemplateGirl: json['explain_template_girl'] as String?,
      xp: json['xp'] as int? ?? 10,
    );
  }

  GeneratedExercise generate({Random? random}) {
    final rng = random ?? Random();
    if (!template || type != ExerciseType.numeric) {
      return GeneratedExercise(
        id: id,
        bncc: bncc,
        topic: topic,
        type: type,
        question: question ?? '',
        options: options,
        answer: answer,
        explainBoy: explainBoy ?? '',
        explainGirl: explainGirl ?? '',
        xp: xp,
      );
    }

    var a = _rand(rng, aMin ?? 1, aMax ?? 9);
    var b = _rand(rng, bMin ?? 1, bMax ?? 9);
    final operation = op ?? 'add';
    int result;
    switch (operation) {
      case 'sub':
        if (b > a) {
          final tmp = a;
          a = b;
          b = tmp;
        }
        result = a - b;
        break;
      case 'mul':
        result = a * b;
        break;
      case 'div':
        b = b == 0 ? 1 : b;
        a = a - (a % b);
        if (a == 0) a = b;
        result = a ~/ b;
        break;
      default:
        result = a + b;
    }

    String fill(String? tpl) => (tpl ?? '')
        .replaceAll('{a}', '$a')
        .replaceAll('{b}', '$b')
        .replaceAll('{answer}', '$result');

    return GeneratedExercise(
      id: '${id}_${a}_$b',
      bncc: bncc,
      topic: topic,
      type: type,
      question: fill(questionTemplate),
      answer: result,
      explainBoy: fill(explainTemplateBoy),
      explainGirl: fill(explainTemplateGirl),
      xp: xp,
      a: a,
      b: b,
    );
  }

  int _rand(Random rng, int min, int max) {
    if (max < min) return min;
    return min + rng.nextInt(max - min + 1);
  }
}

class GeneratedExercise {
  final String id;
  final String bncc;
  final String topic;
  final ExerciseType type;
  final String question;
  final List<String>? options;
  final dynamic answer;
  final String explainBoy;
  final String explainGirl;
  final int xp;
  final int? a;
  final int? b;

  const GeneratedExercise({
    required this.id,
    required this.bncc,
    required this.topic,
    required this.type,
    required this.question,
    required this.answer,
    required this.explainBoy,
    required this.explainGirl,
    required this.xp,
    this.options,
    this.a,
    this.b,
  });

  String explain(bool isBoy) => isBoy ? explainBoy : explainGirl;

  bool check(dynamic userAnswer) {
    if (type == ExerciseType.trueFalse) {
      final expected = answer == true || answer == 'true' || answer == 1;
      if (userAnswer is bool) return userAnswer == expected;
      final raw = '$userAnswer'.toLowerCase();
      final parsed = raw == 'true' || raw == 'verdadeiro' || raw == 'v';
      return parsed == expected;
    }
    if (type == ExerciseType.numeric) {
      final expected = int.tryParse('$answer');
      final got = int.tryParse('$userAnswer'.trim());
      return expected != null && got != null && expected == got;
    }
    return '$userAnswer'.trim().toLowerCase() ==
        '$answer'.trim().toLowerCase();
  }
}

class SubjectInfo {
  final String id;
  final String name;
  final String emoji;
  final String colorHex;

  const SubjectInfo({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorHex,
  });
}

const subjects = <SubjectInfo>[
  SubjectInfo(
      id: 'numeros', name: 'Números', emoji: '🔢', colorHex: '236AF4'),
  SubjectInfo(
      id: 'algebra', name: 'Álgebra', emoji: '🧩', colorHex: '00C2FF'),
  SubjectInfo(
      id: 'geometria', name: 'Geometria', emoji: '📐', colorHex: '34D399'),
  SubjectInfo(
      id: 'grandezas_medidas',
      name: 'Grandezas e Medidas',
      emoji: '📏',
      colorHex: 'FF8A3D'),
  SubjectInfo(
      id: 'probabilidade_estatistica',
      name: 'Prob. e Estatística',
      emoji: '🎲',
      colorHex: 'B794F6'),
];
