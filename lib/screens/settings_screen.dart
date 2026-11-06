import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../analytics/analytics_events.dart';
import '../analytics/analytics_service.dart';
import '../app_scope.dart';
import '../config/app_config.dart';
import '../config/tokens.dart';
import '../l10n/app_localizations.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final Future<PackageInfo> _info = PackageInfo.fromPlatform();

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreen(AnalyticsValues.settings);
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppScope.of(context).settings;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final lang = settings.language;

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
                  Expanded(
                    child: Text(l10n.settings, style: theme.titleLarge?.copyWith(fontSize: 24)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppDimens.maxContent),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(AppDimens.page, 8, AppDimens.page, 32),
                    children: [
                      _Section(l10n.settingsGeneral),
                      _Card(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            title: Text(l10n.settingsLanguage),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  lang == null ? l10n.settingsLanguageSystem : SettingsService.languageNames[lang]!,
                                  style: theme.bodyMedium,
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded, size: 20),
                              ],
                            ),
                            onTap: () => _pickLanguage(context),
                          ),
                          const Divider(height: 1),
                          _ToggleTile(
                            title: l10n.settingsSound,
                            value: settings.sound,
                            onChanged: settings.setSound,
                          ),
                          const Divider(height: 1),
                          _ToggleTile(
                            title: l10n.settingsMusic,
                            value: settings.music,
                            onChanged: settings.setMusic,
                          ),
                          const Divider(height: 1),
                          _ToggleTile(
                            title: l10n.settingsHaptics,
                            value: settings.haptics,
                            onChanged: settings.setHaptics,
                          ),
                        ],
                      ),
                      _Section(l10n.settingsGame),
                      _Card(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            title: Text(l10n.howToPlay),
                            trailing: const Icon(Icons.arrow_forward_rounded, size: 20, color: AppColors.gold),
                            onTap: () => Navigator.of(context).pushNamed(AppRoutes.howTo, arguments: false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      FutureBuilder<PackageInfo>(
                        future: _info,
                        builder: (context, snapshot) {
                          final info = snapshot.data;
                          final version = info?.version ?? '…';
                          return Column(
                            children: [
                              Text('ChromaPath  $version', style: theme.bodyMedium, textAlign: TextAlign.center),
                              const SizedBox(height: 4),
                              Text(l10n.developer, style: theme.bodyMedium, textAlign: TextAlign.center),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final settings = AppScope.read(context).settings;
    final l10n = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.62,
            child: ListView(
              children: [
                ListTile(
                  title: Text(l10n.settingsLanguageSystem),
                  trailing: settings.language == null ? const Icon(Icons.check_rounded) : null,
                  onTap: () => Navigator.of(context).pop(''),
                ),
                for (final code in SettingsService.supportedLanguages)
                  ListTile(
                    title: Text(SettingsService.languageNames[code]!),
                    trailing: settings.language == code ? const Icon(Icons.check_rounded) : null,
                    onTap: () => Navigator.of(context).pop(code),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (selected == null) return;
    await settings.setLanguage(selected.isEmpty ? null : selected);
  }
}

class _Section extends StatelessWidget {
  const _Section(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        boxShadow: const [BoxShadow(color: Color(0x146B4632), blurRadius: 16, offset: Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radius),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _WaffleTexturePainter())),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radius),
              clipBehavior: Clip.antiAlias,
              child: Column(children: children),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaffleTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.waffle.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    const cell = 20.0;
    const gap = 3.0;
    final cols = (size.width / cell).ceil();
    final rows = (size.height / cell).ceil();

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(col * cell + gap, row * cell + gap, cell - gap * 2, cell - gap * 2),
          const Radius.circular(2),
        );
        canvas.drawRRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({required this.title, required this.value, required this.onChanged});

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(title),
      trailing: _FrostingToggle(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
    );
  }
}

class _FrostingToggle extends StatelessWidget {
  const _FrostingToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 32,
        decoration: BoxDecoration(
          gradient: value
              ? const RadialGradient(
                  center: Alignment(-0.3, -0.3),
                  radius: 1.2,
                  colors: [Color(0xFFFFD5E0), Color(0xFFE86B86)],
                )
              : null,
          color: value ? null : AppColors.line,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (value ? AppColors.berry : AppColors.faint).withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              boxShadow: const [
                BoxShadow(color: Color(0x33000000), blurRadius: 3, offset: Offset(0, 1)),
              ],
            ),
            child: value
                ? CustomPaint(painter: _SprinklePainter(seed: 42))
                : null,
          ),
        ),
      ),
    );
  }
}

class _SprinklePainter extends CustomPainter {
  _SprinklePainter({required this.seed});

  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final colors = [
      const Color(0xFFFFF3D4),
      const Color(0xFFFFE4EF),
      Colors.white,
    ];

    canvas.drawCircle(center + Offset(-radius * 0.28, -radius * 0.28), radius * 0.22, Paint()..color = Colors.white.withValues(alpha: 0.6));
    canvas.drawCircle(center + Offset(radius * 0.2, radius * 0.15), radius * 0.15, Paint()..color = colors[0].withValues(alpha: 0.7));
    canvas.drawCircle(center + Offset(-radius * 0.1, radius * 0.25), radius * 0.12, Paint()..color = colors[1].withValues(alpha: 0.8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

