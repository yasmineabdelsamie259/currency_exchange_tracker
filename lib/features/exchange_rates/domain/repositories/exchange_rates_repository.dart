import '../entities/exchange_rates.dart';

abstract interface class ExchangeRatesRepository {
  Future<ExchangeRates> load();
}
