import '../../../../core/utilities/calendar_date.dart';
import '../../domain/entities/currency_history.dart';
import '../../../../core/error/data_source_exception.dart';
import '../../domain/entities/exchange_rates.dart';
import '../../domain/repositories/exchange_rates_repository.dart';
import '../datasources/exchange_rates_local_data_source.dart';
import '../datasources/exchange_rates_remote_data_source.dart';
import '../models/rate_snapshot.dart';

final class ExchangeRatesRepositoryImpl implements ExchangeRatesRepository {
  ExchangeRatesRepositoryImpl(
    this.remote,
    this.local, {
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;
  final ExchangeRatesRemoteDataSource remote;
  final ExchangeRatesLocalDataSource local;
  final DateTime Function() now;
  Future<ExchangeRates>? _pending;
  Future<_HistoryBatch>? _historyPending;
  _HistoryBatch? _historyMemo;

  @override
  Future<CurrencyHistory> loadHistory(
    Currency currency, {
    bool refresh = false,
  }) async {
    final instant = now().toUtc();
    final today = DateTime.utc(instant.year, instant.month, instant.day);
    final memo = _historyMemo;
    final batch = !refresh && memo != null && memo.window == today
        ? memo
        : await (_historyPending ??= _fetchHistory(
            today,
            instant,
          ).whenComplete(() => _historyPending = null));
    final points = <HistoryPoint>[];
    for (var daysAgo = 7; daysAgo >= 1; daysAgo--) {
      final date = today.subtract(Duration(days: daysAgo));
      final record = batch.records[calendarDate(date)];
      if (record == null) {
        throw const DataSourceException(DataSourceFailure.notFound);
      }
      final snapshot = RateSnapshot.parse(record.payload);
      final rate = snapshot.rates[currency];
      if (rate == null) {
        throw const DataSourceException(DataSourceFailure.notFound);
      }
      points.add(HistoryPoint(date, rate));
    }
    return CurrencyHistory(
      points: points,
      fetchedAt: batch.records.values
          .map((record) => record.fetchedAt)
          .reduce((a, b) => a.isBefore(b) ? a : b),
      cached: batch.cached,
      notice: batch.notice,
    );
  }

  Future<_HistoryBatch> _fetchHistory(DateTime today, DateTime instant) async {
    Map<String, dynamic>? saved;
    try {
      saved = await local.readHistory();
    } on DataSourceException {
      saved = null;
    }
    final records = <String, _HistoryRecord>{};
    var cached = false;
    DataSourceException? missing;
    await Future.wait([
      for (var daysAgo = 7; daysAgo >= 1; daysAgo--)
        () async {
          final date = today.subtract(Duration(days: daysAgo));
          final key = calendarDate(date);
          try {
            final payload = await remote.fetchDate(date);
            if (RateSnapshot.parse(payload).date != date) {
              throw const DataSourceException(DataSourceFailure.invalidData);
            }
            records[key] = _HistoryRecord(payload, instant);
          } on DataSourceException catch (failure) {
            final entry = saved?[key];
            if (entry is Map<String, dynamic>) {
              final payload = entry['payload'];
              final time = entry['fetchedAt'];
              final stamp = time is String ? DateTime.tryParse(time) : null;
              if (payload is Map<String, dynamic> && stamp != null) {
                try {
                  if (RateSnapshot.parse(payload).date == date) {
                    records[key] = _HistoryRecord(payload, stamp);
                    cached = true;
                    return;
                  }
                } on DataSourceException {
                  /* Treat invalid records as cache misses. */
                }
              }
            }
            missing ??= failure;
          }
        }(),
    ]);
    String? notice = cached
        ? 'Some history is from saved data. Last fetched time is shown below.'
        : null;
    try {
      // Only retain this seven-date window, shared by every currency.
      await local.writeHistory({
        for (final entry in records.entries)
          entry.key: {
            'payload': entry.value.payload,
            'fetchedAt': entry.value.fetchedAt.toIso8601String(),
          },
      });
    } on DataSourceException {
      notice = 'History loaded, but could not be saved for offline use.';
    }
    if (missing != null) throw missing!;
    final batch = _HistoryBatch(today, records, cached, notice);
    // Failed/cached refreshes must remain retryable after connectivity returns.
    if (!cached) _historyMemo = batch;
    return batch;
  }

  @override
  Future<ExchangeRates> load() =>
      _pending ??= _load().whenComplete(() => _pending = null);

  Future<ExchangeRates> _load() async {
    final instant = now().toUtc();
    final today = DateTime.utc(instant.year, instant.month, instant.day);
    final yesterday = today.subtract(const Duration(days: 1));
    Map<String, dynamic> latest;
    Map<String, dynamic>? previous;
    try {
      latest = await remote.fetchLatest();
      RateSnapshot.parse(latest);
    } on DataSourceException catch (error) {
      return _cached(error);
    }
    String? notice;
    try {
      previous = await remote.fetchDate(yesterday);
      if (RateSnapshot.parse(previous).date != yesterday) {
        previous = null;
        notice = 'Yesterday’s rates are unavailable. Daily changes cannot be calculated.';
      }
    } on DataSourceException {
      previous = null;
      notice = 'Yesterday’s rates are unavailable. Daily changes cannot be calculated.';
    }
    final current = RateSnapshot.parse(latest);
    if (current.date != today) {
      previous = null;
      notice = 'The latest available rates are not dated today. Daily changes are unavailable.';
    }
    final result = _build(latest, previous, instant, notice: notice);
    if (!result.isEmpty) {
      try {
        await local.write({
          'latest': latest,
          'previous': previous,
          'fetchedAt': instant.toIso8601String(),
        });
      } on DataSourceException {
        return _build(
          latest,
          previous,
          instant,
          notice: 'Rates updated, but could not be saved for offline use.',
        );
      }
    }
    return result;
  }

  Future<ExchangeRates> _cached(DataSourceException failure) async {
    try {
      final cache = await local.read();
      if (cache == null) throw failure;
      final latest = cache['latest'];
      final previous = cache['previous'];
      final fetched = cache['fetchedAt'];
      final timestamp = fetched is String ? DateTime.tryParse(fetched) : null;
      if (latest is! Map<String, dynamic> ||
          timestamp == null ||
          (previous != null && previous is! Map<String, dynamic>)) {
        throw failure;
      }
      return _build(
        latest,
        previous as Map<String, dynamic>?,
        timestamp,
        cached: true,
        notice: '${failure.message} Showing saved rates.',
      );
    } on DataSourceException {
      throw failure;
    }
  }

  ExchangeRates _build(
    Map<String, dynamic> latest,
    Map<String, dynamic>? previous,
    DateTime fetched, {
    bool cached = false,
    String? notice,
  }) {
    final current = RateSnapshot.parse(latest);
    final old = previous == null ? null : RateSnapshot.parse(previous);
    final comparable =
        old?.date == current.date.subtract(const Duration(days: 1));
    return ExchangeRates(
      quotes: [
        for (final c in Currency.values)
          RateQuote(c, current.rates[c], comparable ? old?.rates[c] : null),
      ],
      date: current.date,
      fetchedAt: fetched,
      cached: cached,
      notice: notice,
    );
  }
}

final class _HistoryRecord {
  const _HistoryRecord(this.payload, this.fetchedAt);
  final Map<String, dynamic> payload;
  final DateTime fetchedAt;
}

final class _HistoryBatch {
  const _HistoryBatch(this.window, this.records, this.cached, this.notice);
  final DateTime window;
  final Map<String, _HistoryRecord> records;
  final bool cached;
  final String? notice;
}
