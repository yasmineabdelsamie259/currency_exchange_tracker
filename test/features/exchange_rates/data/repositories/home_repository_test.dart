import 'package:poundwise/core/error/data_source_exception.dart';
import 'package:poundwise/core/networking/http_client.dart';
import 'package:poundwise/features/exchange_rates/data/datasources/exchange_rates_local_data_source.dart';
import 'package:poundwise/features/exchange_rates/data/datasources/exchange_rates_remote_data_source.dart';
import 'package:poundwise/features/exchange_rates/data/repositories/exchange_rates_repository_impl.dart';
import 'package:poundwise/features/exchange_rates/data/models/rate_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

import '../datasources/data_sources_test.dart' show MemoryStore;

final class FakeHttp implements HttpClient {
  bool offline = false;
  bool missingYesterday = false;
  final calls = <Uri>[];
  @override
  Future<Map<String, dynamic>> get(Uri uri) async {
    calls.add(uri);
    if (offline || (missingYesterday && !uri.host.startsWith('latest'))) {
      throw const DataSourceException(DataSourceFailure.network);
    }
    final latest = uri.host.startsWith('latest');
    return {
      'date': latest ? '2026-06-01' : '2026-05-31',
      'egp': {
        'usd': latest ? 0.02 : 0.025,
        'eur': 0.015,
        'gbp': 0.014,
        'sar': 0.07,
        'jpy': 3.0,
      },
    };
  }
}

void main() {
  test(
    'inverts rates, computes change, uses two requests and persists fallback',
    () async {
      final http = FakeHttp();
      final store = MemoryStore();
      ExchangeRatesRepositoryImpl create() => ExchangeRatesRepositoryImpl(
        ExchangeRatesRemoteDataSource(http),
        ExchangeRatesLocalDataSource(store),
        now: () => DateTime.utc(2026, 6, 1),
      );
      final result = await create().load();
      expect(http.calls.length, 2);
      expect(result.quotes.first.rate, 50);
      expect(result.quotes.first.change, 10);
      expect(result.quotes.first.percentage, 25);
      http.offline = true;
      final cached = await create().load();
      expect(cached.cached, isTrue);
      expect(cached.quotes.first.rate, 50);
      expect(cached.fetchedAt, DateTime.utc(2026, 6, 1));
    },
  );
  test('yesterday failure preserves latest and omits changes', () async {
    final http = FakeHttp()..missingYesterday = true;
    final repository = ExchangeRatesRepositoryImpl(
      ExchangeRatesRemoteDataSource(http),
      ExchangeRatesLocalDataSource(MemoryStore()),
      now: () => DateTime.utc(2026, 6, 1),
    );
    final result = await repository.load();
    expect(result.quotes.first.rate, 50);
    expect(result.quotes.first.change, isNull);
    expect(result.notice, contains('Yesterday'));
  });
  test('invalid rates are unavailable rather than infinite', () {
    final snapshot = RateSnapshot.parse({
      'date': '2026-06-01',
      'egp': {'usd': 0, 'eur': -1, 'gbp': 'bad', 'sar': double.nan, 'jpy': 3},
    });
    expect(snapshot.rates.length, 1);
  });
}
