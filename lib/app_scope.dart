import 'package:flutter/widgets.dart';

import 'services/audio_service.dart';
import 'services/progress_store.dart';
import 'services/settings_service.dart';

class AppServices {
  AppServices({required this.settings, required this.progress, required this.audio});

  final SettingsService settings;
  final ProgressStore progress;
  final AudioService audio;
}

class AppScope extends InheritedNotifier<SettingsService> {
  AppScope({required this.services, required super.child, super.key}) : super(notifier: services.settings);

  final AppServices services;

  static AppServices of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.services;

  static AppServices read(BuildContext context) => context.getInheritedWidgetOfExactType<AppScope>()!.services;
}
