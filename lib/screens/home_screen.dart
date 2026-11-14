import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../game/levels.dart';
import '../l10n/app_localizations.dart';
import '../widgets/banner_slot.dart';
import '../widgets/chef_mascot.dart';

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.page),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: AppDimens.maxContent),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 12),
                          const Center(child: ChefMascot(size: 100)),
                          const SizedBox(height: 24),
                          Text('ChromaPath', style: theme.headlineLarge, textAlign: TextAlign.center),
                          const SizedBox(height: 4),
                          Text('Connect Puzzle', style: theme.titleLarge, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          Text(l10n.homeTagline, style: theme.titleMedium, textAlign: TextAlign.center),
                          const SizedBox(height: 24),
                          ListenableBuilder(
                            listenable: services.progress,
                            builder: (context, _) {
                              final progress = services.progress;
                              final fraction = progress.frontier / progress.stars.length;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    progress.finishedAll
                                        ? l10n.allClear
                                        : l10n.progressLabel(progress.currentNumber, Levels.all.length),
                                    style: theme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(99),
                                    child: Container(
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: AppColors.blush,
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: fraction.clamp(0.0, 1.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [AppColors.berry, Color(0xFFE89A5A), AppColors.gold],
                                              stops: [0.0, 0.5, 1.0],
                                            ),
                                            borderRadius: BorderRadius.circular(99),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  FilledButton(
                                    onPressed: () => _play(context),
                                    child: Text(progress.finishedAll ? l10n.playAgain : l10n.play),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppColors.surface,
                                      side: const BorderSide(color: AppColors.gold, width: 2),
                                    ),
                                    onPressed: () {
                                      services.audio.unlock();
                                      AnalyticsService.instance.logScreen(AnalyticsValues.levels);
                                      Navigator.of(context).pushNamed(AppRoutes.levels);
                                    },
                                    child: Text(l10n.levels),
                                  ),
                                  const SizedBox(height: 12),
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
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
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

class _WaffleMotif extends StatelessWidget {
  const _WaffleMotif();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: CustomPaint(painter: _WaffleMotifPainter()),
    );
  }
}

class _WaffleMotifPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final body = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.22));
    
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
        ).createShader(rect),
    );

    final cell = size.width / 5;
    final ridge = cell * 0.13;
    final pocketRadius = Radius.circular(cell * 0.16);
    
    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < 5; col++) {
        final pocketRect = Rect.fromLTWH(col * cell + ridge, row * cell + ridge, cell - ridge * 2, cell - ridge * 2);
        final pocket = RRect.fromRectAndRadius(pocketRect, pocketRadius);

        canvas.drawRRect(
          pocket.shift(Offset(cell * 0.015, cell * 0.02)),
          Paint()
            ..color = const Color(0x4D3A2418)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, cell * 0.03),
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
            ).createShader(pocketRect),
        );

        canvas.save();
        canvas.clipRRect(pocket);
        canvas.drawRect(
          pocketRect,
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
            ).createShader(pocketRect),
        );
        canvas.restore();
      }
    }

    final pathWidth = size.width * 0.08;
    
    final berryPath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.25)
      ..lineTo(size.width * 0.5, size.height * 0.25)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.75, size.height * 0.5);

    canvas.drawPath(
      berryPath.shift(Offset(pathWidth * 0.15, pathWidth * 0.15)),
      Paint()
        ..color = const Color(0x553A2418)
        ..style = PaintingStyle.stroke
        ..strokeWidth = pathWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, pathWidth * 0.2),
    );

    canvas.drawPath(
      berryPath,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 1.0,
          colors: [
            const Color(0xFFFF8FA3),
            const Color(0xFFE86B86),
          ],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = pathWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final mintPath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.75)
      ..lineTo(size.width * 0.5, size.height * 0.75)
      ..lineTo(size.width * 0.5, size.height * 0.5);

    canvas.drawPath(
      mintPath.shift(Offset(pathWidth * 0.15, pathWidth * 0.15)),
      Paint()
        ..color = const Color(0x553A2418)
        ..style = PaintingStyle.stroke
        ..strokeWidth = pathWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, pathWidth * 0.2),
    );

    canvas.drawPath(
      mintPath,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 1.0,
          colors: [
            const Color(0xFF8EE8D4),
            const Color(0xFF6ED4B8),
          ],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = pathWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final dollopRadius = size.width * 0.075;
    final dollops = [
      (Offset(size.width * 0.25, size.height * 0.25), Palette.colors[0]),
      (Offset(size.width * 0.75, size.height * 0.5), Palette.colors[0]),
      (Offset(size.width * 0.25, size.height * 0.75), Palette.colors[2]),
      (Offset(size.width * 0.5, size.height * 0.5), Palette.colors[2]),
    ];

    for (final (center, color) in dollops) {
      canvas.drawCircle(
        center + Offset(dollopRadius * 0.1, dollopRadius * 0.15),
        dollopRadius,
        Paint()
          ..color = const Color(0x553A2418)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, dollopRadius * 0.2),
      );

      canvas.drawCircle(
        center,
        dollopRadius,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.35, -0.4),
            radius: 1.0,
            colors: [
              Color.lerp(color, Colors.white, 0.2)!,
              color,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: dollopRadius)),
      );

      canvas.drawCircle(
        center + Offset(-dollopRadius * 0.3, -dollopRadius * 0.35),
        dollopRadius * 0.35,
        Paint()..color = Colors.white.withValues(alpha: 0.65),
      );
    }

    canvas.drawRRect(
      body.deflate(size.width * 0.02),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF5D8A8),
            Color(0xFFE8C98A),
          ],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.055,
    );

    canvas.drawRRect(
      body.deflate(size.width * 0.025),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.02,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SugarPainter extends CustomPainter {
  _SugarPainter({required this.color});

  final Color color;

  static const List<Color> _sugar = [
    Color(0xFFFFFBF5),
    Color(0xFFFFF3D4),
    Color(0xFFE7FBFF),
    Color(0xFFFFE4EF),
    Color(0xFFFFFFFF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final random = math.Random(color.hashCode & 0x7fffffff);
    for (var i = 0; i < 8; i++) {
      final angle = random.nextDouble() * math.pi * 2;
      final dist = random.nextDouble() * radius * 0.65;
      final sparkRadius = radius * (0.07 + random.nextDouble() * 0.05);
      final sparkColor =
          _sugar[random.nextInt(_sugar.length)].withValues(alpha: 0.75 + random.nextDouble() * 0.25);
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * dist,
        sparkRadius,
        Paint()..color = sparkColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SugarPainter oldDelegate) => oldDelegate.color != color;
}
