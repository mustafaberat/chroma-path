// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'ChromaPath: Connect Puzzle';

  @override
  String get homeTagline => 'Ligue cada cor.';

  @override
  String get play => 'Jogar';

  @override
  String get levels => 'Níveis';

  @override
  String get settings => 'Ajustes';

  @override
  String get howToPlay => 'Como jogar';

  @override
  String get howToLine =>
      'Arraste entre dois pontos iguais e preencha o tabuleiro.';

  @override
  String get skip => 'Pular';

  @override
  String get back => 'Voltar';

  @override
  String levelLabel(int level) {
    return 'Nível $level';
  }

  @override
  String progressLabel(int current, int total) {
    return 'Nível $current de $total';
  }

  @override
  String get nextLevel => 'Próximo nível';

  @override
  String get levelClear => 'Tabuleiro cheio';

  @override
  String get levelCompliment => 'Parece delicioso!';

  @override
  String get allClear => 'Todos os níveis estão cheios';

  @override
  String get playAgain => 'Jogar de novo';

  @override
  String get undo => 'Desfazer';

  @override
  String get reset => 'Reiniciar';

  @override
  String get hint => 'Dica';

  @override
  String get lockedLevel => 'Bloqueado';

  @override
  String starsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estrelas',
      one: '1 estrela',
    );
    return '$_temp0';
  }

  @override
  String get settingsGeneral => 'Geral';

  @override
  String get settingsGame => 'Jogo';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Idioma do aparelho';

  @override
  String get settingsSound => 'Som';

  @override
  String get settingsMusic => 'Música';

  @override
  String get settingsHaptics => 'Vibração';

  @override
  String get settingsAccessibility => 'Acessibilidade';

  @override
  String get settingsReduceMotion => 'Reduzir movimento';

  @override
  String get motionSystem => 'Sistema';

  @override
  String get motionOn => 'Sim';

  @override
  String get motionOff => 'Não';

  @override
  String get settingsPrivacy => 'Política de privacidade';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get openFailed => 'Não foi possível abrir a página.';

  @override
  String get developer => 'ARU Soft';

  @override
  String get resetProgress => 'Apagar progresso';

  @override
  String get resetProgressBody => 'Os níveis concluídos serão apagados.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get resetAction => 'Apagar';

  @override
  String get boardLabel => 'Tabuleiro';

  @override
  String get soundOn => 'Som ligado';

  @override
  String get soundOff => 'Som desligado';

  @override
  String get musicOn => 'Música ligada';

  @override
  String get musicOff => 'Música desligada';

  @override
  String get currentLevel => 'Nível atual';

  @override
  String get clearBoard => 'Limpar o tabuleiro?';

  @override
  String get clearBoardYes => 'Limpar';
}
