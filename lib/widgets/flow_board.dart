import 'dart:math' as math;

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
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: Color(0x286B4632), blurRadius: 32, offset: Offset(0, 12)),
            BoxShadow(color: Color(0x146B4632), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AspectRatio(
            aspectRatio: 1,
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
                                  if (position.dx < 0 ||
                                      position.dy < 0 ||
                                      position.dx >= side ||
                                      position.dy >= side) {
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

  static const List<Color> _sugar = [
    Color(0xFFFFFBF5),
    Color(0xFFFFF3D4),
    Color(0xFFE7FBFF),
    Color(0xFFFFE4EF),
    Color(0xFFFFFFFF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final count = board.size;
    final cell = size.width / count;
    _waffle(canvas, size, count, cell);

    for (var color = 0; color < board.colorCount; color++) {
      _frosting(canvas, board.paths[color], color, count, cell);
    }

    for (var index = 0; index < board.ends.length; index++) {
      final color = board.ends[index];
      if (color == null) continue;
      final center = _center(index, count, cell);
      final scale = fingerCell == index ? 1.08 : 1.0;
      _dollop(canvas, center, Palette.of(color), cell * 0.38 * scale, index * 17 + color * 97);
    }

    if (hintCell != null && hintColor != null) {
      final rect = _rect(hintCell!, count, cell, cell * 0.08);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(cell * 0.16)),
        Paint()
          ..color = Palette.of(hintColor!)
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell * (0.055 + pulse * 0.03),
      );
    }

    if (flashCell != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(_rect(flashCell!, count, cell, cell * 0.1), Radius.circular(cell * 0.16)),
        Paint()
          ..color = AppColors.ink.withValues(alpha: 0.28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell * 0.06,
      );
    }
  }

  void _waffle(Canvas canvas, Size size, int count, double cell) {
    final body = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(cell * 0.22));
    
    canvas.drawRRect(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF2D098),
            const Color(0xFFE8C98A),
            const Color(0xFFD4A85A),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Offset.zero & size),
    );

    final ridge = cell * 0.13;
    final pocketRadius = Radius.circular(cell * 0.16);
    
    for (var index = 0; index < count * count; index++) {
      final rect = _rect(index, count, cell, ridge);
      final pocket = RRect.fromRectAndRadius(rect, pocketRadius);

      canvas.drawRRect(
        pocket.shift(Offset(cell * 0.015, cell * 0.02)),
        Paint()
          ..color = const Color(0x663A2418)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, cell * 0.045),
      );

      canvas.drawRRect(
        pocket,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0.0, 0.0),
            radius: 0.8,
            colors: [
              const Color(0xFF8B6534),
              const Color(0xFF9B7340),
              const Color(0xFFA67A3C),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(rect),
      );

      canvas.save();
      canvas.clipRRect(pocket);
      canvas.drawRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x99000000),
              Color(0x00000000),
              Color(0x33FFFFFF),
            ],
            stops: [0.0, 0.6, 1.0],
          ).createShader(rect),
      );
      canvas.restore();

      canvas.drawRRect(
        pocket,
        Paint()
          ..color = const Color(0x1A000000)
          ..style = PaintingStyle.stroke
          ..strokeWidth = cell * 0.015,
      );
    }

    canvas.drawRRect(
      body.deflate(cell * 0.02),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF5D8A8),
            Color(0xFFE8C98A),
          ],
        ).createShader(Offset.zero & size)
        ..style = PaintingStyle.stroke
        ..strokeWidth = cell * 0.055,
    );

    canvas.drawRRect(
      body.deflate(cell * 0.025),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = cell * 0.02,
    );
  }

  void _frosting(Canvas canvas, List<int> path, int color, int count, double cell) {
    if (path.length < 2) return;
    final hue = Palette.of(color);
    final points = [for (final index in path) _center(index, count, cell)];
    final tube = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      tube.lineTo(point.dx, point.dy);
    }
    final width = cell * 0.58;

    canvas.drawPath(
      tube.shift(Offset(cell * 0.025, cell * 0.055)),
      Paint()
        ..color = const Color(0x663A2418)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, cell * 0.06),
    );

    canvas.drawPath(
      tube,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 1.0,
          colors: [
            Color.lerp(hue, Colors.white, 0.15)!,
            hue,
            Color.lerp(hue, Colors.black, 0.1)!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Offset.zero & Size(cell * count, cell * count))
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawPath(
      tube.shift(Offset(-cell * 0.04, -cell * 0.05)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * 0.25
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < path.length - 1; i++) {
      _sugarOnSegment(canvas, points[i], points[i + 1], path[i] * 131 + path[i + 1] * 17 + color * 997, cell);
    }
  }

  void _dollop(Canvas canvas, Offset center, Color color, double radius, int seed) {
    canvas.drawCircle(
      center + Offset(radius * 0.1, radius * 0.18),
      radius,
      Paint()
        ..color = const Color(0x663A2418)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.28),
    );
    
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 1.0,
          colors: [
            Color.lerp(color, Colors.white, 0.2)!,
            color,
            Color.lerp(color, Colors.black, 0.15)!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    
    canvas.drawCircle(
      center + Offset(-radius * 0.3, -radius * 0.35),
      radius * 0.42,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
    
    _sugarOnDisc(canvas, center, radius, seed);
  }

  void _sugarOnSegment(Canvas canvas, Offset a, Offset b, int seed, double cell) {
    final random = math.Random(seed & 0x7fffffff);
    final delta = b - a;
    final len = delta.distance;
    if (len < 1) return;
    final normal = Offset(-delta.dy / len, delta.dx / len);
    final count = 5 + (seed.abs() % 4);
    for (var i = 0; i < count; i++) {
      final t = 0.12 + random.nextDouble() * 0.76;
      final lateral = (random.nextDouble() - 0.5) * cell * 0.32;
      _spark(canvas, a + delta * t + normal * lateral, cell * (0.014 + random.nextDouble() * 0.018), random);
    }
  }

  void _sugarOnDisc(Canvas canvas, Offset center, double radius, int seed) {
    final random = math.Random(seed & 0x7fffffff);
    for (var i = 0; i < 9; i++) {
      final angle = random.nextDouble() * math.pi * 2;
      final dist = random.nextDouble() * radius * 0.7;
      _spark(
        canvas,
        center + Offset(math.cos(angle), math.sin(angle)) * dist,
        radius * (0.065 + random.nextDouble() * 0.055),
        random,
      );
    }
  }

  void _spark(Canvas canvas, Offset at, double radius, math.Random random) {
    final color = _sugar[random.nextInt(_sugar.length)].withValues(alpha: 0.75 + random.nextDouble() * 0.25);
    canvas.drawCircle(at, radius, Paint()..color = color);
    if (radius > 1.5) {
      canvas.drawCircle(
        at + Offset(-radius * 0.28, -radius * 0.28),
        radius * 0.38,
        Paint()..color = const Color(0xEAFFFFFF),
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

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return oldDelegate.board.signature != board.signature ||
        oldDelegate.hintCell != hintCell ||
        oldDelegate.hintColor != hintColor ||
        oldDelegate.flashCell != flashCell ||
        oldDelegate.fingerCell != fingerCell ||
        oldDelegate.pulse != pulse;
  }
}
