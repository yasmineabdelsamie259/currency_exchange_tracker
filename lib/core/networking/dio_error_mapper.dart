import 'package:dio/dio.dart';

import '../error/data_source_exception.dart';

DataSourceException mapDioException(DioException error) {
  final status = error.response?.statusCode;
  final kind = switch (error.type) {
    DioExceptionType.connectionTimeout => DataSourceFailure.timeout,
    DioExceptionType.sendTimeout => DataSourceFailure.sendTimeout,
    DioExceptionType.receiveTimeout => DataSourceFailure.receiveTimeout,
    DioExceptionType.transformTimeout => DataSourceFailure.transformTimeout,
    DioExceptionType.connectionError => DataSourceFailure.network,
    DioExceptionType.badCertificate => DataSourceFailure.certificate,
    DioExceptionType.cancel => DataSourceFailure.cancelled,
    DioExceptionType.badResponse => switch (status) {
      null => DataSourceFailure.unknown,
      401 => DataSourceFailure.unauthorized,
      403 => DataSourceFailure.forbidden,
      404 => DataSourceFailure.notFound,
      408 => DataSourceFailure.timeout,
      429 => DataSourceFailure.rateLimited,
      >= 500 => DataSourceFailure.server,
      _ => DataSourceFailure.badRequest,
    },
    DioExceptionType.unknown =>
      error.error is FormatException
          ? DataSourceFailure.invalidData
          : DataSourceFailure.unknown,
  };
  return DataSourceException(kind, statusCode: status);
}
