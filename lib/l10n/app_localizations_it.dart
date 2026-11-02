// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Color Links';

  @override
  String get homeTagline => 'Collega ogni colore.';

  @override
  String get play => 'Gioca';

  @override
  String get levels => 'Livelli';

  @override
  String get settings => 'Impostazioni';

  @override
  String get howToPlay => 'Come si gioca';

  @override
  String get howToLine => 'Trascina tra due punti uguali e riempi la griglia.';

  @override
  String get skip => 'Salta';

  @override
  String get back => 'Indietro';

  @override
  String levelLabel(int level) {
    return 'Livello $level';
  }

  @override
  String progressLabel(int current, int total) {
    return 'Livello $current di $total';
  }

  @override
  String get nextLevel => 'Livello successivo';

  @override
  String get levelClear => 'Griglia piena';

  @override
  String get allClear => 'Tutti i livelli sono pieni';

  @override
  String get playAgain => 'Gioca di nuovo';

  @override
  String get undo => 'Annulla';

  @override
  String get reset => 'Ricomincia';

  @override
  String get hint => 'Suggerimento';

  @override
  String get lockedLevel => 'Bloccato';

  @override
  String starsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stelle',
      one: '1 stella',
    );
    return '$_temp0';
  }

  @override
  String get settingsGeneral => 'Generali';

  @override
  String get settingsGame => 'Gioco';

  @override
  String get settingsAbout => 'Info';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Lingua del dispositivo';

  @override
  String get settingsSound => 'Suono';

  @override
  String get settingsMusic => 'Musica';

  @override
  String get settingsHaptics => 'Vibrazione';

  @override
  String get settingsAccessibility => 'Accessibilità';

  @override
  String get settingsReduceMotion => 'Riduci i movimenti';

  @override
  String get motionSystem => 'Sistema';

  @override
  String get motionOn => 'Sì';

  @override
  String get motionOff => 'No';

  @override
  String get settingsPrivacy => 'Informativa privacy';

  @override
  String get settingsVersion => 'Versione';

  @override
  String get openFailed => 'Impossibile aprire la pagina.';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => 'Azzera i progressi';

  @override
  String get resetProgressBody => 'I livelli completati saranno cancellati.';

  @override
  String get cancel => 'Annulla';

  @override
  String get resetAction => 'Azzera';

  @override
  String get boardLabel => 'Griglia';

  @override
  String get soundOn => 'Suono attivo';

  @override
  String get soundOff => 'Suono disattivo';

  @override
  String get musicOn => 'Musica attiva';

  @override
  String get musicOff => 'Musica disattiva';

  @override
  String get currentLevel => 'Livello attuale';

  @override
  String get clearBoard => 'Pulire la griglia?';

  @override
  String get clearBoardYes => 'Pulisci';
}
