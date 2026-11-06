// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ChromaPath: Connect Puzzle';

  @override
  String get homeTagline => 'Verbinde jede Farbe.';

  @override
  String get play => 'Spielen';

  @override
  String get levels => 'Level';

  @override
  String get settings => 'Einstellungen';

  @override
  String get howToPlay => 'So geht\'s';

  @override
  String get howToLine =>
      'Ziehe zwischen zwei gleichen Punkten und fülle das Feld.';

  @override
  String get skip => 'Überspringen';

  @override
  String get back => 'Zurück';

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String progressLabel(int current, int total) {
    return 'Level $current von $total';
  }

  @override
  String get nextLevel => 'Nächstes Level';

  @override
  String get levelClear => 'Feld gefüllt';

  @override
  String get levelCompliment => 'Sieht lecker aus!';

  @override
  String get allClear => 'Jedes Level ist gefüllt';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get hint => 'Hinweis';

  @override
  String get lockedLevel => 'Gesperrt';

  @override
  String starsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sterne',
      one: '1 Stern',
    );
    return '$_temp0';
  }

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsGame => 'Spiel';

  @override
  String get settingsAbout => 'Info';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Gerätesprache';

  @override
  String get settingsSound => 'Ton';

  @override
  String get settingsMusic => 'Musik';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsAccessibility => 'Bedienungshilfen';

  @override
  String get settingsReduceMotion => 'Bewegung reduzieren';

  @override
  String get motionSystem => 'System';

  @override
  String get motionOn => 'An';

  @override
  String get motionOff => 'Aus';

  @override
  String get settingsPrivacy => 'Datenschutz';

  @override
  String get settingsVersion => 'Version';

  @override
  String get openFailed => 'Die Seite konnte nicht geöffnet werden.';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => 'Fortschritt löschen';

  @override
  String get resetProgressBody => 'Abgeschlossene Level werden gelöscht.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get resetAction => 'Löschen';

  @override
  String get boardLabel => 'Spielfeld';

  @override
  String get soundOn => 'Ton an';

  @override
  String get soundOff => 'Ton aus';

  @override
  String get musicOn => 'Musik an';

  @override
  String get musicOff => 'Musik aus';

  @override
  String get currentLevel => 'Aktuelles Level';

  @override
  String get clearBoard => 'Feld leeren?';

  @override
  String get clearBoardYes => 'Leeren';
}
