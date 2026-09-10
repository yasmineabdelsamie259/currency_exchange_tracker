import 'package:get_it/get_it.dart';

import '../../../core/di/core_dependencies.dart';
import '../data/datasources/exchange_rates_local_data_source.dart';
import '../data/datasources/exchange_rates_remote_data_source.dart';
import '../data/repositories/exchange_rates_repository_impl.dart';
import '../domain/entities/exchange_rates.dart';
import '../domain/repositories/exchange_rates_repository.dart';
import '../domain/usecases/get_currency_history.dart';
import '../domain/usecases/get_exchange_rates.dart';
import '../presentation/detail/bloc/currency_detail_bloc.dart';
import '../presentation/list/bloc/exchange_rates_bloc.dart';

void registerExchangeRatesDependencies(GetIt locator) {
  locator.registerLazySingleton(
    () => ExchangeRatesRemoteDataSource(locator<CoreDependencies>().network),
  );
  locator.registerLazySingleton(
    () => ExchangeRatesLocalDataSource(locator<CoreDependencies>().storage),
  );
  locator.registerLazySingleton<ExchangeRatesRepository>(
    () => ExchangeRatesRepositoryImpl(
      locator<ExchangeRatesRemoteDataSource>(),
      locator<ExchangeRatesLocalDataSource>(),
    ),
  );
  locator.registerFactory(
    () => ExchangeRatesBloc(
      GetExchangeRates(locator<ExchangeRatesRepository>()),
      networkChanges: locator<CoreDependencies>().networkMonitor.changes,
    ),
  );
  locator.registerFactoryParam<CurrencyDetailBloc, Currency, ExchangeRates?>(
    (currency, initial) => CurrencyDetailBloc(
      currency: currency,
      initial: initial,
      getRates: GetExchangeRates(locator<ExchangeRatesRepository>()),
      getHistory: GetCurrencyHistory(locator<ExchangeRatesRepository>()),
      networkChanges: locator<CoreDependencies>().networkMonitor.changes,
    ),
  );
}
