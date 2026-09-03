import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tabuadai9/models/exercise.dart';

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

  Future<List<GeneratedExercise>> buildSession({
    required int grade,
    required String unit,
    required SessionMode mode,
    int count = 5,
  }) async {
    final templates = await loadExercises(grade, unit);
    if (templates.isEmpty) return [];

    final shuffled = List<ExerciseTemplate>.from(templates)..shuffle();
    final take = mode == SessionMode.test
        ? (count.clamp(8, 12))
        : mode == SessionMode.challenge
            ? (count.clamp(6, 10))
            : mode == SessionMode.daily
                ? (count.clamp(4, 6))
                : count;

    return shuffled.take(take).map((t) => t.generate()).toList();
  }

  Future<List<GeneratedExercise>> buildReviewSession({
    required int maxGrade,
    int count = 6,
  }) async {
    final all = <ExerciseTemplate>[];
    for (var g = 1; g <= maxGrade; g++) {
      for (final s in subjects) {
        all.addAll(await loadExercises(g, s.id));
      }
    }
    if (all.isEmpty) return [];
    all.shuffle();
    return all.take(count).map((t) => t.generate()).toList();
  }
}
