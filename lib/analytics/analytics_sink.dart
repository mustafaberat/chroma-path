/// Screens never talk to Firebase. Events go through this sink.
abstract class AnalyticsSink {
  Future<void> logEvent(String name, Map<String, Object> params);

  Future<void> setUserId(String id);

  Future<void> setUserProperty(String name, String value);
}
