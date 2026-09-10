import 'dart:convert';

import '../../../../core/error/data_source_exception.dart';
import '../../../../core/storage/key_value_store.dart';

// One versioned document allows the repository to save snapshots and metadata
// together. Date indexing, retention, and fallback policy belong to the repository.
final class ExchangeRatesLocalDataSource {
  const ExchangeRatesLocalDataSource(this._store);

  static const storageKey = 'exchange_rates.cache.v1';
  static const historyKey = 'exchange_rates.history.v1';
  final KeyValueStore _store;

  Future<Map<String, dynamic>?> read() => _read(storageKey);

  Future<Map<String, dynamic>?> readHistory() => _read(historyKey);

  Future<void> writeHistory(Map<String, dynamic> document) =>
      _store.write(historyKey, jsonEncode(document));

  Future<Map<String, dynamic>?> _read(String key) async {
    final value = await _store.read(key);
    if (value == null) return null;
    try {
      final Object? decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected cache object');
      }
      return decoded;
    } on FormatException {
      throw const DataSourceException(DataSourceFailure.invalidData);
    }
  }

  Future<void> write(Map<String, dynamic> document) =>
      _store.write(storageKey, jsonEncode(document));

  Future<void> clear() => _store.remove(storageKey);
}
