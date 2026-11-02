import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
              height: 48,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: l10n.back,
                  ),
                  Expanded(child: Text(l10n.settings, style: theme.titleLarge)),
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
                            leading: const Icon(Icons.translate_rounded),
                            title: Text(l10n.settingsLanguage),
                            subtitle: Text(
                              lang == null ? l10n.settingsLanguageSystem : SettingsService.languageNames[lang]!,
                            ),
                            onTap: () => _pickLanguage(context),
                          ),
                          SwitchListTile(
                            secondary: const Icon(Icons.volume_up_rounded),
                            title: Text(l10n.settingsSound),
                            value: settings.sound,
                            onChanged: settings.setSound,
                          ),
                          SwitchListTile(
                            secondary: const Icon(Icons.music_note_rounded),
                            title: Text(l10n.settingsMusic),
                            value: settings.music,
                            onChanged: settings.setMusic,
                          ),
                          SwitchListTile(
                            secondary: const Icon(Icons.vibration_rounded),
                            title: Text(l10n.settingsHaptics),
                            value: settings.haptics,
                            onChanged: settings.setHaptics,
                          ),
                        ],
                      ),
                      _Section(l10n.settingsAccessibility),
                      _Card(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.settingsReduceMotion, style: theme.titleMedium),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final choice in ReduceMotionPref.values)
                                      ChoiceChip(
                                        label: Text(_motionLabel(l10n, choice)),
                                        selected: settings.reduceMotion == choice,
                                        onSelected: (_) => settings.setReduceMotion(choice),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _Section(l10n.settingsGame),
                      _Card(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.school_outlined),
                            title: Text(l10n.howToPlay),
                            onTap: () => Navigator.of(context).pushNamed(AppRoutes.howTo, arguments: false),
                          ),
                          ListTile(
                            leading: const Icon(Icons.restart_alt_rounded),
                            title: Text(l10n.resetProgress),
                            subtitle: Text(l10n.resetProgressBody),
                            onTap: () => _resetProgress(context),
                          ),
                        ],
                      ),
                      _Section(l10n.settingsAbout),
                      _Card(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.privacy_tip_outlined),
                            title: Text(l10n.settingsPrivacy),
                            onTap: () => _openPrivacy(context),
                          ),
                          ListTile(
                            leading: const Icon(Icons.info_outline_rounded),
                            title: Text(l10n.developer),
                          ),
                          ListTile(
                            leading: const Icon(Icons.tag_rounded),
                            title: Text(l10n.settingsVersion),
                            subtitle: FutureBuilder<PackageInfo>(
                              future: _info,
                              builder: (context, snapshot) {
                                final info = snapshot.data;
                                if (info == null) return const Text('…');
                                return Text('${info.version} (${info.buildNumber})');
                              },
                            ),
                          ),
                        ],
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

  String _motionLabel(AppLocalizations l10n, ReduceMotionPref choice) => switch (choice) {
    ReduceMotionPref.system => l10n.motionSystem,
    ReduceMotionPref.on => l10n.motionOn,
    ReduceMotionPref.off => l10n.motionOff,
  };

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

  Future<void> _resetProgress(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetProgress),
        content: Text(l10n.resetProgressBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.resetAction)),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await AppScope.read(context).progress.resetAll();
  }

  Future<void> _openPrivacy(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final opened = await launchUrl(Uri.parse(AppIdentity.privacyUrl), mode: LaunchMode.externalApplication);
    if (opened || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.openFailed)));
  }
}

class _Section extends StatelessWidget {
  const _Section(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
      child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimens.radius),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}
