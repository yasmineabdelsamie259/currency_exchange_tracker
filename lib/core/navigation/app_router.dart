import 'package:flutter/material.dart';

import '../../features/exchange_rates/domain/entities/exchange_rates.dart';
import '../../features/exchange_rates/presentation/detail/pages/currency_detail_page.dart';
import '../../features/splash/presentation/pages/poundwise_splash_page.dart';
import 'main_tabs_page.dart';

import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static const home = '/';
  static const splash = '/splash';

  static GoRouter create({String initialLocation = splash}) => GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) =>
            PoundwiseSplashPage(onFinished: () => context.go(home)),
      ),
      GoRoute(
        path: home,
        name: 'exchangeRates',
        builder: (context, state) => const MainTabsPage(),
        routes: [
          GoRoute(
            path: 'currency/:code',
            name: 'currencyDetail',
            builder: (context, state) {
              final matches = Currency.values.where(
                (c) => c.code == state.pathParameters['code']?.toUpperCase(),
              );
              if (matches.isEmpty) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Currency unavailable')),
                  body: Center(
                    child: TextButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Back to rates'),
                    ),
                  ),
                );
              }
              return CurrencyDetailPage(
                currency: matches.first,
                initial: state.extra is ExchangeRates
                    ? state.extra as ExchangeRates
                    : null,
              );
            },
          ),
        ],
      ),
    ],
  );
}
