import '../entities/exchange_rates.dart';
import '../repositories/exchange_rates_repository.dart';

final class GetExchangeRates {
  const GetExchangeRates(this.repository);
  final ExchangeRatesRepository repository;
  Future<ExchangeRates> call() => repository.load();
}
