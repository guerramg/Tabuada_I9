import 'package:tabuadai9/models/profile.dart';
import 'package:tabuadai9/services/database_service.dart';

class AchievementDef {
  final String key;
  final String title;
  final String description;
  final String icon;

  const AchievementDef(this.key, this.title, this.description, this.icon);
}

const achievementCatalog = <AchievementDef>[
  AchievementDef('first_task', 'Primeira Tarefa', 'Completou a primeira tarefa do dia', '🚀'),
  AchievementDef('first_correct', 'Primeira Resposta', 'Acertou a primeira questão', '✅'),
  AchievementDef('streak_3', '3 Dias Seguidos', 'Estudou 3 dias seguidos', '🔥'),
  AchievementDef('streak_7', '7 Dias Seguidos', 'Uma semana de foco!', '⚡'),
  AchievementDef('perfect_quiz', 'Sem Erros', 'Zerou erros em um quiz', '🎯'),
  AchievementDef('perfect_test', 'Prova Impecável', 'Acertou tudo na prova', '🏆'),
  AchievementDef('i9_100', '100 I9\$', 'Acumulou 100 I9\$ ganhos', '💰'),
  AchievementDef('i9_500', '500 I9\$', 'Acumulou 500 I9\$ ganhos', '💎'),
  AchievementDef('month_complete', 'Mês Completo', 'Completou todas as tarefas do mês', '📅'),
  AchievementDef('five_subjects', '5 Matérias', 'Praticou as 5 unidades BNCC', '📚'),
  AchievementDef('focus_clean', 'Foco Total', 'Terminou uma prova sem sair do app', '🧘'),
  AchievementDef('review_master', 'Modo Revisão', 'Fez uma sessão de revisão', '🔁'),
  AchievementDef('daily_10', '10 Tarefas', 'Completou 10 tarefas diárias', '⭐'),
  AchievementDef('challenge_win', 'Desafio Feito', 'Concluiu um desafio', '💪'),
  AchievementDef('stars_9', '9 Estrelas', 'Somou 9 estrelas em tópicos', '🌟'),
  AchievementDef('grade_up', 'Subiu de Nível', 'Avançou no mapa de matérias', '📈'),
  AchievementDef('algebra_fan', 'Álgebra Roots', 'Praticou álgebra 5 vezes', '🧩'),
  AchievementDef('geo_fan', 'Geo Lover', 'Praticou geometria 5 vezes', '📐'),
  AchievementDef('stats_fan', 'Dado Master', 'Praticou probabilidade 5 vezes', '🎲'),
  AchievementDef('night_owl', 'Madrugador', 'Estudou antes das 8h', '🌅'),
];

class AchievementService {
  AchievementService._();
  static final AchievementService instance = AchievementService._();

  Future<Set<String>> unlockedKeys() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('achievements');
    return rows.map((e) => e['achievement_key'] as String).toSet();
  }

  Future<List<Achievement>> all() async {
    final unlocked = await unlockedKeys();
    final db = await DatabaseService.instance.database;
    final rows = await db.query('achievements');
    final dates = {
      for (final r in rows)
        r['achievement_key'] as String:
            DateTime.tryParse(r['unlocked_at'] as String? ?? '')
    };
    return achievementCatalog
        .map(
          (d) => Achievement(
            key: d.key,
            title: d.title,
            description: d.description,
            icon: d.icon,
            unlockedAt: unlocked.contains(d.key) ? dates[d.key] : null,
          ),
        )
        .toList();
  }

  Future<bool> unlock(String key) async {
    final existing = await unlockedKeys();
    if (existing.contains(key)) return false;
    final db = await DatabaseService.instance.database;
    await db.insert('achievements', {
      'achievement_key': key,
      'unlocked_at': DateTime.now().toIso8601String(),
    });
    return true;
  }
}
