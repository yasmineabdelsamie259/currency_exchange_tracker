import '../entities/app_theme_preference.dart';

abstract interface class SettingsRepository {
  Future<AppThemePreference> loadThemePreference();
  Future<void> saveThemePreference(AppThemePreference preference);
}
