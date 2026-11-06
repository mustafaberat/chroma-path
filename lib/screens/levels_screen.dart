import 'package:flutter/material.dart';

import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../game/levels.dart';
import '../l10n/app_localizations.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final progress = AppScope.of(context).progress;
    final wide = MediaQuery.sizeOf(context).width >= AppDimens.wide;
    final columns = wide ? 8 : 5;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.chevron_left_rounded, size: 32),
                    tooltip: l10n.back,
                    color: AppColors.ink,
                  ),
                  const SizedBox(width: 4),
                  Expanded(child: Text(l10n.levels, style: theme.titleLarge?.copyWith(fontSize: 24))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.page, 0, AppDimens.page, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  progress.finishedAll
                      ? l10n.allClear
                      : l10n.progressLabel(progress.currentNumber, Levels.all.length),
                  style: theme.bodyMedium,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: wide ? 840 : AppDimens.maxContent),
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(AppDimens.page, 8, AppDimens.page, 32),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: Levels.all.length,
                    itemBuilder: (context, index) {
                      final unlocked = progress.isUnlocked(index);
                      final stars = progress.stars[index];
                      final current = index == progress.frontier;
                      final levelName = l10n.levelLabel(index + 1);
                      return _LevelTile(
                        number: index + 1,
                        stars: stars,
                        unlocked: unlocked,
                        current: current,
                        label: unlocked
                            ? (stars > 0
                                ? '$levelName, ${l10n.starsLabel(stars)}'
                                : current
                                    ? '$levelName, ${l10n.currentLevel}'
                                    : levelName)
                            : '$levelName, ${l10n.lockedLevel}',
                        onTap: unlocked
                            ? () {
                                AppScope.read(context).audio.unlock();
                                AnalyticsService.instance.logPlayTap(index + 1);
                                Navigator.of(context).pushNamed(AppRoutes.play, arguments: index);
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.number,
    required this.stars,
    required this.unlocked,
    required this.current,
    required this.label,
    required this.onTap,
  });

  final int number;
  final int stars;
  final bool unlocked;
  final bool current;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      enabled: unlocked,
      label: label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: current ? AppColors.berry.withValues(alpha: 0.25) : const Color(0x146B4632),
              blurRadius: current ? 12 : 8,
              offset: Offset(0, current ? 4 : 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                if (unlocked)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WaffleTilePainter(),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: unlocked ? AppColors.surface.withValues(alpha: 0.93) : AppColors.blush,
                    borderRadius: BorderRadius.circular(16),
                    border: current
                        ? Border.all(color: AppColors.berry, width: 2.5)
                        : Border.all(color: AppColors.line, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (unlocked) ...[
                        Text(
                          '$number',
                          style: theme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: current ? 22 : 16,
                            color: current ? AppColors.berry : AppColors.ink,
                          ),
                        ),
                      ] else
                        Icon(Icons.lock_rounded, color: AppColors.faint.withValues(alpha: 0.5), size: 20),
                      const SizedBox(height: 4),
                      if (stars > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < 3; i++)
                              Icon(
                                i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                                size: 14,
                                color: i < stars ? AppColors.gold : AppColors.faint,
                              ),
                          ],
                        )
                      else
                        const SizedBox(height: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WaffleTilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.waffle.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    const cell = 12.0;
    const gap = 2.0;
    final cols = (size.width / cell).ceil();
    final rows = (size.height / cell).ceil();

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(col * cell + gap, row * cell + gap, cell - gap * 2, cell - gap * 2),
          const Radius.circular(1.5),
        );
        canvas.drawRRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
