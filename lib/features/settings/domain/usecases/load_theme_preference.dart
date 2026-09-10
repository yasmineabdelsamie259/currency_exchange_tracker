import '../entities/app_theme_preference.dart';
import '../repositories/settings_repository.dart';

final class LoadThemePreference {
  const LoadThemePreference(this._repository);

  final SettingsRepository _repository;

  Future<AppThemePreference> call() => _repository.loadThemePreference();
}
