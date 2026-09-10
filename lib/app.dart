import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/design_system/theme/app_theme.dart';
import 'core/di/core_dependencies.dart';
import 'core/navigation/app_router.dart';
import 'features/exchange_rates/di/exchange_rates_dependencies.dart';

class CurrencyExchangeApp extends StatefulWidget {
  const CurrencyExchangeApp({super.key});

  @override
  State<CurrencyExchangeApp> createState() => _CurrencyExchangeAppState();
}

class _CurrencyExchangeAppState extends State<CurrencyExchangeApp> {
  final _router = AppRouter.create();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepositoryProvider<CoreDependencies>(
    create: (_) => CoreDependencies.production(),
    dispose: (core) => core.dispose(),
    child: RepositoryProvider<ExchangeRatesDependencies>(
      lazy: false,
      create: (context) =>
          ExchangeRatesDependencies(context.read<CoreDependencies>()),
      child: MaterialApp.router(
        title: 'Currency Exchange Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: _router,
      ),
    ),
  );
}
