import '../../../../core/error/data_source_exception.dart';
import '../../../../core/utilities/calendar_date.dart';
import '../../domain/entities/exchange_rates.dart';

final class RateSnapshot {
  RateSnapshot(this.date, this.rates);
  final DateTime date;
  final Map<Currency, double> rates;

  factory RateSnapshot.parse(Map<String, dynamic> json) {
    final date = json['date'];
    final values = json['egp'];
    final parsed = date is String ? DateTime.tryParse(date) : null;
    if (parsed == null ||
        date != calendarDate(parsed) ||
        values is! Map<String, dynamic>) {
      throw const DataSourceException(DataSourceFailure.invalidData);
    }
    final rates = <Currency, double>{};
    for (final currency in Currency.values) {
      final value = values[currency.code.toLowerCase()];
      if (value is num && value.isFinite && value > 0) {
        final inverse = 1 / value;
        if (inverse.isFinite) rates[currency] = inverse;
      }
    }
    return RateSnapshot(
      DateTime.utc(parsed.year, parsed.month, parsed.day),
      rates,
    );
  }
}
