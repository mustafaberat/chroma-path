import 'dart:async';

import 'package:flutter/material.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../game/model.dart';
import '../l10n/app_localizations.dart';
import '../widgets/flow_board.dart';

class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({required this.firstRun, super.key});

  final bool firstRun;

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> with SingleTickerProviderStateMixin {
  static final FlowLevel _demo = FlowLevel(
    id: 0,
    size: 4,
    flows: const [
      [0, 1, 2, 3, 7, 6, 5, 4],
      [8, 9, 10, 11, 15, 14, 13, 12],
    ],
  );

  late final AnimationController _loop = AnimationController(vsync: this, duration: const Duration(milliseconds: 6400));

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logHowToPlayOpen(widget.firstRun ? AnalyticsValues.firstRun : AnalyticsValues.settings);
    AnalyticsService.instance.logScreen(AnalyticsValues.howTo);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = AppScope.of(context).settings.reduceMotionFor(context);
    if (reduce) {
      _loop.stop();
    } else if (!_loop.isAnimating) {
      _loop.repeat();
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reduce = AppScope.of(context).settings.reduceMotionFor(context);
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppDimens.page, 8, AppDimens.page, AppDimens.page),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: _close, child: Text(l10n.skip)),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: AnimatedBuilder(
                      animation: _loop,
                      builder: (context, _) {
                        final frame = reduce ? _still() : _pose(_loop.value);
                        return FlowBoardView(
                          board: frame.board,
                          fingerCell: frame.finger,
                          interactive: false,
                          label: l10n.boardLabel,
                          onDown: (_) {},
                          onMove: (_) {},
                          onUp: () {},
                        );
                      },
                    ),
                  ),
                ),
              ),
              Text(l10n.howToLine, textAlign: TextAlign.center, style: theme.titleLarge),
              const SizedBox(height: AppDimens.gapL),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: widget.firstRun ? _play : _close,
                  child: Text(widget.firstRun ? l10n.play : l10n.back),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _close() {
    final settings = AppScope.read(context).settings;
    Navigator.of(context).pop();
    unawaited(settings.setOnboardingDone(true));
  }

  void _play() {
    final settings = AppScope.read(context).settings;
    AppScope.read(context).audio.unlock();
    unawaited(settings.setOnboardingDone(true));
    AnalyticsService.instance.logPlayTap(1);
    Navigator.of(context).pushReplacementNamed(AppRoutes.play, arguments: 0);
  }

  _Frame _still() {
    return _Frame(
      board: _shown(first: _demo.flows[0].length, second: 1),
      finger: _demo.flows[1].first,
    );
  }

  _Frame _pose(double t) {
    final first = _demo.flows[0];
    final second = _demo.flows[1];
    if (t < 0.08) return _Frame(board: _shown(first: 1, second: 0), finger: first.first);
    if (t < 0.42) {
      final count = 1 + ((t - 0.08) / 0.34 * (first.length - 1)).floor().clamp(0, first.length - 1);
      return _Frame(board: _shown(first: count, second: 0), finger: first[count - 1]);
    }
    if (t < 0.5) return _Frame(board: _shown(first: first.length, second: 1), finger: second.first);
    if (t < 0.86) {
      final count = 1 + ((t - 0.5) / 0.36 * (second.length - 1)).floor().clamp(0, second.length - 1);
      return _Frame(board: _shown(first: first.length, second: count), finger: second[count - 1]);
    }
    return _Frame(board: _shown(first: first.length, second: second.length), finger: second.last);
  }

  Board _shown({required int first, required int second}) {
    return Board(
      size: _demo.size,
      ends: _demo.ends,
      paths: [
        _demo.flows[0].sublist(0, first),
        if (second == 0) <int>[] else _demo.flows[1].sublist(0, second),
      ],
    );
  }
}

class _Frame {
  const _Frame({required this.board, required this.finger});

  final Board board;
  final int finger;
}
