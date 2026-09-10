import 'package:currency_exchange_tracker/core/error/data_source_exception.dart';
import 'package:currency_exchange_tracker/core/networking/json_client.dart';
import 'package:currency_exchange_tracker/core/storage/key_value_store.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/data/datasources/exchange_rates_local_data_source.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/data/datasources/exchange_rates_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import '../../../../helpers/stub_adapter.dart';

final class MemoryStore implements KeyValueStore {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }
}

void main() {
  test('latest and historical requests always use the EGP base', () async {
    final urls = <String>[];
    final client = Dio()
      ..httpClientAdapter = StubAdapter((request) async {
        urls.add(request.uri.toString());
        return ResponseBody.fromString(
          '{"date":"2026-06-01","egp":{"usd":0.019}}',
          200,
        );
      });
    addTearDown(client.close);
    final remote = ExchangeRatesRemoteDataSource(JsonClient(client));
    await remote.fetchLatest();
    await remote.fetchDate(DateTime.utc(2026, 6, 1));
    expect(urls, [
      'https://latest.currency-api.pages.dev/v1/currencies/egp.json',
      'https://2026-06-01.currency-api.pages.dev/v1/currencies/egp.json',
    ]);
  });

  test('cache survives data source recreation and clear is scoped', () async {
    final store = MemoryStore();
    await store.write('other-feature', 'keep');
    final first = ExchangeRatesLocalDataSource(store);
    expect(await first.read(), isNull);
    final document = <String, dynamic>{
      'date': '2026-06-01',
      'egp': {'usd': 0.019},
    };
    await first.write(document);
    final second = ExchangeRatesLocalDataSource(store);
    expect(await second.read(), document);
    await second.clear();
    expect(await second.read(), isNull);
    expect(await store.read('other-feature'), 'keep');
  });

  test(
    'corrupt cache is reported instead of returned as usable data',
    () async {
      final store = MemoryStore();
      await store.write(ExchangeRatesLocalDataSource.storageKey, '[broken');
      await expectLater(
        ExchangeRatesLocalDataSource(store).read(),
        throwsA(
          isA<DataSourceException>().having(
            (e) => e.kind,
            'kind',
            DataSourceFailure.invalidData,
          ),
        ),
      );
    },
  );

  for (final scenario in [
    (503, '{}', DataSourceFailure.server),
    (200, '[]', DataSourceFailure.invalidData),
  ]) {
    test('categorizes ${scenario.$3}', () async {
      final client = Dio()
        ..httpClientAdapter = StubAdapter(
          (_) async => ResponseBody.fromString(scenario.$2, scenario.$1),
        );
      addTearDown(client.close);
      await expectLater(
        JsonClient(client).get(Uri.https('example.com')),
        throwsA(
          isA<DataSourceException>().having((e) => e.kind, 'kind', scenario.$3),
        ),
      );
    });
  }
}
