import 'dart:convert';

import 'package:poundwise/core/design_system/theme/app_theme.dart';
import 'package:poundwise/core/di/core_dependencies.dart';
import 'package:poundwise/core/di/service_locator.dart';
import 'package:poundwise/core/navigation/app_router.dart';
import 'package:poundwise/core/utilities/calendar_date.dart';
import 'package:poundwise/features/exchange_rates/presentation/detail/pages/currency_detail_page.dart';
import 'package:poundwise/features/settings/presentation/bloc/theme_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/stub_adapter.dart';
import '../../features/exchange_rates/data/datasources/data_sources_test.dart'
    show MemoryStore;

void main() {
  testWidgets('home to detail, back, direct currency link, invalid code', (
    tester,
  ) async {
    final dio = Dio()
      ..httpClientAdapter = StubAdapter((request) async {
        final date = request.uri.host.startsWith('latest')
            ? calendarDate(DateTime.now().toUtc())
            : request.uri.host.split('.').first;
        return ResponseBody.fromString(
          jsonEncode({
            'date': date,
            'egp': {
              'usd': 0.02,
              'eur': 0.015,
              'gbp': 0.014,
              'sar': 0.07,
              'jpy': 3,
            },
          }),
          200,
        );
      });
    final core = CoreDependencies(client: dio, storage: MemoryStore());
    await serviceLocator.reset();
    configureServiceLocator(core: core);
    serviceLocator<ThemeCubit>().load();
    final router = AppRouter.create(initialLocation: AppRouter.home);
    addTearDown(serviceLocator.reset);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('USD'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('USD'));
    await tester.pumpAndSettle();
    expect(find.byType(CurrencyDetailView), findsOneWidget);
    expect(find.text('USD / EGP'), findsOneWidget);
    await tester.tap(find.byTooltip('Back to rates'));
    await tester.pumpAndSettle();
    expect(find.text('poundwise'), findsOneWidget);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    router.go('/currency/eur');
    await tester.pumpAndSettle();
    expect(find.text('EUR / EGP'), findsOneWidget);
    router.go('/currency/invalid');
    await tester.pumpAndSettle();
    expect(find.text('Currency unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
