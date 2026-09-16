import 'package:tabuadai9/models/exercise.dart';

/// Extra multiplication, division and logic-problem bank mixed into study
/// sessions. Numbers are randomized at generate() time via templates.
class OpsBank {
  static List<ExerciseTemplate> forGrade(int grade, {String? unit}) {
    final g = grade.clamp(1, 9).toInt();
    final mixed = unit == null ||
        unit == 'revisao' ||
        unit == 'misto' ||
        unit == 'numeros' ||
        unit == 'algebra';
    if (mixed) {
      return [..._mulDiv(g), ..._wordProblems(g)];
    }
    if (unit == 'geometria') return _geoProblems(g);
    if (unit == 'grandezas_medidas') return _measureProblems(g);
    if (unit == 'probabilidade_estatistica') return _statsProblems(g);
    return _wordProblems(g);
  }

  static List<ExerciseTemplate> _mulDiv(int grade) {
    if (grade <= 1) {
      return [
        _n('ops1_add', 'EF01MA06', 'problemas', 1, 'Quanto é {a} + {b}?', 1, 9, 1, 9, 'add'),
        _n('ops1_sub', 'EF01MA06', 'problemas', 1, 'Quanto é {a} − {b}?', 2, 12, 1, 8, 'sub'),
        _n('ops1_add2', 'EF01MA06', 'problemas', 2, 'Calcule {a} + {b}.', 5, 20, 1, 10, 'add'),
      ];
    }
    if (grade <= 2) {
      return [
        _n('ops2_mul', 'EF02MA05', 'tabuada', 1, 'Quanto é {a} × {b}?', 1, 5, 1, 10, 'mul'),
        _n('ops2_mul2', 'EF02MA05', 'tabuada', 1, 'Calcule {a} × {b}.', 2, 5, 0, 10, 'mul'),
        _n('ops2_div', 'EF02MA08', 'tabuada', 2, 'Quanto é {a} ÷ {b}?', 6, 30, 2, 5, 'div'),
        _n('ops2_mul3', 'EF02MA05', 'multiplicacao', 2, '{a} vezes {b} vale quanto?', 1, 10, 2, 5, 'mul'),
      ];
    }
    if (grade <= 3) {
      return [
        _n('ops3_mul', 'EF03MA03', 'tabuada', 1, 'Quanto é {a} × {b}?', 2, 10, 2, 10, 'mul'),
        _n('ops3_mul2', 'EF03MA03', 'tabuada', 2, 'Calcule {a} × {b}.', 3, 10, 3, 10, 'mul'),
        _n('ops3_div', 'EF03MA07', 'tabuada', 2, 'Quanto é {a} ÷ {b}?', 12, 81, 2, 9, 'div'),
        _n('ops3_div2', 'EF03MA07', 'divisao', 2, 'Calcule {a} ÷ {b}.', 10, 100, 2, 10, 'div'),
      ];
    }
    if (grade <= 5) {
      return [
        _n('ops${grade}_mul', 'EF0${grade}MA07', 'tabuada', 1, 'Calcule {a} × {b}.', 4, 12, 4, 12, 'mul'),
        _n('ops${grade}_mul2', 'EF0${grade}MA07', 'multiplicacao', 2, 'Quanto é {a} × {b}?', 6, 25, 3, 12, 'mul'),
        _n('ops${grade}_div', 'EF0${grade}MA07', 'tabuada', 2, 'Calcule {a} ÷ {b}.', 24, 144, 3, 12, 'div'),
        _n('ops${grade}_div2', 'EF0${grade}MA07', 'divisao', 2, 'Quanto é {a} ÷ {b}?', 20, 180, 2, 12, 'div'),
        _n('ops${grade}_mul3', 'EF0${grade}MA07', 'multiplicacao', 3, '{a} × {b} = ?', 11, 40, 6, 15, 'mul'),
      ];
    }
    return [
      _n('ops${grade}_mul', 'EF0${grade}MA04', 'multiplicacao', 2, 'Calcule {a} × {b}.', 12, 50, 6, 18, 'mul'),
      _n('ops${grade}_div', 'EF0${grade}MA04', 'divisao', 2, 'Calcule {a} ÷ {b}.', 36, 360, 4, 18, 'div'),
      _n('ops${grade}_mul2', 'EF0${grade}MA04', 'problemas', 3, 'Quanto é {a} × {b}?', 15, 80, 8, 20, 'mul'),
      _n('ops${grade}_div2', 'EF0${grade}MA04', 'problemas', 3, 'Quanto é {a} ÷ {b}?', 48, 480, 6, 16, 'div'),
    ];
  }

  static List<ExerciseTemplate> _wordProblems(int grade) {
    if (grade <= 1) {
      return [
        _n('wp1_fig', 'EF01MA08', 'problemas', 1,
            'Tinha {a} figurinhas e ganhei {b}. Quantas agora?', 3, 12, 1, 8, 'add'),
        _n('wp1_bala', 'EF01MA08', 'problemas', 1,
            'Havia {a} balas. Comi {b}. Quantas sobraram?', 5, 15, 1, 6, 'sub'),
        _mc('wp1_logic', 'EF01MA08', 'raciocinio', 2,
            'Se 2 + 2 + 2 = 6, quanto é 3 + 3 + 3?',
            ['6', '9', '12', '3'], '9',
            'São 3 grupos de 3: 3+3+3=9.', 'São 3 grupos de 3: 3+3+3=9.'),
      ];
    }
    if (grade <= 2) {
      return [
        _n('wp2_cx', 'EF02MA06', 'problemas', 1,
            'Cada caixa tem {b} lápis. Quantos lápis em {a} caixas?', 2, 5, 2, 6, 'mul'),
        _n('wp2_fila', 'EF02MA06', 'problemas', 2,
            '{a} filas com {b} alunos cada. Quantos alunos?', 2, 5, 3, 8, 'mul'),
        _n('wp2_div', 'EF02MA08', 'problemas', 2,
            '{a} figurinhas para {b} amigos. Quantas para cada um?', 8, 24, 2, 4, 'div'),
        _mc('wp2_dobro', 'EF02MA05', 'raciocinio', 1,
            'O dobro de 7 é:', ['12', '14', '16', '9'], '14',
            'Dobro é vezes 2: 7×2=14.', 'Dobro é vezes 2: 7×2=14.'),
      ];
    }
    if (grade <= 3) {
      return [
        _n('wp3_pac', 'EF03MA07', 'problemas', 1,
            'Ana comprou {a} pacotes com {b} bolachas. Quantas bolachas?', 2, 9, 3, 10, 'mul'),
        _n('wp3_bus', 'EF03MA07', 'problemas', 2,
            'Um ônibus leva {b} alunos. Quantos alunos em {a} ônibus?', 2, 8, 10, 20, 'mul'),
        _n('wp3_div', 'EF03MA07', 'problemas', 2,
            'Dividir {a} cartas entre {b} jogadores. Quantas para cada?', 12, 60, 3, 6, 'div'),
        _mc('wp3_logic', 'EF03MA07', 'raciocinio', 2,
            'Uma caixa tem 4 fileiras com 6 ovos. Quantos ovos?',
            ['10', '18', '24', '46'], '24',
            '4×6=24 ovos.', '4×6=24 ovos.'),
        _mc('wp3_metade', 'EF03MA07', 'raciocinio', 1,
            'A metade de 18 é:', ['6', '8', '9', '12'], '9',
            'Metade é dividir por 2: 18÷2=9.', 'Metade é dividir por 2: 18÷2=9.'),
      ];
    }
    if (grade <= 5) {
      return [
        _n('wp${grade}_loja', 'EF0${grade}MA07', 'problemas', 2,
            'Cada caderno custa {b} reais. Qual o preço de {a} cadernos?', 3, 9, 4, 12, 'mul'),
        _n('wp${grade}_div', 'EF0${grade}MA07', 'problemas', 2,
            '{a} balas para {b} crianças. Quantas para cada uma?', 24, 96, 3, 8, 'div'),
        _n('wp${grade}_cx', 'EF0${grade}MA07', 'problemas', 3,
            '{a} caixas com {b} garrafas. Quantas garrafas no total?', 6, 15, 4, 12, 'mul'),
        _mc('wp${grade}_logic', 'EF0${grade}MA07', 'raciocinio', 2,
            'Um retângulo de 8 por 6 azulejos. Quantos azulejos?',
            ['14', '28', '48', '86'], '48',
            'Área: 8×6=48.', 'Área: 8×6=48.'),
        _mc('wp${grade}_step', 'EF0${grade}MA07', 'raciocinio', 3,
            'João tem 5 pacotes de 12 figurinhas e deu 10. Quantas restam?',
            ['50', '60', '70', '40'], '50',
            '5×12=60, 60−10=50.', '5×12=60, 60−10=50.'),
        _mc('wp${grade}_triplo', 'EF0${grade}MA07', 'raciocinio', 2,
            'O triplo de 15 é:', ['30', '35', '45', '60'], '45',
            'Triplo é vezes 3: 15×3=45.', 'Triplo é vezes 3: 15×3=45.'),
      ];
    }
    return [
      _n('wp${grade}_mul', 'EF0${grade}MA04', 'problemas', 2,
          '{a} caixas com {b} peças. Quantas peças?', 8, 25, 6, 18, 'mul'),
      _n('wp${grade}_div', 'EF0${grade}MA04', 'problemas', 2,
          'Dividir {a} reais igualmente por {b} pessoas. Quanto cada uma?', 40, 240, 4, 12, 'div'),
      _mc('wp${grade}_logic', 'EF0${grade}MA04', 'raciocinio', 3,
          'Uma loja vende 24 kits de 8 peças. Quantas peças no total?',
          ['32', '96', '168', '192'], '192',
          '24×8=192.', '24×8=192.'),
      _mc('wp${grade}_step', 'EF0${grade}MA04', 'raciocinio', 3,
          '12 prateleiras com 15 livros. Tirou 40. Quantos restam?',
          ['140', '180', '200', '220'], '140',
          '12×15=180, 180−40=140.', '12×15=180, 180−40=140.'),
    ];
  }

  static List<ExerciseTemplate> _geoProblems(int grade) {
    return [
      _n('geo_ops_${grade}_a', 'EF0${grade}MA16', 'problemas', 2,
          'Um retângulo tem lados {a} e {b}. Qual a área?', 3, 12, 3, 10, 'mul'),
      _mc('geo_ops_${grade}_b', 'EF0${grade}MA16', 'raciocinio', 2,
          'Um quadrado tem lado 7. Qual a área?',
          ['14', '28', '49', '77'], '49',
          'Área do quadrado: 7×7=49.', 'Área do quadrado: 7×7=49.'),
    ];
  }

  static List<ExerciseTemplate> _measureProblems(int grade) {
    return [
      _n('med_ops_$grade', 'EF0${grade}MA19', 'problemas', 2,
          '{a} pacotes de {b} reais. Qual o valor total?', 2, 12, 2, 15, 'mul'),
      _mc('med_ops_${grade}_b', 'EF0${grade}MA19', 'raciocinio', 2,
          '1 hora tem 60 minutos. Quantos minutos em 3 horas?',
          ['90', '120', '150', '180'], '180',
          '3×60=180 minutos.', '3×60=180 minutos.'),
    ];
  }

  static List<ExerciseTemplate> _statsProblems(int grade) {
    return [
      _n('stat_ops_$grade', 'EF0${grade}MA24', 'problemas', 2,
          '{a} grupos com {b} votos. Quantos votos no total?', 2, 10, 3, 12, 'mul'),
      _mc('stat_ops_${grade}_b', 'EF0${grade}MA24', 'raciocinio', 2,
          'A média de 8, 10 e 12 é:', ['8', '10', '12', '30'], '10',
          '(8+10+12)÷3=10.', '(8+10+12)÷3=10.'),
    ];
  }

  static ExerciseTemplate _n(
    String id,
    String bncc,
    String topic,
    int difficulty,
    String question,
    int aMin,
    int aMax,
    int bMin,
    int bMax,
    String op, {
    int xp = 12,
  }) {
    return ExerciseTemplate(
      id: id,
      bncc: bncc,
      topic: topic,
      difficulty: difficulty,
      type: ExerciseType.numeric,
      template: true,
      questionTemplate: question,
      aMin: aMin,
      aMax: aMax,
      bMin: bMin,
      bMax: bMax,
      op: op,
      explainTemplateBoy: 'Fechou: conta de ${op == 'mul' ? 'vezes' : op == 'div' ? 'dividir' : op == 'sub' ? 'tirar' : 'somar'} → resposta {answer}.',
      explainTemplateGirl: 'Olha só: conta de ${op == 'mul' ? 'vezes' : op == 'div' ? 'dividir' : op == 'sub' ? 'tirar' : 'somar'} → resposta {answer}.',
      xp: xp,
    );
  }

  static ExerciseTemplate _mc(
    String id,
    String bncc,
    String topic,
    int difficulty,
    String question,
    List<String> options,
    String answer,
    String boy,
    String girl, {
    int xp = 12,
  }) {
    return ExerciseTemplate(
      id: id,
      bncc: bncc,
      topic: topic,
      difficulty: difficulty,
      type: ExerciseType.multipleChoice,
      template: false,
      question: question,
      options: options,
      answer: answer,
      explainBoy: boy,
      explainGirl: girl,
      xp: xp,
    );
  }
}
