import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) => throw UnimplementedError(
  'Override settingsRepository in the app composition root.',
);

@riverpod
class AppSettingsController extends _$AppSettingsController {
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
