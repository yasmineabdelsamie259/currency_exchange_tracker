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
