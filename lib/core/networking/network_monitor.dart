import 'package:connectivity_plus/connectivity_plus.dart';

final class NetworkMonitor {
  NetworkMonitor(this._connectivity);
  final Connectivity _connectivity;

  // An interface being available is only a retry hint, not proof of internet.
  Stream<bool> get changes => _connectivity.onConnectivityChanged
      .map(
        (results) => results.any((result) => result != ConnectivityResult.none),
      )
      .distinct();
}
