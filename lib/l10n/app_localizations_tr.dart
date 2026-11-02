// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'ChromaPath: Connect Puzzle';

  @override
  String get homeTagline => 'Her rengi bağla.';

  @override
  String get play => 'Oyna';

  @override
  String get levels => 'Seviyeler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get howToPlay => 'Nasıl oynanır';

  @override
  String get howToLine => 'Aynı iki nokta arasında sürükle ve tahtayı doldur.';

  @override
  String get skip => 'Geç';

  @override
  String get back => 'Geri';

  @override
  String levelLabel(int level) {
    return 'Seviye $level';
  }

  @override
  String progressLabel(int current, int total) {
    return 'Seviye $current / $total';
  }

  @override
  String get nextLevel => 'Sonraki seviye';

  @override
  String get levelClear => 'Tahta doldu';

  @override
  String get allClear => 'Tüm seviyeler doldu';

  @override
  String get playAgain => 'Tekrar oyna';

  @override
  String get undo => 'Geri al';

  @override
  String get reset => 'Sıfırla';

  @override
  String get hint => 'İpucu';

  @override
  String get lockedLevel => 'Kilitli';

  @override
  String starsLabel(int count) {
    return '$count yıldız';
  }

  @override
  String get settingsGeneral => 'Genel';

  @override
  String get settingsGame => 'Oyun';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageSystem => 'Cihaz dili';

  @override
  String get settingsSound => 'Ses';

  @override
  String get settingsMusic => 'Müzik';

  @override
  String get settingsHaptics => 'Titreşim';

  @override
  String get settingsAccessibility => 'Erişilebilirlik';

  @override
  String get settingsReduceMotion => 'Hareketi azalt';

  @override
  String get motionSystem => 'Sistem';

  @override
  String get motionOn => 'Açık';

  @override
  String get motionOff => 'Kapalı';

  @override
  String get settingsPrivacy => 'Gizlilik politikası';

  @override
  String get settingsVersion => 'Sürüm';

  @override
  String get openFailed => 'Sayfa açılamadı.';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => 'İlerlemeyi sil';

  @override
  String get resetProgressBody => 'Bitirilen seviyeler silinir.';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get resetAction => 'Sil';

  @override
  String get boardLabel => 'Tahta';

  @override
  String get soundOn => 'Ses açık';

  @override
  String get soundOff => 'Ses kapalı';

  @override
  String get musicOn => 'Müzik açık';

  @override
  String get musicOff => 'Müzik kapalı';

  @override
  String get currentLevel => 'Şu anki seviye';

  @override
  String get clearBoard => 'Tahta silinsin mi?';

  @override
  String get clearBoardYes => 'Sil';
}
