import 'package:go_router/go_router.dart';

import '../../features/exchange_rates/presentation/list/pages/exchange_rates_page.dart';

abstract final class AppRouter {
  static const home = '/';

  static GoRouter create() => GoRouter(
    routes: [
      GoRoute(
        path: home,
        name: 'exchangeRates',
        builder: (context, state) => const ExchangeRatesPage(),
      ),
    ],
  );
}
