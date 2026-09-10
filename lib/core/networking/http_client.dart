abstract interface class HttpClient {
  Future<Map<String, dynamic>> get(Uri uri);
}
