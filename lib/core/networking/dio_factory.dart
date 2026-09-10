import 'package:dio/dio.dart';

Dio createDio() => Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
    validateStatus: (status) => status != null && status >= 200 && status < 300,
  ),
);
