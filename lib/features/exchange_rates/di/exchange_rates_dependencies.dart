import '../../../core/di/core_dependencies.dart';
import '../data/datasources/exchange_rates_local_data_source.dart';
import '../data/datasources/exchange_rates_remote_data_source.dart';

final class ExchangeRatesDependencies {
  ExchangeRatesDependencies(CoreDependencies core)
    : remote = ExchangeRatesRemoteDataSource(core.network),
      local = ExchangeRatesLocalDataSource(core.storage);

  final ExchangeRatesRemoteDataSource remote;
  final ExchangeRatesLocalDataSource local;

  // Add the repository, use cases, and BLoC factories here with their feature.
}
