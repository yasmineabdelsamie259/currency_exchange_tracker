final class HistoryPoint {
  const HistoryPoint(this.date, this.rate);
  final DateTime date;
  final double rate;
}

final class CurrencyHistory {
  CurrencyHistory({
    required List<HistoryPoint> points,
    required this.fetchedAt,
    this.cached = false,
    this.notice,
  }) : points = List.unmodifiable(points);
  final List<HistoryPoint> points;
  final DateTime fetchedAt;
  final bool cached;
  final String? notice;
}
