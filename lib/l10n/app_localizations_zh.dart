// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Color Links';

  @override
  String get homeTagline => '连上每一种颜色。';

  @override
  String get play => '开始';

  @override
  String get levels => '关卡';

  @override
  String get settings => '设置';

  @override
  String get howToPlay => '怎么玩';

  @override
  String get howToLine => '在两个相同的点之间拖动，并填满棋盘。';

  @override
  String get skip => '跳过';

  @override
  String get back => '返回';

  @override
  String levelLabel(int level) {
    return '第 $level 关';
  }

  @override
  String progressLabel(int current, int total) {
    return '第 $current 关，共 $total 关';
  }

  @override
  String get nextLevel => '下一关';

  @override
  String get levelClear => '棋盘已填满';

  @override
  String get allClear => '所有关卡都已完成';

  @override
  String get playAgain => '再玩一次';

  @override
  String get undo => '撤销';

  @override
  String get reset => '重置';

  @override
  String get hint => '提示';

  @override
  String get lockedLevel => '未解锁';

  @override
  String starsLabel(int count) {
    return '$count 颗星';
  }

  @override
  String get settingsGeneral => '通用';

  @override
  String get settingsGame => '游戏';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '设备语言';

  @override
  String get settingsSound => '音效';

  @override
  String get settingsMusic => '音乐';

  @override
  String get settingsHaptics => '振动';

  @override
  String get settingsAccessibility => '辅助功能';

  @override
  String get settingsReduceMotion => '减少动画';

  @override
  String get motionSystem => '跟随系统';

  @override
  String get motionOn => '开';

  @override
  String get motionOff => '关';

  @override
  String get settingsPrivacy => '隐私政策';

  @override
  String get settingsVersion => '版本';

  @override
  String get openFailed => '无法打开页面。';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => '清除进度';

  @override
  String get resetProgressBody => '已完成的关卡会被清除。';

  @override
  String get cancel => '取消';

  @override
  String get resetAction => '清除';

  @override
  String get boardLabel => '棋盘';

  @override
  String get soundOn => '音效已开';

  @override
  String get soundOff => '音效已关';

  @override
  String get musicOn => '音乐已开';

  @override
  String get musicOff => '音乐已关';

  @override
  String get currentLevel => '当前关卡';

  @override
  String get clearBoard => '清空棋盘？';

  @override
  String get clearBoardYes => '清空';
}
