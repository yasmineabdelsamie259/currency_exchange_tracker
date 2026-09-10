import 'package:flutter/material.dart';

import '../../features/exchange_rates/presentation/list/pages/exchange_rates_page.dart';

abstract final class AppRouter {
  static Route<void> onGenerateRoute(RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const ExchangeRatesPage(),
      );
}
