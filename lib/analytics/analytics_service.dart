/// Fire-and-forget analytics. A missing Firebase config or a failed send
/// drops the event. The game never waits on it.
library;

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics_events.dart';
import 'analytics_sink.dart';
import 'firebase_analytics_sink.dart';

typedef AnalyticsConnector = Future<AnalyticsSink> Function();

class AnalyticsService {
  AnalyticsService([this._sink]);

  static AnalyticsService instance = AnalyticsService();

  static const String prefsDeviceId = 'analytics_device_id';
  static const String prefsOpenCount = 'analytics_open_count';
  static const Duration _connectTimeout = Duration(seconds: 10);

  AnalyticsSink? _sink;
  bool _started = false;
  String? _deviceId;
  int _openCount = 0;

  bool get isEnabled => _sink != null;

  @visibleForTesting
  static void debugResetInstance() => instance = AnalyticsService();

  Future<void> start(SharedPreferences prefs, {AnalyticsConnector connect = connectFirebaseAnalytics}) async {
    if (_started) return;
    _started = true;
    try {
      _load(prefs);
    } catch (error) {
      debugPrint('analytics: prefs unavailable ($error)');
    }
    if (_sink == null) {
      try {
        _sink = await connect().timeout(_connectTimeout);
      } catch (error) {
        debugPrint('analytics: disabled ($error)');
        return;
      }
    }
    final id = _deviceId;
    if (id != null) {
      _send((sink) => sink.setUserId(id));
      _send((sink) => sink.setUserProperty('device_id', _clip(id, AnalyticsLimits.maxUserPropertyValue)));
    }
    logEvent(AnalyticsEvents.appOpen, {AnalyticsParams.deviceId: id, AnalyticsParams.openCount: _openCount});
  }

  void _load(SharedPreferences prefs) {
    var id = prefs.getString(prefsDeviceId);
    if (id == null || id.isEmpty) {
      id = newDeviceId();
      unawaited(prefs.setString(prefsDeviceId, id).catchError((_) => false));
    }
    _deviceId = id;
    _openCount = (prefs.getInt(prefsOpenCount) ?? 0) + 1;
    unawaited(prefs.setInt(prefsOpenCount, _openCount).catchError((_) => false));
  }

  void logEvent(String name, Map<String, Object?> params) {
    if (_sink == null) return;
    final clean = sanitizeParams(params);
    _send((sink) => sink.logEvent(_clip(name, AnalyticsLimits.maxName), clean));
  }

  void _send(Future<void> Function(AnalyticsSink sink) call) {
    final sink = _sink;
    if (sink == null) return;
    Timer.run(() {
      try {
        unawaited(call(sink).catchError((Object _) {}));
      } catch (_) {}
    });
  }

  void logScreen(String screen) => logEvent(AnalyticsEvents.screenOpen, {AnalyticsParams.screen: screen});

  void logPlayTap(int level) => logEvent(AnalyticsEvents.playTap, {AnalyticsParams.level: level});

  void logLevelStart(int level) => logEvent(AnalyticsEvents.levelStart, {AnalyticsParams.level: level});

  void logLevelEnd({
    required int level,
    required int durationSec,
    required int stars,
    required int hintsUsed,
    required int resetsUsed,
  }) {
    logEvent(AnalyticsEvents.levelEnd, {
      AnalyticsParams.level: level,
      AnalyticsParams.result: AnalyticsValues.clear,
      AnalyticsParams.durationSec: durationSec,
      AnalyticsParams.stars: stars,
      AnalyticsParams.hintsUsed: hintsUsed,
      AnalyticsParams.resetsUsed: resetsUsed,
    });
  }

  void logLevelQuit({required int level, required int durationSec, required String from}) {
    logEvent(AnalyticsEvents.levelQuit, {
      AnalyticsParams.level: level,
      AnalyticsParams.durationSec: durationSec,
      AnalyticsParams.from: from,
    });
  }

  void logSettingsOpen(String source) =>
      logEvent(AnalyticsEvents.settingsOpen, {AnalyticsParams.source: source});

  void logHowToPlayOpen(String source) =>
      logEvent(AnalyticsEvents.howToPlayOpen, {AnalyticsParams.source: source});

  void logSettingsChange(String setting, String value) => logEvent(AnalyticsEvents.settingsChange, {
    AnalyticsParams.setting: setting,
    AnalyticsParams.value: value,
  });

  static Map<String, Object> sanitizeParams(Map<String, Object?> raw) {
    final out = <String, Object>{};
    for (final entry in raw.entries) {
      if (out.length >= AnalyticsLimits.maxParams) break;
      final value = entry.value;
      if (value == null) continue;
      final key = _clip(entry.key, AnalyticsLimits.maxName);
      out[key] = switch (value) {
        bool flag => flag ? 1 : 0,
        num number => number,
        String text => _clip(text, AnalyticsLimits.maxStringValue),
        _ => _clip(value.toString(), AnalyticsLimits.maxStringValue),
      };
    }
    return out;
  }

  static String _clip(String text, int max) => text.length <= max ? text : text.substring(0, max);

  static String newDeviceId([Random? random]) {
    final source = random ?? Random.secure();
    final bytes = List<int>.generate(16, (_) => source.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((value) => value.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
