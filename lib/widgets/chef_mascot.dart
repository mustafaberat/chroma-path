import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/tokens.dart';

class ChefMascot extends StatelessWidget {
  const ChefMascot({this.size = 120, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ChefPainter()),
    );
  }
}

class _ChefPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 120;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.translate(-60, -60);

    _drawBody(canvas);
    _drawHead(canvas);
    _drawToque(canvas);
    _drawPlate(canvas);

    canvas.restore();
  }

  void _drawBody(Canvas canvas) {
    final bodyPath = Path()
      ..moveTo(60, 70)
      ..lineTo(50, 105)
      ..lineTo(50, 115)
      ..lineTo(55, 120)
      ..lineTo(65, 120)
      ..lineTo(70, 115)
      ..lineTo(70, 105)
      ..lineTo(60, 70);

    canvas.drawPath(
      bodyPath,
      Paint()..color = const Color(0xFFE89AA5),
    );

    final apronPath = Path()
      ..moveTo(60, 75)
      ..lineTo(52, 100)
      ..quadraticBezierTo(52, 108, 60, 108)
      ..quadraticBezierTo(68, 108, 68, 100)
      ..lineTo(60, 75);

    canvas.drawPath(
      apronPath,
      Paint()..color = const Color(0xFFFFF8F3),
    );

    final frillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var i = 0; i < 5; i++) {
      final x = 54 + i * 3.0;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(x, 99), radius: 2),
        0,
        math.pi,
        false,
        frillPaint,
      );
    }

    final beltRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(55, 75, 10, 3),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(beltRect, Paint()..color = Colors.white);

    final pantPath = Path()
      ..moveTo(50, 105)
      ..lineTo(50, 115)
      ..lineTo(55, 120)
      ..lineTo(55, 105);
    canvas.drawPath(pantPath, Paint()..color = const Color(0xFF5D4037));

    final pant2Path = Path()
      ..moveTo(70, 105)
      ..lineTo(70, 115)
      ..lineTo(65, 120)
      ..lineTo(65, 105);
    canvas.drawPath(pant2Path, Paint()..color = const Color(0xFF4E342E));

    canvas.drawCircle(Offset(55, 120), 3, Paint()..color = const Color(0xFF4E342E));
    canvas.drawCircle(Offset(65, 120), 3, Paint()..color = const Color(0xFF3E2723));
  }

  void _drawHead(Canvas canvas) {
    final headPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.8,
        colors: [
          const Color(0xFFFFE0BD),
          const Color(0xFFFFD5A8),
        ],
      ).createShader(const Rect.fromLTWH(45, 40, 30, 30));

    canvas.drawCircle(const Offset(60, 55), 15, headPaint);

    final eyePaint = Paint()..color = const Color(0xFF3E2723);
    canvas.drawCircle(const Offset(55, 52), 2, eyePaint);
    canvas.drawCircle(const Offset(65, 52), 2, eyePaint);

    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawCircle(const Offset(55.5, 51), 0.8, highlightPaint);
    canvas.drawCircle(const Offset(65.5, 51), 0.8, highlightPaint);

    final smilePath = Path()
      ..moveTo(55, 58)
      ..quadraticBezierTo(60, 62, 65, 58);
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = const Color(0xFF3E2723)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );

    final blushPaint = Paint()..color = const Color(0xFFFFB8C3).withValues(alpha: 0.6);
    canvas.drawCircle(const Offset(50, 56), 3, blushPaint);
    canvas.drawCircle(const Offset(70, 56), 3, blushPaint);
  }

  void _drawToque(Canvas canvas) {
    final toquePath = Path()
      ..moveTo(48, 45)
      ..quadraticBezierTo(48, 32, 60, 28)
      ..quadraticBezierTo(72, 32, 72, 45)
      ..close();

    canvas.drawPath(
      toquePath,
      Paint()..color = Colors.white,
    );

    canvas.drawPath(
      toquePath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF5F5F5),
            Color(0xFFFFFFFF),
          ],
        ).createShader(const Rect.fromLTWH(48, 28, 24, 17)),
    );

    final bandRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(46, 42, 28, 6),
      const Radius.circular(3),
    );
    canvas.drawRRect(bandRect, Paint()..color = Colors.white);

    final badgeRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(56, 43, 8, 4),
      const Radius.circular(1),
    );
    canvas.drawRRect(
      badgeRect,
      Paint()..color = AppColors.waffle,
    );

    final gridPaint = Paint()
      ..color = AppColors.wafflePocket
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (var i = 1; i < 2; i++) {
      canvas.drawLine(
        Offset(56 + i * 4.0, 43),
        Offset(56 + i * 4.0, 47),
        gridPaint,
      );
    }
    for (var i = 1; i < 2; i++) {
      canvas.drawLine(
        Offset(56, 43 + i * 2.0),
        Offset(64, 43 + i * 2.0),
        gridPaint,
      );
    }
  }

  void _drawPlate(Canvas canvas) {
    final platePath = Path()
      ..moveTo(75, 85)
      ..quadraticBezierTo(85, 87, 95, 85)
      ..quadraticBezierTo(95, 88, 85, 90)
      ..quadraticBezierTo(75, 88, 75, 85);

    canvas.drawPath(
      platePath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFBF8),
            Color(0xFFF8F3EE),
          ],
        ).createShader(const Rect.fromLTWH(75, 85, 20, 5)),
    );

    canvas.drawPath(
      platePath,
      Paint()
        ..color = AppColors.line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    _drawWaffle(canvas, const Offset(85, 80));
  }

  void _drawWaffle(Canvas canvas, Offset center) {
    const waffleSize = 14.0;
    final waffleRect = Rect.fromCenter(center: center, width: waffleSize, height: waffleSize);
    final waffleRRect = RRect.fromRectAndRadius(waffleRect, const Radius.circular(3));

    canvas.drawRRect(
      waffleRRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF2D098),
            Color(0xFFE8C98A),
            Color(0xFFD4A85A),
          ],
        ).createShader(waffleRect),
    );

    final gridPaint = Paint()
      ..color = AppColors.wafflePocket
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const cells = 3;
    const cellSize = waffleSize / cells;

    for (var i = 1; i < cells; i++) {
      canvas.drawLine(
        Offset(waffleRect.left + i * cellSize, waffleRect.top),
        Offset(waffleRect.left + i * cellSize, waffleRect.bottom),
        gridPaint,
      );
      canvas.drawLine(
        Offset(waffleRect.left, waffleRect.top + i * cellSize),
        Offset(waffleRect.right, waffleRect.top + i * cellSize),
        gridPaint,
      );
    }

    final colors = [Palette.colors[0], Palette.colors[2], Palette.colors[3]];
    final positions = [
      Offset(center.dx - 4, center.dy - 3),
      Offset(center.dx + 3, center.dy - 2),
      Offset(center.dx, center.dy + 3),
    ];

    for (var i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final color = colors[i];

      canvas.drawCircle(
        pos + const Offset(0.3, 0.4),
        1.8,
        Paint()
          ..color = const Color(0x553A2418)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5),
      );

      canvas.drawCircle(
        pos,
        1.8,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.35, -0.4),
            radius: 1.0,
            colors: [
              Color.lerp(color, Colors.white, 0.3)!,
              color,
            ],
          ).createShader(Rect.fromCircle(center: pos, radius: 1.8)),
      );

      canvas.drawCircle(
        pos + const Offset(-0.5, -0.6),
        0.6,
        Paint()..color = Colors.white.withValues(alpha: 0.75),
      );

      for (var j = 0; j < 3; j++) {
        final angle = j * math.pi * 2 / 3;
        final sparkPos = pos + Offset(math.cos(angle) * 1.2, math.sin(angle) * 1.2);
        canvas.drawCircle(
          sparkPos,
          0.3,
          Paint()..color = Colors.white.withValues(alpha: 0.85),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
