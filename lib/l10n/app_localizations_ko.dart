// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'ChromaPath: Connect Puzzle';

  @override
  String get homeTagline => '모든 색을 연결하세요.';

  @override
  String get play => '플레이';

  @override
  String get levels => '레벨';

  @override
  String get settings => '설정';

  @override
  String get howToPlay => '플레이 방법';

  @override
  String get howToLine => '같은 점 사이를 드래그하고 판을 채우세요.';

  @override
  String get skip => '건너뛰기';

  @override
  String get back => '뒤로';

  @override
  String levelLabel(int level) {
    return '레벨 $level';
  }

  @override
  String progressLabel(int current, int total) {
    return '레벨 $current / $total';
  }

  @override
  String get nextLevel => '다음 레벨';

  @override
  String get levelClear => '판을 채웠습니다';

  @override
  String get levelCompliment => '맛있어 보여요!';

  @override
  String get allClear => '모든 레벨을 채웠습니다';

  @override
  String get playAgain => '다시 플레이';

  @override
  String get undo => '실행 취소';

  @override
  String get reset => '다시 놓기';

  @override
  String get hint => '힌트';

  @override
  String get lockedLevel => '잠김';

  @override
  String starsLabel(int count) {
    return '별 $count개';
  }

  @override
  String get settingsGeneral => '일반';

  @override
  String get settingsGame => '게임';

  @override
  String get settingsAbout => '정보';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageSystem => '기기 언어';

  @override
  String get settingsSound => '소리';

  @override
  String get settingsMusic => '음악';

  @override
  String get settingsHaptics => '진동';

  @override
  String get settingsAccessibility => '접근성';

  @override
  String get settingsReduceMotion => '움직임 줄이기';

  @override
  String get motionSystem => '시스템';

  @override
  String get motionOn => '켜기';

  @override
  String get motionOff => '끄기';

  @override
  String get settingsPrivacy => '개인정보 처리방침';

  @override
  String get settingsVersion => '버전';

  @override
  String get openFailed => '페이지를 열 수 없습니다.';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => '진행 초기화';

  @override
  String get resetProgressBody => '완료한 레벨이 지워집니다.';

  @override
  String get cancel => '취소';

  @override
  String get resetAction => '지우기';

  @override
  String get boardLabel => '게임판';

  @override
  String get soundOn => '소리 켜짐';

  @override
  String get soundOff => '소리 꺼짐';

  @override
  String get musicOn => '음악 켜짐';

  @override
  String get musicOff => '음악 꺼짐';

  @override
  String get currentLevel => '현재 레벨';

  @override
  String get clearBoard => '판을 지울까요?';

  @override
  String get clearBoardYes => '지우기';
}
