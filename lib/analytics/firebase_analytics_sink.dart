import 'analytics_sink.dart';

/// Firebase disabled in this build.
Future<AnalyticsSink> connectFirebaseAnalytics() async {
  throw UnsupportedError('Firebase disabled - no real Firebase project configured');
}

class FirebaseAnalyticsSink implements AnalyticsSink {
  @override
  Future<void> logEvent(String name, Map<String, Object> params) async {}

  @override
  Future<void> setUserId(String id) async {}

  @override
  Future<void> setUserProperty(String name, String value) async {}
}
