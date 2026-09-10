enum DataSourceFailure { network, timeout, server, invalidData, storage }

final class DataSourceException implements Exception {
  const DataSourceException(this.kind, {this.statusCode});

  final DataSourceFailure kind;
  final int? statusCode;
}
