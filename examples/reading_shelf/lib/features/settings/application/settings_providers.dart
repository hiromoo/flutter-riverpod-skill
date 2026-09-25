import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => throw UnimplementedError('Override settingsRepository in the app composition root.'),
);

final appSettingsControllerProvider = AsyncNotifierProvider<AppSettingsController, AppSettings>(
  AppSettingsController.new,
);

class AppSettingsController extends AsyncNotifier<AppSettings> {
  Future<void> _pendingWrites = Future<void>.value();

  @override
  Future<AppSettings> build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> saveSettings(AppSettings settings) {
    final completer = Completer<void>();
    _pendingWrites = _pendingWrites.then((_) async {
      final previous = state;
      state = AsyncData(settings);
      try {
        await ref.read(settingsRepositoryProvider).save(settings);
        completer.complete();
      } catch (error, stackTrace) {
        state = previous;
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }
}
