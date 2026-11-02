abstract final class AppIdentity {
  static const String appName = 'ChromaPath: Connect Puzzle';
  static const String developer = 'ARU Soft';
  static const String packageId = 'com.arusoft.chromapath';
  static const String privacyUrl = 'https://arusoft.vercel.app/privacy/chroma-path';
}

abstract final class AppRoutes {
  static const String settings = '/settings';
  static const String howTo = '/how-to';
  static const String play = '/play';
  static const String levels = '/levels';
}

abstract final class PrefsKeys {
  static const String language = 'language';
  static const String sound = 'sound';
  static const String music = 'music';
  static const String haptics = 'haptics';
  static const String reduceMotion = 'reduce_motion';
  static const String onboardingDone = 'onboarding_done';
  static const String stars = 'progress_stars';
  static const String draft = 'progress_draft';
}
