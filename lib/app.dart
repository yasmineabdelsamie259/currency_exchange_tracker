import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/design_system/theme/app_theme.dart';
import 'core/di/core_dependencies.dart';
import 'core/navigation/app_router.dart';
import 'features/exchange_rates/di/exchange_rates_dependencies.dart';

class CurrencyExchangeApp extends StatelessWidget {
  const CurrencyExchangeApp({super.key});

  @override
  Widget build(BuildContext context) => RepositoryProvider<CoreDependencies>(
    create: (_) => CoreDependencies.production(),
    dispose: (core) => core.dispose(),
    child: RepositoryProvider<ExchangeRatesDependencies>(
      lazy: false,
      create: (context) =>
          ExchangeRatesDependencies(context.read<CoreDependencies>()),
      child: MaterialApp(
        title: 'Currency Exchange Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    ),
  );
}
