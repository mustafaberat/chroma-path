import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import 'analytics_sink.dart';

/// Throws when `google-services.json` is missing. The service then stays off.
Future<AnalyticsSink> connectFirebaseAnalytics() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  return FirebaseAnalyticsSink(FirebaseAnalytics.instance);
}

class FirebaseAnalyticsSink implements AnalyticsSink {
  FirebaseAnalyticsSink(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent(String name, Map<String, Object> params) =>
      _analytics.logEvent(name: name, parameters: params);

  @override
  Future<void> setUserId(String id) => _analytics.setUserId(id: id);

  @override
  Future<void> setUserProperty(String name, String value) => _analytics.setUserProperty(name: name, value: value);
}
