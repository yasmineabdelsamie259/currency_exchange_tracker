import 'package:get_it/get_it.dart';

import '../../../core/di/core_dependencies.dart';
import '../data/datasources/settings_local_data_source.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/usecases/load_theme_preference.dart';
import '../domain/usecases/save_theme_preference.dart';
import '../presentation/bloc/theme_cubit.dart';

void registerSettingsDependencies(GetIt locator) {
  locator.registerLazySingleton(
    () => SettingsLocalDataSource(locator<CoreDependencies>().storage),
  );
  locator.registerLazySingleton(
    () => SettingsRepositoryImpl(locator<SettingsLocalDataSource>()),
  );
  locator.registerLazySingleton(
    () => ThemeCubit(
      loadThemePreference: LoadThemePreference(
        locator<SettingsRepositoryImpl>(),
      ),
      saveThemePreference: SaveThemePreference(
        locator<SettingsRepositoryImpl>(),
      ),
    ),
    dispose: (cubit) => cubit.close(),
  );
}
