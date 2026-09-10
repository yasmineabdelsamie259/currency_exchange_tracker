import 'package:dio/dio.dart';

import '../networking/dio_factory.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../networking/json_client.dart';
import '../storage/key_value_store.dart';
import '../storage/preferences_store.dart';

final class CoreDependencies {
  CoreDependencies({required Dio client, required this.storage})
    : _client = client,
      network = JsonClient(client);

  factory CoreDependencies.production() => CoreDependencies(
    client: createDio(),
    storage: PreferencesStore(SharedPreferencesAsync()),
  );

  final Dio _client;
  final JsonClient network;
  final KeyValueStore storage;

  void dispose() => _client.close(force: true);
}
