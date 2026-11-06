import 'package:chroma_path/app.dart';
import 'package:chroma_path/app_scope.dart';
import 'package:chroma_path/screens/home_screen.dart';
import 'package:chroma_path/screens/how_to_play_screen.dart';
import 'package:chroma_path/screens/levels_screen.dart';
import 'package:chroma_path/screens/play_screen.dart';
import 'package:chroma_path/screens/settings_screen.dart';
import 'package:chroma_path/services/audio_service.dart';
import 'package:chroma_path/services/progress_store.dart';
import 'package:chroma_path/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<AppServices> services() async {
    final settings = SettingsService(await SharedPreferences.getInstance());
    await settings.setLanguage('en');
    await settings.setOnboardingDone(true);
    return AppServices(settings: settings, progress: ProgressStore(settings.prefs), audio: AudioService());
  }

  Future<void> pumpSmall(WidgetTester tester, Widget home) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(ChromaPathApp(services: await services(), home: home));
    await tester.pump();
    expect(tester.takeException(), isNull);
  }

  testWidgets('home fits 320x568', (tester) async {
    await pumpSmall(tester, const HomeScreen());
  });

  testWidgets('play fits 320x568', (tester) async {
    await pumpSmall(tester, const PlayScreen(levelIndex: 0));
    expect(find.text('Level 1'), findsOneWidget);
  });

  testWidgets('levels fit 320x568', (tester) async {
    await pumpSmall(tester, const LevelsScreen());
  });

  testWidgets('how to fits 320x568', (tester) async {
    await pumpSmall(tester, const HowToPlayScreen(firstRun: false));
  });

  testWidgets('settings fit 320x568', (tester) async {
    await pumpSmall(tester, const SettingsScreen());
  });
}
