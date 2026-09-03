class Profile {
  final int id;
  final String name;
  final int avatarIndex;
  final String gender; // boy | girl
  final int currentGrade;
  final int maxGrade;
  final String parentPin;
  final DateTime createdAt;

  const Profile({
    required this.id,
    required this.name,
    required this.avatarIndex,
    required this.gender,
    required this.currentGrade,
    required this.maxGrade,
    required this.parentPin,
    required this.createdAt,
  });

  bool get isBoy => gender == 'boy';

  Profile copyWith({
    String? name,
    int? avatarIndex,
    String? gender,
    int? currentGrade,
    int? maxGrade,
    String? parentPin,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      gender: gender ?? this.gender,
      currentGrade: currentGrade ?? this.currentGrade,
      maxGrade: maxGrade ?? this.maxGrade,
      parentPin: parentPin ?? this.parentPin,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'avatar_index': avatarIndex,
        'gender': gender,
        'current_grade': currentGrade,
        'max_grade': maxGrade,
        'parent_pin': parentPin,
        'created_at': createdAt.toIso8601String(),
      };

  factory Profile.fromMap(Map<String, Object?> map) => Profile(
        id: map['id'] as int,
        name: map['name'] as String,
        avatarIndex: map['avatar_index'] as int? ?? 0,
        gender: map['gender'] as String? ?? 'boy',
        currentGrade: map['current_grade'] as int? ?? 1,
        maxGrade: map['max_grade'] as int? ?? 5,
        parentPin: map['parent_pin'] as String? ?? '1234',
        createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ??
            DateTime.now(),
      );
}

class BudgetSettings {
  final int monthlyCapI9;
  final int pctDaily;
  final int pctExtras;
  final int pctMonthBonus;

  const BudgetSettings({
    this.monthlyCapI9 = 3000,
    this.pctDaily = 50,
    this.pctExtras = 20,
    this.pctMonthBonus = 30,
  });

  double get capReais => monthlyCapI9 / 100.0;

  int dailySlice(int daysInMonth) {
    if (daysInMonth <= 0) return 0;
    return ((monthlyCapI9 * pctDaily) / 100 / daysInMonth).floor();
  }

  int get extrasPool => (monthlyCapI9 * pctExtras / 100).floor();
  int get monthBonusPool => (monthlyCapI9 * pctMonthBonus / 100).floor();

  BudgetSettings copyWith({
    int? monthlyCapI9,
    int? pctDaily,
    int? pctExtras,
    int? pctMonthBonus,
  }) =>
      BudgetSettings(
        monthlyCapI9: monthlyCapI9 ?? this.monthlyCapI9,
        pctDaily: pctDaily ?? this.pctDaily,
        pctExtras: pctExtras ?? this.pctExtras,
        pctMonthBonus: pctMonthBonus ?? this.pctMonthBonus,
      );

  Map<String, Object?> toMap() => {
        'id': 1,
        'monthly_cap_i9': monthlyCapI9,
        'pct_daily': pctDaily,
        'pct_extras': pctExtras,
        'pct_month_bonus': pctMonthBonus,
      };

  factory BudgetSettings.fromMap(Map<String, Object?> map) => BudgetSettings(
        monthlyCapI9: map['monthly_cap_i9'] as int? ?? 3000,
        pctDaily: map['pct_daily'] as int? ?? 50,
        pctExtras: map['pct_extras'] as int? ?? 20,
        pctMonthBonus: map['pct_month_bonus'] as int? ?? 30,
      );
}

class FocusSettings {
  final bool enabledOnTest;
  final bool enabledOnChallenge;
  final bool voidWholeTestOnExit;
  final int maxExitsBeforeVoid;

  const FocusSettings({
    this.enabledOnTest = true,
    this.enabledOnChallenge = false,
    this.voidWholeTestOnExit = false,
    this.maxExitsBeforeVoid = 1,
  });

  FocusSettings copyWith({
    bool? enabledOnTest,
    bool? enabledOnChallenge,
    bool? voidWholeTestOnExit,
    int? maxExitsBeforeVoid,
  }) =>
      FocusSettings(
        enabledOnTest: enabledOnTest ?? this.enabledOnTest,
        enabledOnChallenge: enabledOnChallenge ?? this.enabledOnChallenge,
        voidWholeTestOnExit: voidWholeTestOnExit ?? this.voidWholeTestOnExit,
        maxExitsBeforeVoid: maxExitsBeforeVoid ?? this.maxExitsBeforeVoid,
      );

  Map<String, Object?> toMap() => {
        'id': 1,
        'enabled_on_test': enabledOnTest ? 1 : 0,
        'enabled_on_challenge': enabledOnChallenge ? 1 : 0,
        'void_whole_test_on_exit': voidWholeTestOnExit ? 1 : 0,
        'max_exits_before_void': maxExitsBeforeVoid,
      };

  factory FocusSettings.fromMap(Map<String, Object?> map) => FocusSettings(
        enabledOnTest: (map['enabled_on_test'] as int? ?? 1) == 1,
        enabledOnChallenge: (map['enabled_on_challenge'] as int? ?? 0) == 1,
        voidWholeTestOnExit: (map['void_whole_test_on_exit'] as int? ?? 0) == 1,
        maxExitsBeforeVoid: map['max_exits_before_void'] as int? ?? 1,
      );
}

class WalletState {
  final int balance;
  final int totalEarned;
  final int totalRedeemed;

  const WalletState({
    this.balance = 0,
    this.totalEarned = 0,
    this.totalRedeemed = 0,
  });

  double get balanceReais => balance / 100.0;

  WalletState copyWith({int? balance, int? totalEarned, int? totalRedeemed}) =>
      WalletState(
        balance: balance ?? this.balance,
        totalEarned: totalEarned ?? this.totalEarned,
        totalRedeemed: totalRedeemed ?? this.totalRedeemed,
      );
}

class WalletTransaction {
  final int id;
  final int amount;
  final String type;
  final String description;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  factory WalletTransaction.fromMap(Map<String, Object?> map) =>
      WalletTransaction(
        id: map['id'] as int,
        amount: map['amount'] as int,
        type: map['type'] as String,
        description: map['description'] as String? ?? '',
        createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ??
            DateTime.now(),
      );
}

class Achievement {
  final String key;
  final String title;
  final String description;
  final String icon;
  final DateTime? unlockedAt;

  const Achievement({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    this.unlockedAt,
  });

  bool get unlocked => unlockedAt != null;
}
