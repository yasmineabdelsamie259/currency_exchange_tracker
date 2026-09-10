import '../domain/entities/exchange_rates.dart';
import '../domain/usecases/get_currency_history.dart';
import '../presentation/detail/bloc/currency_detail_bloc.dart';
import '../../../core/di/core_dependencies.dart';
import '../data/repositories/exchange_rates_repository_impl.dart';
import '../domain/repositories/exchange_rates_repository.dart';
import '../domain/usecases/get_exchange_rates.dart';
import '../presentation/list/bloc/exchange_rates_bloc.dart';
import '../data/datasources/exchange_rates_local_data_source.dart';
import '../data/datasources/exchange_rates_remote_data_source.dart';

final class ExchangeRatesDependencies {
  ExchangeRatesDependencies(CoreDependencies core)
    : remote = ExchangeRatesRemoteDataSource(core.network),
      local = ExchangeRatesLocalDataSource(core.storage),
      networkChanges = core.networkMonitor.changes;

  final Stream<bool> networkChanges;
  final ExchangeRatesRemoteDataSource remote;
  final ExchangeRatesLocalDataSource local;

  late final ExchangeRatesRepository repository = ExchangeRatesRepositoryImpl(
    remote,
    local,
  );

  CurrencyDetailBloc createDetailBloc(
    Currency currency, {
    ExchangeRates? initial,
  }) => CurrencyDetailBloc(
    currency: currency,
    initial: initial,
    getRates: GetExchangeRates(repository),
    getHistory: GetCurrencyHistory(repository),
    networkChanges: networkChanges,
  );

  ExchangeRatesBloc createBloc() => ExchangeRatesBloc(
    GetExchangeRates(repository),
    networkChanges: networkChanges,
  );
}
