import '../../domain/entities/app_theme_preference.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

final class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<AppThemePreference> loadThemePreference() =>
      _localDataSource.loadThemePreference();

  @override
  Future<void> saveThemePreference(AppThemePreference preference) =>
      _localDataSource.saveThemePreference(preference);
}
