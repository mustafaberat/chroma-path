// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Color Links';

  @override
  String get homeTagline => 'Relie chaque couleur.';

  @override
  String get play => 'Jouer';

  @override
  String get levels => 'Niveaux';

  @override
  String get settings => 'Réglages';

  @override
  String get howToPlay => 'Comment jouer';

  @override
  String get howToLine => 'Relie deux points identiques et remplis la grille.';

  @override
  String get skip => 'Passer';

  @override
  String get back => 'Retour';

  @override
  String levelLabel(int level) {
    return 'Niveau $level';
  }

  @override
  String progressLabel(int current, int total) {
    return 'Niveau $current sur $total';
  }

  @override
  String get nextLevel => 'Niveau suivant';

  @override
  String get levelClear => 'Grille remplie';

  @override
  String get allClear => 'Tous les niveaux sont remplis';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get undo => 'Annuler';

  @override
  String get reset => 'Recommencer';

  @override
  String get hint => 'Indice';

  @override
  String get lockedLevel => 'Verrouillé';

  @override
  String starsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count étoiles',
      one: '1 étoile',
    );
    return '$_temp0';
  }

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsGame => 'Jeu';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Langue de l\'appareil';

  @override
  String get settingsSound => 'Son';

  @override
  String get settingsMusic => 'Musique';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsAccessibility => 'Accessibilité';

  @override
  String get settingsReduceMotion => 'Réduire les animations';

  @override
  String get motionSystem => 'Système';

  @override
  String get motionOn => 'Oui';

  @override
  String get motionOff => 'Non';

  @override
  String get settingsPrivacy => 'Politique de confidentialité';

  @override
  String get settingsVersion => 'Version';

  @override
  String get openFailed => 'Impossible d\'ouvrir la page.';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => 'Effacer la progression';

  @override
  String get resetProgressBody => 'Les niveaux terminés seront effacés.';

  @override
  String get cancel => 'Annuler';

  @override
  String get resetAction => 'Effacer';

  @override
  String get boardLabel => 'Grille';

  @override
  String get soundOn => 'Son activé';

  @override
  String get soundOff => 'Son désactivé';

  @override
  String get musicOn => 'Musique activée';

  @override
  String get musicOff => 'Musique désactivée';

  @override
  String get currentLevel => 'Niveau en cours';

  @override
  String get clearBoard => 'Effacer la grille ?';

  @override
  String get clearBoardYes => 'Effacer';
}
