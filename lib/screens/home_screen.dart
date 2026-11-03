import 'package:flutter/material.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../game/levels.dart';
import '../l10n/app_localizations.dart';
import '../widgets/banner_slot.dart';
import '../widgets/flow_board.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreen(AnalyticsValues.home);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final settings = AppScope.read(context).settings;
      if (settings.onboardingDone) return;
      Navigator.of(context).pushNamed(AppRoutes.howTo, arguments: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = AppScope.of(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width >= AppDimens.wide;
    final board = ListenableBuilder(
      listenable: services.progress,
      builder: (context, _) {
        final progress = services.progress;
        final previewIndex = progress.finishedAll ? Levels.all.length - 1 : progress.frontier;
        return IgnorePointer(
          child: FlowBoardView(
            board: Levels.all[previewIndex].empty,
            label: l10n.boardLabel,
            onDown: (_) {},
            onMove: (_) {},
            onUp: () {},
            interactive: false,
          ),
        );
      },
    );

    final copy = ListenableBuilder(
      listenable: services.progress,
      builder: (context, _) {
        final progress = services.progress;
        final fraction = progress.frontier / progress.stars.length;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                for (final color in Palette.colors)
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(l10n.appTitle, style: theme.headlineLarge),
            const SizedBox(height: 8),
            Text(l10n.homeTagline, style: theme.bodyMedium),
            const SizedBox(height: AppDimens.gapL),
            Text(
              progress.finishedAll ? l10n.allClear : l10n.progressLabel(progress.currentNumber, Levels.all.length),
              style: theme.titleMedium,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                backgroundColor: AppColors.line,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: AppDimens.gapL),
            FilledButton(
              onPressed: () => _play(context),
              child: Text(progress.finishedAll ? l10n.playAgain : l10n.play),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                services.audio.unlock();
                AnalyticsService.instance.logScreen(AnalyticsValues.levels);
                Navigator.of(context).pushNamed(AppRoutes.levels);
              },
              child: Text(l10n.levels),
            ),
            TextButton(
              onPressed: () {
                AnalyticsService.instance.logSettingsOpen(AnalyticsValues.home);
                Navigator.of(context).pushNamed(AppRoutes.settings);
              },
              child: Text(l10n.settings),
            ),
          ],
        );
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.page),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: services.settings.sound ? l10n.soundOn : l10n.soundOff,
                      onPressed: () => services.settings.setSound(!services.settings.sound),
                      icon: Icon(services.settings.sound ? Icons.volume_up_rounded : Icons.volume_off_rounded),
                    ),
                    IconButton(
                      tooltip: services.settings.music ? l10n.musicOn : l10n.musicOff,
                      onPressed: () => services.settings.setMusic(!services.settings.music),
                      icon: Icon(services.settings.music ? Icons.music_note_rounded : Icons.music_off_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: wide ? 920 : AppDimens.maxContent),
                    child: wide
                        ? Row(
                            children: [
                              Expanded(child: board),
                              const SizedBox(width: 36),
                              Expanded(child: copy),
                            ],
                          )
                        : Column(
                            children: [
                              Expanded(child: Center(child: board)),
                              copy,
                            ],
                          ),
                  ),
                ),
              ),
              const BannerSlot(),
            ],
          ),
        ),
      ),
    );
  }

  void _play(BuildContext context) {
    final services = AppScope.read(context);
    services.audio.unlock();
    final progress = services.progress;
    final index = progress.finishedAll ? 0 : progress.frontier;
    AnalyticsService.instance.logPlayTap(index + 1);
    Navigator.of(context).pushNamed(AppRoutes.play, arguments: index);
  }
}
