import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/design_system/theme/app_theme.dart';
import 'core/di/service_locator.dart';
import 'core/navigation/app_router.dart';
import 'features/settings/domain/entities/app_theme_preference.dart';
import 'features/settings/presentation/bloc/theme_cubit.dart';

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
  Widget build(BuildContext context) =>
      BlocBuilder<ThemeCubit, AppThemePreference>(
        bloc: serviceLocator<ThemeCubit>(),
        builder: (context, state) => MaterialApp.router(
          title: 'poundwise',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: serviceLocator<ThemeCubit>().themeMode,
          routerConfig: _router,
        ),
      );
}
