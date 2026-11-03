import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../game/hint.dart';
import '../game/levels.dart';
import '../game/model.dart';
import '../game/rules.dart';
import '../l10n/app_localizations.dart';
import '../services/audio_service.dart';
import '../services/progress_store.dart';
import '../widgets/flow_board.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({required this.levelIndex, super.key});

  final int levelIndex;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final Stopwatch _clock = Stopwatch();
  final List<Board> _history = [];
  Board? _boardField;
  ProgressStore? _progress;
  AudioService? _audio;
  int? _strokeColor;
  int? _hintCell;
  int? _flashCell;
  int? _lastReject;
  int _hints = 0;
  int _resets = 0;
  int _earned = 0;
  bool _ready = false;
  bool _solved = false;
  bool _loggedQuit = false;
  Timer? _flashTimer;
  late final AnimationController _win = AnimationController(vsync: this, duration: AppMotion.win);

  FlowLevel get _level => Levels.all[widget.levelIndex];

  Board get _board => _boardField ?? _level.empty;

  set _board(Board value) => _boardField = value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AnalyticsService.instance.logScreen(AnalyticsValues.play);
    AnalyticsService.instance.logLevelStart(widget.levelIndex + 1);
    _clock.start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final services = AppScope.read(context);
    _progress = services.progress;
    _audio = services.audio;
    if (_ready) return;
    _ready = true;
    _board = _level.empty;
    final draft = services.progress.draft;
    if (draft != null && draft.levelIndex == widget.levelIndex && draft.paths.length == _level.colorCount) {
      _board = Board(size: _level.size, ends: _level.ends, paths: draft.paths);
      _hints = draft.hints;
      _resets = draft.resets;
      if (Rules.isSolved(_board)) {
        _solved = true;
        _earned = Rules.starsFor(_hints, _resets);
        _win.value = 1;
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_solved) _clock.start();
      return;
    }
    _clock.stop();
    if (!_solved) _saveDraft();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashTimer?.cancel();
    _win.dispose();
    if (_ready && !_solved) _saveDraft();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width >= AppDimens.wide;
    final hintColor = _colorOf(_hintCell);
    final finger = _strokeColor == null || _board.paths[_strokeColor!].isEmpty ? null : _board.paths[_strokeColor!].last;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, AppDimens.page),
                child: Column(
                  children: [
                    SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _leave,
                            icon: const Icon(Icons.arrow_back_rounded),
                            tooltip: l10n.back,
                          ),
                          Expanded(child: Text(l10n.levelLabel(_level.id), style: theme.titleLarge)),
                          IconButton(
                            onPressed: _history.isEmpty || _solved ? null : _undo,
                            icon: const Icon(Icons.undo_rounded),
                            tooltip: l10n.undo,
                          ),
                          IconButton(
                            onPressed: _solved ? null : _hint,
                            icon: const Icon(Icons.lightbulb_outline_rounded),
                            tooltip: l10n.hint,
                          ),
                          IconButton(
                            onPressed: _solved || !_dirty ? null : _askReset,
                            icon: const Icon(Icons.refresh_rounded),
                            tooltip: l10n.reset,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: wide ? 560 : 520),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: FlowBoardView(
                              board: _board,
                              hintCell: _hintCell,
                              hintColor: hintColor,
                              flashCell: _flashCell,
                              fingerCell: finger,
                              interactive: !_solved,
                              label: l10n.boardLabel,
                              onDown: _down,
                              onMove: _move,
                              onUp: _up,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_solved)
                Positioned.fill(
                  child: ColoredBox(
                    color: AppColors.scrim,
                    child: Center(
                      child: FadeTransition(
                        opacity: _win,
                        child: _ClearCard(
                          title: l10n.levelClear,
                          stars: _earned,
                          nextLabel: widget.levelIndex + 1 >= Levels.all.length ? l10n.levels : l10n.nextLevel,
                          onNext: () => unawaited(_next()),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _dirty => _board.paths.any((path) => path.isNotEmpty);

  int? _colorOf(int? cell) {
    if (cell == null) return null;
    for (var color = 0; color < _level.flows.length; color++) {
      if (_level.flows[color].contains(cell)) return color;
    }
    return null;
  }

  void _down(int cell) {
    if (_solved) return;
    _audio?.unlock();
    _lastReject = null;
    final color = _board.ends[cell] ?? _board.ownerOf(cell);
    if (color == null) {
      _reject(cell);
      return;
    }
    final next = Rules.startStroke(_board, cell);
    if (next == null) return;
    if (next.signature != _board.signature) {
      _history.add(_board);
      if (_history.length > 80) _history.removeAt(0);
    }
    setState(() {
      _board = next;
      _strokeColor = color;
      _hintCell = null;
    });
  }

  void _move(int target) {
    final color = _strokeColor;
    if (color == null || _solved) return;
    var board = _board;
    var connected = false;
    var guard = 0;
    while (guard++ < _level.size * _level.size) {
      final path = board.paths[color];
      if (path.isEmpty) break;
      if (path.last == target) break;
      final step = stepToward(path.last, target, board.size);
      if (step == null) break;
      final next = Rules.extend(board, color, step);
      if (next == null) {
        _reject(step);
        break;
      }
      if (next.signature == board.signature) break;
      final wasConnected = Rules.connects(board, color);
      board = next;
      _lastReject = null;
      if (!wasConnected && Rules.connects(board, color)) connected = true;
      if (Rules.isSolved(board)) {
        _board = board;
        _audio?.playTick();
        _finish();
        return;
      }
    }
    if (board.signature == _board.signature) return;
    if (connected) {
      _audio?.playConnect();
    } else {
      _audio?.playTick();
    }
    setState(() {
      _board = board;
      _hintCell = null;
    });
  }

  void _up() {
    _strokeColor = null;
    _lastReject = null;
    if (!_solved) _saveDraft();
  }

  void _undo() {
    if (_history.isEmpty || _solved) return;
    setState(() {
      _board = _history.removeLast();
      _hintCell = null;
      _strokeColor = null;
    });
    _audio?.playTap();
    _saveDraft();
  }

  void _hint() {
    final cell = HintSystem.nextCell(_level, _board);
    if (cell == null || _solved) return;
    setState(() {
      _hints += 1;
      _hintCell = cell;
    });
    _audio?.playTap();
    _saveDraft();
  }

  Future<void> _askReset() async {
    final l10n = AppLocalizations.of(context);
    final clear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearBoard),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.clearBoardYes)),
        ],
      ),
    );
    if (clear != true || !mounted || _solved) return;
    _history.add(_board);
    setState(() {
      _board = Rules.cleared(_board);
      _resets += 1;
      _hintCell = null;
      _strokeColor = null;
    });
    _audio?.playTap();
    _saveDraft();
  }

  void _reject(int cell) {
    if (_lastReject == cell) return;
    _lastReject = cell;
    _audio?.playInvalid();
    if (AppScope.read(context).settings.haptics) HapticFeedback.lightImpact();
    setState(() => _flashCell = cell);
    _flashTimer?.cancel();
    _flashTimer = Timer(const Duration(milliseconds: 180), () {
      if (mounted) setState(() => _flashCell = null);
    });
  }

  void _finish() {
    if (_solved) return;
    final stars = Rules.starsFor(_hints, _resets);
    _clock.stop();
    setState(() {
      _solved = true;
      _earned = stars;
      _strokeColor = null;
      _hintCell = null;
    });
    final reduce = AppScope.read(context).settings.reduceMotionFor(context);
    if (reduce) {
      _win.value = 1;
    } else {
      _win.forward(from: 0);
    }
    _audio?.playWin();
    AnalyticsService.instance.logLevelEnd(
      level: _level.id,
      durationSec: _clock.elapsed.inSeconds,
      stars: stars,
      hintsUsed: _hints,
      resetsUsed: _resets,
    );
    unawaited(_progress?.markComplete(widget.levelIndex, stars));
  }

  Future<void> _next() async {
    await AppScope.read(context).ads.showInterstitial();
    if (!mounted) return;
    final next = widget.levelIndex + 1;
    if (next >= Levels.all.length) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.play, arguments: next);
  }

  void _leave() {
    if (!_solved && !_loggedQuit) {
      _loggedQuit = true;
      AnalyticsService.instance.logLevelQuit(
        level: _level.id,
        durationSec: _clock.elapsed.inSeconds,
        from: AnalyticsValues.back,
      );
      _saveDraft();
    }
    Navigator.of(context).pop();
  }

  void _saveDraft() {
    final progress = _progress;
    if (progress == null || _solved) return;
    unawaited(
      progress.saveDraft(
        PuzzleDraft(levelIndex: widget.levelIndex, paths: _board.paths, hints: _hints, resets: _resets),
      ),
    );
  }
}

class _ClearCard extends StatelessWidget {
  const _ClearCard({required this.title, required this.stars, required this.nextLabel, required this.onNext});

  final String title;
  final int stars;
  final String nextLabel;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Material(
        color: AppColors.surface,
        elevation: 8,
        shadowColor: const Color(0x14000000),
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: theme.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    Icon(
                      i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                      color: i < stars ? AppColors.yellow : AppColors.faint,
                      size: 36,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: onNext, child: Text(nextLabel)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
