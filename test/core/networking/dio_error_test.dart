import 'package:currency_exchange_tracker/core/error/data_source_exception.dart';
import 'package:currency_exchange_tracker/core/networking/dio_factory.dart';
import 'package:currency_exchange_tracker/core/networking/json_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/stub_adapter.dart';

void main() {
  final uri = Uri.https('example.com', '/rates');
  final categories = {
    DioExceptionType.connectionTimeout: DataSourceFailure.timeout,
    DioExceptionType.sendTimeout: DataSourceFailure.sendTimeout,
    DioExceptionType.receiveTimeout: DataSourceFailure.receiveTimeout,
    DioExceptionType.transformTimeout: DataSourceFailure.transformTimeout,
    DioExceptionType.connectionError: DataSourceFailure.network,
    DioExceptionType.badCertificate: DataSourceFailure.certificate,
    DioExceptionType.cancel: DataSourceFailure.cancelled,
    DioExceptionType.unknown: DataSourceFailure.unknown,
  };
  for (final entry in categories.entries) {
    test('client maps ${entry.key} to safe message', () async {
      final dio = createDio()
        ..httpClientAdapter = StubAdapter((options) async {
          throw DioException(
            requestOptions: options,
            type: entry.key,
            message: 'private server details',
          );
        });
      addTearDown(dio.close);
      await expectLater(
        JsonClient(dio).get(uri),
        throwsA(
          isA<DataSourceException>()
              .having((e) => e.kind, 'kind', entry.value)
              .having((e) => e.message, 'message', isNotEmpty)
              .having(
                (e) => e.message,
                'safe',
                isNot(contains('private server details')),
              ),
        ),
      );
    });
  }
  for (final entry in {
    400: DataSourceFailure.badRequest,
    401: DataSourceFailure.unauthorized,
    403: DataSourceFailure.forbidden,
    404: DataSourceFailure.notFound,
    408: DataSourceFailure.timeout,
    429: DataSourceFailure.rateLimited,
    500: DataSourceFailure.server,
    503: DataSourceFailure.server,
  }.entries) {
    test('HTTP ${entry.key} retains status and maps failure', () async {
      final dio = createDio()
        ..httpClientAdapter = StubAdapter(
          (_) async => ResponseBody.fromString('private', entry.key),
        );
      addTearDown(dio.close);
      await expectLater(
        JsonClient(dio).get(uri),
        throwsA(
          isA<DataSourceException>()
              .having((e) => e.kind, 'kind', entry.value)
              .having((e) => e.statusCode, 'status', entry.key),
        ),
      );
    });
  }
  for (final payload in ['', '{bad', 'null', '[]']) {
    test('rejects invalid object payload "$payload"', () async {
      final dio = createDio()
        ..httpClientAdapter = StubAdapter(
          (_) async => ResponseBody.fromString(payload, 200),
        );
      addTearDown(dio.close);
      await expectLater(
        JsonClient(dio).get(uri),
        throwsA(
          isA<DataSourceException>().having(
            (e) => e.kind,
            'kind',
            DataSourceFailure.invalidData,
          ),
        ),
      );
    });
  }
}
