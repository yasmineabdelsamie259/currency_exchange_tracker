import '../../../../core/storage/key_value_store.dart';
import '../../domain/entities/app_theme_preference.dart';

final class SettingsLocalDataSource {
  const SettingsLocalDataSource(this._storage);

  static const _themePreferenceKey = 'settings.theme-preference.v1';

  final KeyValueStore _storage;

  Future<AppThemePreference> loadThemePreference() async =>
      AppThemePreference.fromStorage(await _storage.read(_themePreferenceKey));

  Future<void> saveThemePreference(AppThemePreference preference) =>
      _storage.write(_themePreferenceKey, preference.storageValue);
}
