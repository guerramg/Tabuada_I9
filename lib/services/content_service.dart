import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tabuadai9/models/exercise.dart';
import 'package:tabuadai9/services/session_mix.dart';

class ContentService {
  ContentService._();
  static final ContentService instance = ContentService._();

  final Map<String, LessonContent> _lessonCache = {};
  final Map<String, List<ExerciseTemplate>> _exerciseCache = {};

  String _key(int grade, String unit) => 'ano$grade/$unit';

  Future<LessonContent?> loadLesson(int grade, String unit) async {
    final key = _key(grade, unit);
    if (_lessonCache.containsKey(key)) return _lessonCache[key];
    try {
      final raw =
          await rootBundle.loadString('assets/content/$key/lesson.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final lesson = LessonContent.fromJson(json);
      _lessonCache[key] = lesson;
      return lesson;
    } catch (_) {
      return null;
    }
  }

  Future<List<ExerciseTemplate>> loadExercises(int grade, String unit) async {
    final key = _key(grade, unit);
    if (_exerciseCache.containsKey(key)) return _exerciseCache[key]!;
    try {
      final raw =
          await rootBundle.loadString('assets/content/$key/exercises.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final list = ((json['exercises'] as List?) ?? [])
          .map((e) =>
              ExerciseTemplate.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      _exerciseCache[key] = list;
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<List<ExerciseTemplate>> _poolForGrade(
    int grade, {
    String? unit,
  }) async {
    if (unit != null && unit != 'revisao') {
      return loadExercises(grade, unit);
    }
    final all = <ExerciseTemplate>[];
    for (final s in subjects) {
      all.addAll(await loadExercises(grade, s.id));
    }
    return all;
  }

  int _sessionSize(SessionMode mode, int count) {
    return mode == SessionMode.test
        ? (count.clamp(8, 12))
        : mode == SessionMode.challenge
            ? (count.clamp(6, 10))
            : mode == SessionMode.daily
                ? (count.clamp(4, 6))
                : count;
  }

  Future<List<GeneratedExercise>> buildSession({
    required int focusGrade,
    int? maxGrade,
    String? unit,
    required SessionMode mode,
    int count = 5,
    @Deprecated('Use focusGrade') int? grade,
  }) async {
    final focus = (grade ?? focusGrade).clamp(1, 9).toInt();
    final ceiling = (maxGrade ?? focus).clamp(1, 9).toInt();
    final year = focus > ceiling ? ceiling : focus;
    final take = _sessionSize(mode, count);

    final focusPool = await _poolForGrade(year, unit: unit);
    final belowPool = <ExerciseTemplate>[];
    for (var g = 1; g < year; g++) {
      belowPool.addAll(await _poolForGrade(g, unit: unit));
    }

    final picked = SessionMix.pick(
      focusPool: focusPool,
      belowPool: belowPool,
      take: take,
      focusGrade: year,
    );
    if (picked.isEmpty) return [];
    return picked.map((t) => t.generate()).toList();
  }

  Future<List<GeneratedExercise>> buildReviewSession({
    required int focusGrade,
    required int maxGrade,
    int count = 6,
  }) {
    return buildSession(
      focusGrade: focusGrade,
      maxGrade: maxGrade,
      mode: SessionMode.review,
      count: count,
    );
  }
}
