import 'package:get_it/get_it.dart';

import '../../features/exchange_rates/di/exchange_rates_dependencies.dart';
import '../../features/settings/di/settings_dependencies.dart';
import 'core_dependencies.dart';

final serviceLocator = GetIt.instance;

void configureServiceLocator({CoreDependencies? core}) {
  if (serviceLocator.isRegistered<CoreDependencies>()) return;

  serviceLocator.registerSingleton<CoreDependencies>(
    core ?? CoreDependencies.production(),
    dispose: (dependencies) => dependencies.dispose(),
  );
  registerExchangeRatesDependencies(serviceLocator);
  registerSettingsDependencies(serviceLocator);
}
