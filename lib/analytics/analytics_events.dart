class AnalyticsEvents {
  AnalyticsEvents._();

  static const appOpen = 'app_open';
  static const screenOpen = 'screen_open';
  static const playTap = 'play_tap';
  static const levelStart = 'level_start';
  static const levelEnd = 'level_end';
  static const levelQuit = 'level_quit';
  static const settingsOpen = 'settings_open';
  static const howToPlayOpen = 'how_to_play_open';
  static const settingsChange = 'settings_change';
}

class AnalyticsParams {
  AnalyticsParams._();

  static const deviceId = 'device_id';
  static const openCount = 'open_count';
  static const screen = 'screen';
  static const level = 'level';
  static const result = 'result';
  static const durationSec = 'duration_sec';
  static const stars = 'stars';
  static const hintsUsed = 'hints_used';
  static const resetsUsed = 'resets_used';
  static const from = 'from';
  static const source = 'source';
  static const setting = 'setting';
  static const value = 'value';
}

class AnalyticsValues {
  AnalyticsValues._();

  static const clear = 'clear';
  static const home = 'home';
  static const levels = 'levels';
  static const play = 'play';
  static const settings = 'settings';
  static const howTo = 'how_to_play';
  static const firstRun = 'first_run';
  static const back = 'back';
  static const language = 'language';
  static const sound = 'sound';
  static const music = 'music';
  static const haptics = 'haptics';
  static const reduceMotion = 'reduce_motion';
}

class AnalyticsLimits {
  AnalyticsLimits._();

  static const maxName = 40;
  static const maxParams = 25;
  static const maxStringValue = 100;
  static const maxUserPropertyValue = 36;
}
