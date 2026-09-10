import '../entities/app_theme_preference.dart';
import '../repositories/settings_repository.dart';

final class SaveThemePreference {
  const SaveThemePreference(this._repository);

  final SettingsRepository _repository;

  Future<void> call(AppThemePreference preference) =>
      _repository.saveThemePreference(preference);
}
