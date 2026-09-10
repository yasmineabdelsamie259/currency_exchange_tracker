import 'package:currency_exchange_tracker/core/error/data_source_exception.dart';
import 'package:currency_exchange_tracker/core/networking/http_client.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/data/datasources/exchange_rates_local_data_source.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/data/datasources/exchange_rates_remote_data_source.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/data/repositories/exchange_rates_repository_impl.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/domain/entities/exchange_rates.dart';
import 'package:flutter_test/flutter_test.dart';

import '../datasources/data_sources_test.dart' show MemoryStore;

final class HistoryHttp implements HttpClient {
  final dates = <String>[];
  bool offline = false;
  String? failedDate;
  bool invalidCurrency = false;
  bool wrongDate = false;
  @override
  Future<Map<String, dynamic>> get(Uri uri) async {
    final date = uri.host.split('.').first;
    dates.add(date);
    if (offline || date == failedDate) {
      throw const DataSourceException(DataSourceFailure.network);
    }
    return {
      'date': wrongDate ? '2026-01-01' : date,
      'egp': {
        'usd': invalidCurrency ? 0 : 0.02,
        'eur': 0.025,
        'gbp': 0.014,
        'sar': 0.07,
        'jpy': 3,
      },
    };
  }
}

void main() {
  test('seven completed dates in order, shared across currencies, persistent offline fallback', () async {
    final http = HistoryHttp(), store = MemoryStore();
    ExchangeRatesRepositoryImpl make() => ExchangeRatesRepositoryImpl(
      ExchangeRatesRemoteDataSource(http),
      ExchangeRatesLocalDataSource(store),
      now: () => DateTime.utc(2026, 6, 1),
    );
    final repo = make();
    final usd = await repo.loadHistory(Currency.usd);
    expect(http.dates.toSet(), {
      '2026-05-25',
      '2026-05-26',
      '2026-05-27',
      '2026-05-28',
      '2026-05-29',
      '2026-05-30',
      '2026-05-31',
    });
    expect(usd.points.first.date, DateTime.utc(2026, 5, 25));
    expect(usd.points.last.date, DateTime.utc(2026, 5, 31));
    expect(usd.points.first.rate, 50);
    expect((await repo.loadHistory(Currency.eur)).points.first.rate, 40);
    expect(http.dates.length, 7);
    http.offline = true;
    final saved = await make().loadHistory(Currency.usd);
    expect(saved.cached, isTrue);
    expect(saved.points.length, 7);
    expect(saved.fetchedAt, DateTime.utc(2026, 6, 1));
  });
  test(
    'partial failure persists successes but never fabricates a missing point',
    () async {
      final http = HistoryHttp()..failedDate = '2026-05-27';
      final store = MemoryStore();
      final local = ExchangeRatesLocalDataSource(store);
      final repo = ExchangeRatesRepositoryImpl(
        ExchangeRatesRemoteDataSource(http),
        local,
        now: () => DateTime.utc(2026, 6, 1),
      );
      await expectLater(
        repo.loadHistory(Currency.usd),
        throwsA(isA<DataSourceException>()),
      );
      expect((await local.readHistory())!.length, 6);
      http.failedDate = null;
      expect(
        (await repo.loadHistory(Currency.usd, refresh: true)).points.length,
        7,
      );
    },
  );
  test(
    'invalid currency values and wrong dates cannot become chart points',
    () async {
      for (final wrongDate in [false, true]) {
        final http = HistoryHttp()
          ..invalidCurrency = !wrongDate
          ..wrongDate = wrongDate;
        final repo = ExchangeRatesRepositoryImpl(
          ExchangeRatesRemoteDataSource(http),
          ExchangeRatesLocalDataSource(MemoryStore()),
          now: () => DateTime.utc(2026, 6, 1),
        );
        await expectLater(
          repo.loadHistory(Currency.usd),
          throwsA(isA<DataSourceException>()),
        );
      }
    },
  );
}
