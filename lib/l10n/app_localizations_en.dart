// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Color Links';

  @override
  String get homeTagline => 'Connect every color.';

  @override
  String get play => 'Play';

  @override
  String get levels => 'Levels';

  @override
  String get settings => 'Settings';

  @override
  String get howToPlay => 'How to play';

  @override
  String get howToLine => 'Drag between two matching dots and fill the board.';

  @override
  String get skip => 'Skip';

  @override
  String get back => 'Back';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String progressLabel(int current, int total) {
    return 'Level $current of $total';
  }

  @override
  String get nextLevel => 'Next level';

  @override
  String get levelClear => 'Board filled';

  @override
  String get allClear => 'Every level is filled';

  @override
  String get playAgain => 'Play again';

  @override
  String get undo => 'Undo';

  @override
  String get reset => 'Reset';

  @override
  String get hint => 'Hint';

  @override
  String get lockedLevel => 'Locked';

  @override
  String starsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsGame => 'Game';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'Device language';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsMusic => 'Music';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsAccessibility => 'Accessibility';

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get motionSystem => 'System';

  @override
  String get motionOn => 'On';

  @override
  String get motionOff => 'Off';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsVersion => 'Version';

  @override
  String get openFailed => 'Could not open the page.';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => 'Reset progress';

  @override
  String get resetProgressBody => 'Completed levels will be cleared.';

  @override
  String get cancel => 'Cancel';

  @override
  String get resetAction => 'Reset';

  @override
  String get boardLabel => 'Puzzle board';

  @override
  String get soundOn => 'Sound on';

  @override
  String get soundOff => 'Sound off';

  @override
  String get musicOn => 'Music on';

  @override
  String get musicOff => 'Music off';

  @override
  String get currentLevel => 'Current level';

  @override
  String get clearBoard => 'Clear the board?';

  @override
  String get clearBoardYes => 'Clear';
}
