import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../config/tokens.dart';
import '../game/model.dart';

class FlowBoardView extends StatefulWidget {
  const FlowBoardView({
    required this.board,
    required this.onDown,
    required this.onMove,
    required this.onUp,
    this.hintCell,
    this.hintColor,
    this.flashCell,
    this.fingerCell,
    this.interactive = true,
    this.label = '',
    super.key,
  });

  final Board board;
  final int? hintCell;
  final int? hintColor;
  final int? flashCell;
  final int? fingerCell;
  final bool interactive;
  final String label;
  final ValueChanged<int> onDown;
  final ValueChanged<int> onMove;
  final VoidCallback onUp;

  @override
  State<FlowBoardView> createState() => _FlowBoardViewState();
}

class _FlowBoardViewState extends State<FlowBoardView> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this, duration: AppMotion.pulse);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = AppScope.of(context).settings.reduceMotionFor(context);
    if (reduce) {
      _pulse.stop();
      _pulse.value = 0;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 10))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final side = constraints.maxWidth;
              int cellAt(Offset position) {
                final cell = side / widget.board.size;
                final col = (position.dx / cell).floor().clamp(0, widget.board.size - 1);
                final row = (position.dy / cell).floor().clamp(0, widget.board.size - 1);
                return row * widget.board.size + col;
              }

              return Semantics(
                label: widget.label,
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) {
                    return Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: widget.interactive
                          ? (event) => widget.onDown(cellAt(event.localPosition))
                          : null,
                      onPointerMove: widget.interactive
                          ? (event) {
                              final position = event.localPosition;
                              if (position.dx < 0 || position.dy < 0 || position.dx >= side || position.dy >= side) {
                                return;
                              }
                              widget.onMove(cellAt(position));
                            }
                          : null,
                      onPointerUp: widget.interactive ? (_) => widget.onUp() : null,
                      onPointerCancel: widget.interactive ? (_) => widget.onUp() : null,
                      child: CustomPaint(
                        painter: _BoardPainter(
                          board: widget.board,
                          hintCell: widget.hintCell,
                          hintColor: widget.hintColor,
                          flashCell: widget.flashCell,
                          fingerCell: widget.fingerCell,
                          pulse: _pulse.value,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  _BoardPainter({
    required this.board,
    required this.pulse,
    this.hintCell,
    this.hintColor,
    this.flashCell,
    this.fingerCell,
  });

  final Board board;
  final int? hintCell;
  final int? hintColor;
  final int? flashCell;
  final int? fingerCell;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final count = board.size;
    final cell = size.width / count;
    final gap = cell * 0.1;
    final radius = Radius.circular(cell * 0.22);
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.board);

    for (var index = 0; index < count * count; index++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(_rect(index, count, cell, gap), radius),
        Paint()..color = AppColors.surface,
      );
    }

    for (var color = 0; color < board.colorCount; color++) {
      final paint = Paint()..color = Palette.of(color);
      final path = board.paths[color];
      for (var i = 0; i < path.length; i++) {
        canvas.drawRRect(RRect.fromRectAndRadius(_rect(path[i], count, cell, gap), radius), paint);
        if (i > 0) _bridge(canvas, path[i - 1], path[i], count, cell, gap, paint);
      }
    }

    for (var index = 0; index < board.ends.length; index++) {
      final color = board.ends[index];
      if (color == null) continue;
      final center = _center(index, count, cell);
      final dot = cell * 0.28 * (fingerCell == index ? 1.08 : 1);
      canvas.drawCircle(center, dot, Paint()..color = Palette.of(color));
      canvas.drawCircle(center, dot * 0.38, Paint()..color = AppColors.onAccent);
    }

    if (hintCell != null && hintColor != null) {
      final rect = _rect(hintCell!, count, cell, gap * 0.2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, radius),
        Paint()
          ..color = Palette.of(hintColor!)
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell * (0.06 + pulse * 0.03),
      );
    }

    if (flashCell != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(_rect(flashCell!, count, cell, gap * 0.4), radius),
        Paint()
          ..color = AppColors.ink.withValues(alpha: 0.18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell * 0.06,
      );
    }
  }

  Rect _rect(int index, int count, double cell, double gap) {
    final row = index ~/ count;
    final col = index % count;
    return Rect.fromLTWH(col * cell + gap, row * cell + gap, cell - gap * 2, cell - gap * 2);
  }

  Offset _center(int index, int count, double cell) {
    final row = index ~/ count;
    final col = index % count;
    return Offset((col + 0.5) * cell, (row + 0.5) * cell);
  }

  void _bridge(Canvas canvas, int a, int b, int count, double cell, double gap, Paint paint) {
    final first = _rect(a, count, cell, gap);
    final second = _rect(b, count, cell, gap);
    final Rect bridge;
    if ((a ~/ count) == (b ~/ count)) {
      final left = first.center.dx < second.center.dx ? first : second;
      final right = identical(left, first) ? second : first;
      bridge = Rect.fromLTRB(left.right - 1, left.top, right.left + 1, left.bottom);
    } else {
      final top = first.center.dy < second.center.dy ? first : second;
      final bottom = identical(top, first) ? second : first;
      bridge = Rect.fromLTRB(top.left, top.bottom - 1, top.right, bottom.top + 1);
    }
    canvas.drawRect(bridge, paint);
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return oldDelegate.board.signature != board.signature ||
        oldDelegate.hintCell != hintCell ||
        oldDelegate.flashCell != flashCell ||
        oldDelegate.fingerCell != fingerCell ||
        oldDelegate.pulse != pulse;
  }
}
