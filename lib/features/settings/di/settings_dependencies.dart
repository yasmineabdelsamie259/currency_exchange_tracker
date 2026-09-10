import '../../../core/di/core_dependencies.dart';
import '../data/datasources/settings_local_data_source.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/usecases/load_theme_preference.dart';
import '../domain/usecases/save_theme_preference.dart';
import '../presentation/bloc/theme_cubit.dart';

final class SettingsDependencies {
  SettingsDependencies(CoreDependencies core)
    : _repository = SettingsRepositoryImpl(
        SettingsLocalDataSource(core.storage),
      );

  final SettingsRepositoryImpl _repository;

  ThemeCubit createThemeCubit() => ThemeCubit(
    loadThemePreference: LoadThemePreference(_repository),
    saveThemePreference: SaveThemePreference(_repository),
  );
}
