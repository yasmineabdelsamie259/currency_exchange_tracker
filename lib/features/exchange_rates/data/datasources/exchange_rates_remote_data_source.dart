import '../../../../core/networking/json_client.dart';
import '../../../../core/utilities/calendar_date.dart';

final class ExchangeRatesRemoteDataSource {
  const ExchangeRatesRemoteDataSource(this._client);

  final JsonClient _client;

  Future<Map<String, dynamic>> fetchLatest() => _fetch('latest');

  Future<Map<String, dynamic>> fetchDate(DateTime date) =>
      _fetch(calendarDate(date));

  Future<Map<String, dynamic>> _fetch(String date) => _client.get(
    Uri.https('$date.currency-api.pages.dev', '/v1/currencies/egp.json'),
  );
}
