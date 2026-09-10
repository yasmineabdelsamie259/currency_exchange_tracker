enum Currency {
  usd('USD', 'US Dollar', r'$'),
  eur('EUR', 'Euro', '€'),
  gbp('GBP', 'British Pound', '£'),
  sar('SAR', 'Saudi Riyal', 'ر.س'),
  jpy('JPY', 'Japanese Yen', '¥');

  const Currency(this.code, this.label, this.symbol);
  final String code;
  final String label;
  final String symbol;
}

final class RateQuote {
  const RateQuote(this.currency, this.rate, this.previous);
  final Currency currency;
  final double? rate;
  final double? previous;
  double? get change =>
      rate != null && previous != null ? rate! - previous! : null;
  double? get percentage => change != null ? change! / previous! * 100 : null;
}

final class ExchangeRates {
  ExchangeRates({
    required List<RateQuote> quotes,
    required this.date,
    required this.fetchedAt,
    this.cached = false,
    this.notice,
  }) : quotes = List.unmodifiable(quotes);
  final List<RateQuote> quotes;
  final DateTime date;
  final DateTime fetchedAt;
  final bool cached;
  final String? notice;
  bool get isEmpty => quotes.every((quote) => quote.rate == null);
}
