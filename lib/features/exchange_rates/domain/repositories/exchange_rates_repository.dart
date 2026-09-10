import '../entities/exchange_rates.dart';
import '../entities/currency_history.dart';

abstract interface class ExchangeRatesRepository {
  Future<ExchangeRates> load();
  Future<CurrencyHistory> loadHistory(
    Currency currency, {
    bool refresh = false,
  });
}
