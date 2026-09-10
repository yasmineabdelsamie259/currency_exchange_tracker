import 'dart:convert';

import 'package:dio/dio.dart';

import '../error/data_source_exception.dart';
import 'dio_error_mapper.dart';

final class JsonClient {
  const JsonClient(this._client);

  final Dio _client;

  Future<Map<String, dynamic>> get(Uri uri, {CancelToken? cancelToken}) async {
    try {
      // Decode here so malformed payloads have a consistent failure category,
      // regardless of the server's Content-Type header.
      final response = await _client.getUri<String>(
        uri,
        cancelToken: cancelToken,
        options: Options(responseType: ResponseType.plain),
      );
      final Object? decoded = jsonDecode(response.data ?? '');
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      return decoded;
    } on DioException catch (error) {
      throw mapDioException(error);
    } on FormatException {
      throw const DataSourceException(DataSourceFailure.invalidData);
    }
  }
}
