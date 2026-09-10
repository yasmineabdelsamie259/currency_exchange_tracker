import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../networking/json_client.dart';
import '../storage/key_value_store.dart';
import '../storage/preferences_store.dart';

final class CoreDependencies {
  CoreDependencies({required http.Client client, required this.storage})
    : _client = client,
      network = JsonClient(client);

  factory CoreDependencies.production() => CoreDependencies(
    client: http.Client(),
    storage: PreferencesStore(SharedPreferencesAsync()),
  );

  final http.Client _client;
  final JsonClient network;
  final KeyValueStore storage;

  void dispose() => _client.close();
}
