import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics/analytics_service.dart';
import 'app_scope.dart';
import 'config/app_config.dart';
import 'config/app_theme.dart';
import 'config/tokens.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'screens/levels_screen.dart';
import 'screens/play_screen.dart';
import 'screens/settings_screen.dart';
import 'services/audio_service.dart';
import 'services/progress_store.dart';
import 'services/settings_service.dart';

class ColorLinksApp extends StatelessWidget {
  const ColorLinksApp({required this.services, this.home, super.key});

  final AppServices services;
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: services.settings,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.current,
          locale: services.settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeResolutionCallback: _resolveLocale,
          builder: (context, child) {
            return AppScope(
              services: services,
              child: _SessionHost(child: child ?? const SizedBox.shrink()),
            );
          },
          home: home ?? const HomeScreen(),
          onGenerateRoute: _route,
        );
      },
    );
  }

  static Locale _resolveLocale(Locale? device, Iterable<Locale> supported) {
    if (device != null) {
      for (final locale in supported) {
        if (locale.languageCode == device.languageCode) return locale;
      }
    }
    return const Locale('en');
  }

  static Route<void> _route(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.settings => MaterialPageRoute<void>(settings: settings, builder: (_) => const SettingsScreen()),
      AppRoutes.howTo => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => HowToPlayScreen(firstRun: settings.arguments == true),
      ),
      AppRoutes.levels => MaterialPageRoute<void>(settings: settings, builder: (_) => const LevelsScreen()),
      AppRoutes.play => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => PlayScreen(levelIndex: settings.arguments is int ? settings.arguments! as int : 0),
      ),
      _ => MaterialPageRoute<void>(settings: settings, builder: (_) => const HomeScreen()),
    };
  }
}

class _SessionHost extends StatefulWidget {
  const _SessionHost({required this.child});

  final Widget child;

  @override
  State<_SessionHost> createState() => _SessionHostState();
}

class _SessionHostState extends State<_SessionHost> with WidgetsBindingObserver {
  SettingsService? _settings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = AppScope.of(context).settings;
    if (!identical(settings, _settings)) {
      _settings?.removeListener(_sync);
      _settings = settings;
      settings.addListener(_sync);
      _sync();
    }
  }

  void _sync() {
    final settings = _settings;
    if (settings == null) return;
    unawaited(AppScope.read(context).audio.apply(soundOn: settings.sound, musicOn: settings.music));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final audio = AppScope.read(context).audio;
    if (state == AppLifecycleState.resumed) {
      unawaited(audio.resume());
      return;
    }
    unawaited(audio.pause());
  }

  @override
  void dispose() {
    _settings?.removeListener(_sync);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      systemNavigationBarColor: AppColors.background,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await _guarded('orientation', () => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));

  SettingsService? settings;
  await _guarded('settings', () async {
    settings = await SettingsService.create();
  });
  settings ??= await _inMemorySettings();
  final progress = ProgressStore(settings!.prefs);
  final audio = AudioService();
  await audio.prepare();
  runApp(ColorLinksApp(services: AppServices(settings: settings!, progress: progress, audio: audio)));
  unawaited(AnalyticsService.instance.start(settings!.prefs).catchError((Object _) {}));
}

Future<void> _guarded(String label, Future<void> Function() step) async {
  try {
    await step().timeout(AppMotion.startup);
  } catch (error, stack) {
    debugPrint('startup $label failed: $error\n$stack');
  }
}

Future<SettingsService> _inMemorySettings() async {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(<String, Object>{});
  return SettingsService(await SharedPreferences.getInstance());
}
