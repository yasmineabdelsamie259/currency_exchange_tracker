import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/data_source_exception.dart';

final class JsonClient {
  const JsonClient(this._client, {this.timeout = const Duration(seconds: 15)});

  final http.Client _client;
  final Duration timeout;

  Future<Map<String, dynamic>> get(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        throw DataSourceException(
          DataSourceFailure.server,
          statusCode: response.statusCode,
        );
      }
      final Object? decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      return decoded;
    } on TimeoutException {
      throw const DataSourceException(DataSourceFailure.timeout);
    } on http.ClientException {
      throw const DataSourceException(DataSourceFailure.network);
    } on FormatException {
      throw const DataSourceException(DataSourceFailure.invalidData);
    }
  }
}
