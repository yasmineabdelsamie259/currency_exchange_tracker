import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../networking/network_monitor.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../networking/dio_factory.dart';
import '../networking/http_client.dart';
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

  final NetworkMonitor networkMonitor = NetworkMonitor(Connectivity());
  final Dio _client;
  final HttpClient network;
  final KeyValueStore storage;

  void dispose() => _client.close(force: true);
}
