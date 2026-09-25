import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

enum LocalePreference { system, english, japanese }

enum ThemePreference { system, light, dark }

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(LocalePreference.system) LocalePreference locale,
    @Default(ThemePreference.system) ThemePreference theme,
  }) = _AppSettings;
}
