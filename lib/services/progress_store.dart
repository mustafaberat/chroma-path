import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../game/levels.dart';

class PuzzleDraft {
  const PuzzleDraft({required this.levelIndex, required this.paths, required this.hints, required this.resets});

  final int levelIndex;
  final List<List<int>> paths;
  final int hints;
  final int resets;

  Map<String, Object> toJson() => {'level': levelIndex, 'hints': hints, 'resets': resets, 'paths': paths};

  static PuzzleDraft? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map) return null;
      final pathsRaw = json['paths'];
      if (pathsRaw is! List) return null;
      final paths = <List<int>>[];
      for (final item in pathsRaw) {
        if (item is! List) return null;
        final path = <int>[];
        for (final cell in item) {
          if (cell is! int) return null;
          path.add(cell);
        }
        paths.add(path);
      }
      final level = json['level'];
      if (level is! int) return null;
      return PuzzleDraft(
        levelIndex: level,
        paths: paths,
        hints: json['hints'] is int ? json['hints'] as int : 0,
        resets: json['resets'] is int ? json['resets'] as int : 0,
      );
    } catch (_) {
      return null;
    }
  }
}

class ProgressStore extends ChangeNotifier {
  ProgressStore(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;

  late List<int> stars;
  PuzzleDraft? draft;

  int get frontier {
    final index = stars.indexOf(0);
    return index < 0 ? stars.length : index;
  }

  bool get finishedAll => frontier >= stars.length;

  int get currentNumber => finishedAll ? stars.length : frontier + 1;

  bool isUnlocked(int index) => index >= 0 && index < stars.length && index <= frontier;

  bool isComplete(int index) => index >= 0 && index < stars.length && stars[index] > 0;

  void _load() {
    stars = List<int>.filled(Levels.all.length, 0);
    final raw = _prefs.getString(PrefsKeys.stars);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (var i = 0; i < decoded.length && i < stars.length; i++) {
            final value = decoded[i];
            if (value is int && value >= 0 && value <= 3) stars[i] = value;
          }
        }
      } catch (_) {}
    }
    draft = PuzzleDraft.tryParse(_prefs.getString(PrefsKeys.draft));
  }

  Future<void> markComplete(int index, int earned) async {
    if (index < 0 || index >= stars.length) return;
    if (earned > stars[index]) stars[index] = earned.clamp(1, 3);
    draft = null;
    notifyListeners();
    await _prefs.setString(PrefsKeys.stars, jsonEncode(stars));
    await _prefs.remove(PrefsKeys.draft);
  }

  Future<void> saveDraft(PuzzleDraft value) async {
    draft = value;
    await _prefs.setString(PrefsKeys.draft, jsonEncode(value.toJson()));
  }

  Future<void> clearDraft() async {
    draft = null;
    await _prefs.remove(PrefsKeys.draft);
  }

  Future<void> resetAll() async {
    stars = List<int>.filled(Levels.all.length, 0);
    draft = null;
    notifyListeners();
    await _prefs.setString(PrefsKeys.stars, jsonEncode(stars));
    await _prefs.remove(PrefsKeys.draft);
  }
}
