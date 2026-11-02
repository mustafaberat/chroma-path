// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Color Links';

  @override
  String get homeTagline => 'すべての色をつなぐ。';

  @override
  String get play => 'プレイ';

  @override
  String get levels => 'レベル';

  @override
  String get settings => '設定';

  @override
  String get howToPlay => '遊び方';

  @override
  String get howToLine => '同じ色の点をなぞって、マスをすべて埋めてください。';

  @override
  String get skip => 'スキップ';

  @override
  String get back => '戻る';

  @override
  String levelLabel(int level) {
    return 'レベル $level';
  }

  @override
  String progressLabel(int current, int total) {
    return 'レベル $current / $total';
  }

  @override
  String get nextLevel => '次のレベル';

  @override
  String get levelClear => '埋まりました';

  @override
  String get allClear => 'すべてのレベルが終わりました';

  @override
  String get playAgain => 'もう一度';

  @override
  String get undo => '元に戻す';

  @override
  String get reset => 'リセット';

  @override
  String get hint => 'ヒント';

  @override
  String get lockedLevel => 'ロック中';

  @override
  String starsLabel(int count) {
    return '星 $count';
  }

  @override
  String get settingsGeneral => '一般';

  @override
  String get settingsGame => 'ゲーム';

  @override
  String get settingsAbout => '情報';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSystem => '端末の言語';

  @override
  String get settingsSound => '効果音';

  @override
  String get settingsMusic => '音楽';

  @override
  String get settingsHaptics => '振動';

  @override
  String get settingsAccessibility => 'アクセシビリティ';

  @override
  String get settingsReduceMotion => '動きを減らす';

  @override
  String get motionSystem => 'システム';

  @override
  String get motionOn => 'オン';

  @override
  String get motionOff => 'オフ';

  @override
  String get settingsPrivacy => 'プライバシーポリシー';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get openFailed => 'ページを開けませんでした。';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => '進捗を消す';

  @override
  String get resetProgressBody => 'クリアしたレベルが消えます。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get resetAction => '消す';

  @override
  String get boardLabel => '盤面';

  @override
  String get soundOn => '効果音オン';

  @override
  String get soundOff => '効果音オフ';

  @override
  String get musicOn => '音楽オン';

  @override
  String get musicOff => '音楽オフ';

  @override
  String get currentLevel => '今のレベル';

  @override
  String get clearBoard => '盤面を消しますか？';

  @override
  String get clearBoardYes => '消す';
}
