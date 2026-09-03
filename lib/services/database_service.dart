import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<void> _initFactory() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> _open() async {
    await _initFactory();

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'mathi9_kids.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            avatar_index INTEGER NOT NULL DEFAULT 0,
            gender TEXT NOT NULL DEFAULT 'boy',
            current_grade INTEGER NOT NULL DEFAULT 1,
            max_grade INTEGER NOT NULL DEFAULT 5,
            parent_pin TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE budget_settings (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            monthly_cap_i9 INTEGER NOT NULL DEFAULT 3000,
            pct_daily INTEGER NOT NULL DEFAULT 50,
            pct_extras INTEGER NOT NULL DEFAULT 20,
            pct_month_bonus INTEGER NOT NULL DEFAULT 30
          )
        ''');
        await db.execute('''
          CREATE TABLE focus_settings (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            enabled_on_test INTEGER NOT NULL DEFAULT 1,
            enabled_on_challenge INTEGER NOT NULL DEFAULT 0,
            void_whole_test_on_exit INTEGER NOT NULL DEFAULT 0,
            max_exits_before_void INTEGER NOT NULL DEFAULT 1
          )
        ''');
        await db.execute('''
          CREATE TABLE wallet (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            balance INTEGER NOT NULL DEFAULT 0,
            total_earned INTEGER NOT NULL DEFAULT 0,
            total_redeemed INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount INTEGER NOT NULL,
            type TEXT NOT NULL,
            description TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE daily_tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            completed_at TEXT,
            i9_awarded INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE progress (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bncc_code TEXT NOT NULL,
            topic TEXT NOT NULL,
            unit TEXT NOT NULL,
            grade INTEGER NOT NULL,
            total_attempts INTEGER NOT NULL DEFAULT 0,
            correct INTEGER NOT NULL DEFAULT 0,
            best_streak INTEGER NOT NULL DEFAULT 0,
            stars INTEGER NOT NULL DEFAULT 0,
            last_played TEXT,
            UNIQUE(bncc_code, topic, unit, grade)
          )
        ''');
        await db.execute('''
          CREATE TABLE focus_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id TEXT NOT NULL,
            mode TEXT NOT NULL,
            exited_at TEXT NOT NULL,
            action_taken TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE achievements (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            achievement_key TEXT NOT NULL UNIQUE,
            unlocked_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE streaks (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            current_streak INTEGER NOT NULL DEFAULT 0,
            best_streak INTEGER NOT NULL DEFAULT 0,
            last_study_date TEXT
          )
        ''');
        await db.insert('budget_settings', {
          'id': 1,
          'monthly_cap_i9': 3000,
          'pct_daily': 50,
          'pct_extras': 20,
          'pct_month_bonus': 30,
        });
        await db.insert('focus_settings', {
          'id': 1,
          'enabled_on_test': 1,
          'enabled_on_challenge': 0,
          'void_whole_test_on_exit': 0,
          'max_exits_before_void': 1,
        });
        await db.insert('wallet', {
          'id': 1,
          'balance': 0,
          'total_earned': 0,
          'total_redeemed': 0,
        });
        await db.insert('streaks', {
          'id': 1,
          'current_streak': 0,
          'best_streak': 0,
          'last_study_date': null,
        });
      },
    );
  }
}
