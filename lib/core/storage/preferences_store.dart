import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error/data_source_exception.dart';
import 'key_value_store.dart';

final class PreferencesStore implements KeyValueStore {
  PreferencesStore(this._preferences);

  final SharedPreferencesAsync _preferences;

  Future<T> _guard<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on PlatformException {
      throw const DataSourceException(DataSourceFailure.storage);
    }
  }

  @override
  Future<String?> read(String key) => _guard(() => _preferences.getString(key));

  @override
  Future<void> write(String key, String value) =>
      _guard(() => _preferences.setString(key, value));

  @override
  Future<void> remove(String key) => _guard(() => _preferences.remove(key));
}
