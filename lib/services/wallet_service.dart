import 'package:tabuadai9/models/profile.dart';
import 'package:tabuadai9/services/database_service.dart';

class WalletService {
  WalletService._();
  static final WalletService instance = WalletService._();

  Future<WalletState> getWallet() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('wallet', where: 'id = 1');
    if (rows.isEmpty) return const WalletState();
    final row = rows.first;
    return WalletState(
      balance: row['balance'] as int? ?? 0,
      totalEarned: row['total_earned'] as int? ?? 0,
      totalRedeemed: row['total_redeemed'] as int? ?? 0,
    );
  }

  Future<BudgetSettings> getBudget() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('budget_settings', where: 'id = 1');
    if (rows.isEmpty) return const BudgetSettings();
    return BudgetSettings.fromMap(rows.first);
  }

  Future<void> saveBudget(BudgetSettings budget) async {
    final db = await DatabaseService.instance.database;
    await db.update('budget_settings', budget.toMap(), where: 'id = 1');
  }

  Future<int> earnedThisMonth() async {
    final db = await DatabaseService.instance.database;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1).toIso8601String();
    final rows = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(amount), 0) as total
      FROM transactions
      WHERE amount > 0 AND created_at >= ?
      ''',
      [start],
    );
    return (rows.first['total'] as int?) ?? 0;
  }

  Future<int> remainingCap() async {
    final budget = await getBudget();
    final earned = await earnedThisMonth();
    final left = budget.monthlyCapI9 - earned;
    return left < 0 ? 0 : left;
  }

  Future<int> credit({
    required int requested,
    required String type,
    required String description,
  }) async {
    if (requested <= 0) return 0;
    final left = await remainingCap();
    final amount = requested > left ? left : requested;
    if (amount <= 0) return 0;

    final db = await DatabaseService.instance.database;
    await db.transaction((txn) async {
      final wallet = await txn.query('wallet', where: 'id = 1');
      final balance = (wallet.first['balance'] as int? ?? 0) + amount;
      final earned = (wallet.first['total_earned'] as int? ?? 0) + amount;
      await txn.update(
        'wallet',
        {'balance': balance, 'total_earned': earned},
        where: 'id = 1',
      );
      await txn.insert('transactions', {
        'amount': amount,
        'type': type,
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
      });
    });
    return amount;
  }

  Future<int> redeemAll({required String description}) async {
    final db = await DatabaseService.instance.database;
    var redeemed = 0;
    await db.transaction((txn) async {
      final wallet = await txn.query('wallet', where: 'id = 1');
      final balance = wallet.first['balance'] as int? ?? 0;
      if (balance <= 0) return;
      redeemed = balance;
      final totalRedeemed =
          (wallet.first['total_redeemed'] as int? ?? 0) + balance;
      await txn.update(
        'wallet',
        {'balance': 0, 'total_redeemed': totalRedeemed},
        where: 'id = 1',
      );
      await txn.insert('transactions', {
        'amount': -balance,
        'type': 'redeem',
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
      });
    });
    return redeemed;
  }

  Future<List<WalletTransaction>> transactions({int limit = 50}) async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query(
      'transactions',
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return rows.map(WalletTransaction.fromMap).toList();
  }

  Future<bool> isDailyDone(DateTime day) async {
    final db = await DatabaseService.instance.database;
    final key = _dayKey(day);
    final rows =
        await db.query('daily_tasks', where: 'date = ?', whereArgs: [key]);
    return rows.isNotEmpty && rows.first['completed_at'] != null;
  }

  Future<Set<String>> completedDaysThisMonth() async {
    final now = DateTime.now();
    final prefix =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
    final db = await DatabaseService.instance.database;
    final rows = await db.query(
      'daily_tasks',
      where: "date LIKE ? AND completed_at IS NOT NULL",
      whereArgs: ['$prefix%'],
    );
    return rows.map((e) => e['date'] as String).toSet();
  }

  Future<int> completeDailyTask() async {
    final now = DateTime.now();
    final key = _dayKey(now);
    if (await isDailyDone(now)) return 0;

    final budget = await getBudget();
    final days = DateTime(now.year, now.month + 1, 0).day;
    final slice = budget.dailySlice(days);

    final awarded = await credit(
      requested: slice,
      type: 'daily',
      description: 'Tarefa do dia $key',
    );

    final db = await DatabaseService.instance.database;
    await db.insert('daily_tasks', {
      'date': key,
      'completed_at': now.toIso8601String(),
      'i9_awarded': awarded,
    });

    // Month bonus if all days completed at month end (or all days so far if last day)
    if (now.day == days) {
      final done = await completedDaysThisMonth();
      if (done.length >= days) {
        await credit(
          requested: budget.monthBonusPool,
          type: 'month_bonus',
          description: 'Bônus de mês completo!',
        );
      }
    }

    return awarded;
  }

  Future<int> awardSessionExtra({
    required String mode,
    required int correct,
    required int total,
  }) async {
    if (total <= 0 || correct <= 0) return 0;
    final budget = await getBudget();
    final ratio = correct / total;
    // Extra pool split across many sessions; per-session chunk by mode.
    final base = switch (mode) {
      'test' => (budget.extrasPool * 0.12).round(),
      'challenge' => (budget.extrasPool * 0.08).round(),
      'quiz' => (budget.extrasPool * 0.05).round(),
      _ => (budget.extrasPool * 0.03).round(),
    };
    final requested = (base * ratio).round().clamp(1, base);
    return credit(
      requested: requested,
      type: '${mode}_extra',
      description: 'Extra $mode ($correct/$total)',
    );
  }

  String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
