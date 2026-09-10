import 'dart:typed_data';

import 'package:dio/dio.dart';

final class StubAdapter implements HttpClientAdapter {
  StubAdapter(this.respond);
  final Future<ResponseBody> Function(RequestOptions) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => respond(options);

  @override
  void close({bool force = false}) {}
}
