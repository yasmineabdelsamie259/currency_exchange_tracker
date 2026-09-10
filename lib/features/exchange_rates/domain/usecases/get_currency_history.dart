import '../entities/currency_history.dart';
import '../entities/exchange_rates.dart';
import '../repositories/exchange_rates_repository.dart';

final class GetCurrencyHistory {
  const GetCurrencyHistory(this.repository);
  final ExchangeRatesRepository repository;
  Future<CurrencyHistory> call(Currency currency, {bool refresh = false}) =>
      repository.loadHistory(currency, refresh: refresh);
}
