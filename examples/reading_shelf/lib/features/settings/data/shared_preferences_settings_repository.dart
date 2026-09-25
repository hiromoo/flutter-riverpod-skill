import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  SharedPreferencesSettingsRepository(this._preferences);

  final SharedPreferencesAsync _preferences;

  static const _localeKey = 'localePreference';
  static const _themeKey = 'themePreference';

  @override
  Future<AppSettings> load() async {
    final localeName = await _preferences.getString(_localeKey);
    final themeName = await _preferences.getString(_themeKey);
    return AppSettings(
      locale: LocalePreference.values.firstWhere(
        (value) => value.name == localeName,
        orElse: () => LocalePreference.system,
      ),
      theme: ThemePreference.values.firstWhere(
        (value) => value.name == themeName,
        orElse: () => ThemePreference.system,
      ),
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _preferences.setString(_localeKey, settings.locale.name);
    await _preferences.setString(_themeKey, settings.theme.name);
  }
}
