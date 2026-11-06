// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ChromaPath: Connect Puzzle';

  @override
  String get homeTagline => 'Conecta cada color.';

  @override
  String get play => 'Jugar';

  @override
  String get levels => 'Niveles';

  @override
  String get settings => 'Ajustes';

  @override
  String get howToPlay => 'Cómo jugar';

  @override
  String get howToLine =>
      'Arrastra entre dos puntos iguales y llena el tablero.';

  @override
  String get skip => 'Saltar';

  @override
  String get back => 'Atrás';

  @override
  String levelLabel(int level) {
    return 'Nivel $level';
  }

  @override
  String progressLabel(int current, int total) {
    return 'Nivel $current de $total';
  }

  @override
  String get nextLevel => 'Siguiente nivel';

  @override
  String get levelClear => 'Tablero lleno';

  @override
  String get levelCompliment => '¡Se ve delicioso!';

  @override
  String get allClear => 'Todos los niveles están llenos';

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get undo => 'Deshacer';

  @override
  String get reset => 'Reiniciar';

  @override
  String get hint => 'Pista';

  @override
  String get lockedLevel => 'Bloqueado';

  @override
  String starsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estrellas',
      one: '1 estrella',
    );
    return '$_temp0';
  }

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsGame => 'Juego';

  @override
  String get settingsAbout => 'Información';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Idioma del dispositivo';

  @override
  String get settingsSound => 'Sonido';

  @override
  String get settingsMusic => 'Música';

  @override
  String get settingsHaptics => 'Vibración';

  @override
  String get settingsAccessibility => 'Accesibilidad';

  @override
  String get settingsReduceMotion => 'Reducir movimiento';

  @override
  String get motionSystem => 'Sistema';

  @override
  String get motionOn => 'Sí';

  @override
  String get motionOff => 'No';

  @override
  String get settingsPrivacy => 'Política de privacidad';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get openFailed => 'No se pudo abrir la página.';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => 'Borrar progreso';

  @override
  String get resetProgressBody => 'Se borrarán los niveles completados.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get resetAction => 'Borrar';

  @override
  String get boardLabel => 'Tablero';

  @override
  String get soundOn => 'Sonido activado';

  @override
  String get soundOff => 'Sonido desactivado';

  @override
  String get musicOn => 'Música activada';

  @override
  String get musicOff => 'Música desactivada';

  @override
  String get currentLevel => 'Nivel actual';

  @override
  String get clearBoard => '¿Borrar el tablero?';

  @override
  String get clearBoardYes => 'Borrar';
}
