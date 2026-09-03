import 'package:flutter/foundation.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/models/profile.dart';
import 'package:tabuadai9/services/achievement_service.dart';
import 'package:tabuadai9/services/database_service.dart';
import 'package:tabuadai9/services/wallet_service.dart';
import 'package:tabuadai9/theme/app_theme.dart';

class AppState extends ChangeNotifier {
  Profile? profile;
  BudgetSettings budget = const BudgetSettings();
  FocusSettings focus = const FocusSettings();
  WalletState wallet = const WalletState();
  List<WalletTransaction> transactions = [];
  Set<String> completedDays = {};
  int currentStreak = 0;
  int bestStreak = 0;
  List<Achievement> achievements = [];
  bool ready = false;
  bool dailyDoneToday = false;
  int earnedThisMonth = 0;

  GenderKit get genderKit =>
      (profile?.isBoy ?? true) ? GenderKit.boy : GenderKit.girl;

  CopyKit get copy => CopyKit(genderKit);
  AppTheme get theme => AppTheme(kit: genderKit);

  Future<void> bootstrap() async {
    await DatabaseService.instance.database;
    await _reloadAll();
    ready = true;
    notifyListeners();
  }

  Future<void> _reloadAll() async {
    final db = await DatabaseService.instance.database;
    final profiles = await db.query('profile', limit: 1);
    if (profiles.isNotEmpty) {
      profile = Profile.fromMap(profiles.first);
    } else {
      profile = null;
    }
    budget = await WalletService.instance.getBudget();
    final focusRows = await db.query('focus_settings', where: 'id = 1');
    if (focusRows.isNotEmpty) {
      focus = FocusSettings.fromMap(focusRows.first);
    }
    wallet = await WalletService.instance.getWallet();
    transactions = await WalletService.instance.transactions();
    completedDays = await WalletService.instance.completedDaysThisMonth();
    dailyDoneToday = await WalletService.instance.isDailyDone(DateTime.now());
    earnedThisMonth = await WalletService.instance.earnedThisMonth();
    achievements = await AchievementService.instance.all();

    final streakRows = await db.query('streaks', where: 'id = 1');
    if (streakRows.isNotEmpty) {
      currentStreak = streakRows.first['current_streak'] as int? ?? 0;
      bestStreak = streakRows.first['best_streak'] as int? ?? 0;
    }
  }

  Future<void> refresh() async {
    await _reloadAll();
    notifyListeners();
  }

  bool get hasProfile => profile != null;

  Future<void> createProfile({
    required String name,
    required String gender,
    required String pin,
    required int maxGrade,
    required int monthlyCapI9,
  }) async {
    final db = await DatabaseService.instance.database;
    await db.insert('profile', {
      'name': name.trim(),
      'avatar_index': gender == 'boy' ? 0 : 1,
      'gender': gender,
      'current_grade': 1,
      'max_grade': maxGrade,
      'parent_pin': pin,
      'created_at': DateTime.now().toIso8601String(),
    });
    await WalletService.instance.saveBudget(
      BudgetSettings(monthlyCapI9: monthlyCapI9),
    );
    await _reloadAll();
    notifyListeners();
  }

  Future<bool> validatePin(String pin) async {
    return profile?.parentPin == pin;
  }

  Future<void> updateProfile(Profile updated) async {
    final db = await DatabaseService.instance.database;
    await db.update('profile', updated.toMap(), where: 'id = ?', whereArgs: [updated.id]);
    await _reloadAll();
    notifyListeners();
  }

  Future<void> updateBudget(BudgetSettings next) async {
    await WalletService.instance.saveBudget(next);
    await _reloadAll();
    notifyListeners();
  }

  Future<void> updateFocus(FocusSettings next) async {
    final db = await DatabaseService.instance.database;
    await db.update('focus_settings', next.toMap(), where: 'id = 1');
    await _reloadAll();
    notifyListeners();
  }

  Future<int> redeemBalance() async {
    final amount = await WalletService.instance.redeemAll(
      description: 'Troca física com responsável',
    );
    await _reloadAll();
    notifyListeners();
    return amount;
  }

  Future<void> recordProgress({
    required GeneratedExercise exercise,
    required bool correct,
    required int grade,
    required String unit,
  }) async {
    final db = await DatabaseService.instance.database;
    final existing = await db.query(
      'progress',
      where: 'bncc_code = ? AND topic = ? AND unit = ? AND grade = ?',
      whereArgs: [exercise.bncc, exercise.topic, unit, grade],
    );
    if (existing.isEmpty) {
      await db.insert('progress', {
        'bncc_code': exercise.bncc,
        'topic': exercise.topic,
        'unit': unit,
        'grade': grade,
        'total_attempts': 1,
        'correct': correct ? 1 : 0,
        'best_streak': correct ? 1 : 0,
        'stars': correct ? 1 : 0,
        'last_played': DateTime.now().toIso8601String(),
      });
    } else {
      final row = existing.first;
      final attempts = (row['total_attempts'] as int? ?? 0) + 1;
      final corrects = (row['correct'] as int? ?? 0) + (correct ? 1 : 0);
      final ratio = corrects / attempts;
      final stars = ratio >= 0.9 ? 3 : ratio >= 0.7 ? 2 : ratio >= 0.4 ? 1 : 0;
      await db.update(
        'progress',
        {
          'total_attempts': attempts,
          'correct': corrects,
          'stars': stars,
          'last_played': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [row['id']],
      );
    }
  }

  Future<void> bumpStreak() async {
    final db = await DatabaseService.instance.database;
    final today = DateTime.now();
    final key =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final rows = await db.query('streaks', where: 'id = 1');
    final last = rows.first['last_study_date'] as String?;
    var current = rows.first['current_streak'] as int? ?? 0;
    var best = rows.first['best_streak'] as int? ?? 0;

    if (last == key) {
      return;
    }
    if (last != null) {
      final lastDate = DateTime.tryParse(last);
      final yesterday = today.subtract(const Duration(days: 1));
      final yKey =
          '${yesterday.year.toString().padLeft(4, '0')}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      if (last == yKey ||
          (lastDate != null &&
              lastDate.year == yesterday.year &&
              lastDate.month == yesterday.month &&
              lastDate.day == yesterday.day)) {
        current += 1;
      } else {
        current = 1;
      }
    } else {
      current = 1;
    }
    if (current > best) best = current;
    await db.update(
      'streaks',
      {
        'current_streak': current,
        'best_streak': best,
        'last_study_date': key,
      },
      where: 'id = 1',
    );
    if (current >= 3) await AchievementService.instance.unlock('streak_3');
    if (current >= 7) await AchievementService.instance.unlock('streak_7');
  }

  Future<List<String>> finishSessionRewards({
    required SessionMode mode,
    required int correct,
    required int total,
    required bool focusClean,
  }) async {
    final unlocked = <String>[];
    await bumpStreak();

    if (correct > 0) {
      if (await AchievementService.instance.unlock('first_correct')) {
        unlocked.add('first_correct');
      }
    }
    if (mode == SessionMode.daily) {
      final awarded = await WalletService.instance.completeDailyTask();
      if (awarded >= 0) {
        if (await AchievementService.instance.unlock('first_task')) {
          unlocked.add('first_task');
        }
      }
      final days = await WalletService.instance.completedDaysThisMonth();
      if (days.length >= 10) {
        if (await AchievementService.instance.unlock('daily_10')) {
          unlocked.add('daily_10');
        }
      }
    } else {
      await WalletService.instance.awardSessionExtra(
        mode: mode.name,
        correct: correct,
        total: total,
      );
    }

    if (correct == total && total > 0) {
      if (mode == SessionMode.test) {
        if (await AchievementService.instance.unlock('perfect_test')) {
          unlocked.add('perfect_test');
        }
      } else if (mode == SessionMode.quiz) {
        if (await AchievementService.instance.unlock('perfect_quiz')) {
          unlocked.add('perfect_quiz');
        }
      }
    }
    if (mode == SessionMode.challenge) {
      if (await AchievementService.instance.unlock('challenge_win')) {
        unlocked.add('challenge_win');
      }
    }
    if (mode == SessionMode.review) {
      if (await AchievementService.instance.unlock('review_master')) {
        unlocked.add('review_master');
      }
    }
    if (focusClean && mode == SessionMode.test) {
      if (await AchievementService.instance.unlock('focus_clean')) {
        unlocked.add('focus_clean');
      }
    }

    final w = await WalletService.instance.getWallet();
    if (w.totalEarned >= 100) {
      if (await AchievementService.instance.unlock('i9_100')) {
        unlocked.add('i9_100');
      }
    }
    if (w.totalEarned >= 500) {
      if (await AchievementService.instance.unlock('i9_500')) {
        unlocked.add('i9_500');
      }
    }

    await _reloadAll();
    notifyListeners();
    return unlocked;
  }

  Future<void> logFocusEvent({
    required String sessionId,
    required String mode,
    required String action,
  }) async {
    final db = await DatabaseService.instance.database;
    await db.insert('focus_events', {
      'session_id': sessionId,
      'mode': mode,
      'exited_at': DateTime.now().toIso8601String(),
      'action_taken': action,
    });
  }

  Future<List<Map<String, Object?>>> focusEvents({int limit = 30}) async {
    final db = await DatabaseService.instance.database;
    return db.query('focus_events', orderBy: 'exited_at DESC', limit: limit);
  }

  Future<List<Map<String, Object?>>> progressRows() async {
    final db = await DatabaseService.instance.database;
    return db.query('progress', orderBy: 'last_played DESC');
  }
}
