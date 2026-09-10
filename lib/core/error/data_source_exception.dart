enum DataSourceFailure {
  network,
  timeout,
  sendTimeout,
  receiveTimeout,
  transformTimeout,
  server,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  rateLimited,
  certificate,
  cancelled,
  invalidData,
  storage,
  unknown,
}

final class DataSourceException implements Exception {
  const DataSourceException(this.kind, {this.statusCode});

  final DataSourceFailure kind;
  final int? statusCode;

  String get message => switch (kind) {
    DataSourceFailure.network =>
      'Could not connect. Check your internet connection and try again.',
    DataSourceFailure.timeout => 'Connecting took too long. Please try again.',
    DataSourceFailure.sendTimeout =>
      'The request could not be sent in time. Please try again.',
    DataSourceFailure.receiveTimeout =>
      'The service took too long to respond. Please try again.',
    DataSourceFailure.transformTimeout =>
      'Processing the response took too long. Please try again.',
    DataSourceFailure.server =>
      'The service is temporarily unavailable. Please try again later.',
    DataSourceFailure.badRequest =>
      'The service could not process this request. Please try again later.',
    DataSourceFailure.unauthorized =>
      'The service requires authorization. Please try again later.',
    DataSourceFailure.forbidden =>
      'Access to the service was denied. Please try again later.',
    DataSourceFailure.notFound =>
      'No data is available for the requested date or resource.',
    DataSourceFailure.rateLimited =>
      'Too many requests. Please wait a moment before trying again.',
    DataSourceFailure.certificate =>
      'A secure connection could not be verified. Please try again later.',
    DataSourceFailure.cancelled => 'The request was cancelled.',
    DataSourceFailure.invalidData =>
      'The data could not be read. Please refresh and try again.',
    DataSourceFailure.storage =>
      'Saved data could not be read or updated. Please try again.',
    DataSourceFailure.unknown => 'Something went wrong. Please try again.',
  };

  @override
  String toString() => message;
}
