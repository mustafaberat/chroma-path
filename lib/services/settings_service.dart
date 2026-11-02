import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../config/app_config.dart';

enum ReduceMotionPref { system, on, off }

class SettingsService extends ChangeNotifier {
  SettingsService(this.prefs) {
    _load();
  }

  static Future<SettingsService> create() async => SettingsService(await SharedPreferences.getInstance());

  final SharedPreferences prefs;

  static const List<String> supportedLanguages = ['en', 'es', 'pt', 'zh', 'ja', 'de', 'fr', 'ko', 'it', 'tr'];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'pt': 'Português',
    'zh': '简体中文',
    'ja': '日本語',
    'de': 'Deutsch',
    'fr': 'Français',
    'ko': '한국어',
    'it': 'Italiano',
    'tr': 'Türkçe',
  };

  String? _language;
  bool _sound = true;
  bool _music = true;
  bool _haptics = true;
  ReduceMotionPref _reduceMotion = ReduceMotionPref.system;
  bool _onboardingDone = false;

  String? get language => _language;
  Locale? get locale => _language == null ? null : Locale(_language!);
  bool get sound => _sound;
  bool get music => _music;
  bool get haptics => _haptics;
  ReduceMotionPref get reduceMotion => _reduceMotion;
  bool get onboardingDone => _onboardingDone;

  bool reduceMotionFor(BuildContext context) => switch (_reduceMotion) {
    ReduceMotionPref.on => true,
    ReduceMotionPref.off => false,
    ReduceMotionPref.system => MediaQuery.maybeDisableAnimationsOf(context) ?? false,
  };

  void _load() {
    final lang = prefs.getString(PrefsKeys.language);
    _language = supportedLanguages.contains(lang) ? lang : null;
    _sound = prefs.getBool(PrefsKeys.sound) ?? true;
    _music = prefs.getBool(PrefsKeys.music) ?? true;
    _haptics = prefs.getBool(PrefsKeys.haptics) ?? true;
    _reduceMotion =
        _byName(ReduceMotionPref.values, prefs.getString(PrefsKeys.reduceMotion)) ?? ReduceMotionPref.system;
    _onboardingDone = prefs.getBool(PrefsKeys.onboardingDone) ?? false;
  }

  static T? _byName<T extends Enum>(List<T> values, String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }

  Future<void> setLanguage(String? code) async {
    if (code != _language) {
      AnalyticsService.instance.logSettingsChange(AnalyticsValues.language, code ?? 'system');
    }
    _language = code;
    notifyListeners();
    if (code == null) {
      await prefs.remove(PrefsKeys.language);
    } else {
      await prefs.setString(PrefsKeys.language, code);
    }
  }

  Future<void> setSound(bool value) async {
    if (value != _sound) {
      AnalyticsService.instance.logSettingsChange(AnalyticsValues.sound, value ? 'on' : 'off');
    }
    _sound = value;
    notifyListeners();
    await prefs.setBool(PrefsKeys.sound, value);
  }

  Future<void> setMusic(bool value) async {
    if (value != _music) {
      AnalyticsService.instance.logSettingsChange(AnalyticsValues.music, value ? 'on' : 'off');
    }
    _music = value;
    notifyListeners();
    await prefs.setBool(PrefsKeys.music, value);
  }

  Future<void> setHaptics(bool value) async {
    if (value != _haptics) {
      AnalyticsService.instance.logSettingsChange(AnalyticsValues.haptics, value ? 'on' : 'off');
    }
    _haptics = value;
    notifyListeners();
    await prefs.setBool(PrefsKeys.haptics, value);
  }

  Future<void> setReduceMotion(ReduceMotionPref value) async {
    if (value != _reduceMotion) {
      AnalyticsService.instance.logSettingsChange(AnalyticsValues.reduceMotion, value.name);
    }
    _reduceMotion = value;
    notifyListeners();
    await prefs.setString(PrefsKeys.reduceMotion, value.name);
  }

  Future<void> setOnboardingDone(bool value) async {
    _onboardingDone = value;
    await prefs.setBool(PrefsKeys.onboardingDone, value);
  }
}
