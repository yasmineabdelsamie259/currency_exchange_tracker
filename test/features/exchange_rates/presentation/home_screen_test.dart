import 'dart:async';

import 'package:currency_exchange_tracker/features/exchange_rates/domain/entities/currency_history.dart';
import 'package:currency_exchange_tracker/core/design_system/theme/app_theme.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/domain/entities/exchange_rates.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/domain/repositories/exchange_rates_repository.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/domain/usecases/get_exchange_rates.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/presentation/list/bloc/exchange_rates_bloc.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/presentation/list/pages/exchange_rates_page.dart';
import 'package:currency_exchange_tracker/features/exchange_rates/presentation/list/widgets/exchange_rates_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRepository implements ExchangeRatesRepository {
  int calls = 0;
  @override
  Future<CurrencyHistory> loadHistory(
    Currency currency, {
    bool refresh = false,
  }) => throw UnimplementedError('Not used by home tests');

  @override
  Future<ExchangeRates> load() async {
    calls++;
    return ExchangeRates(
      quotes: [
        for (final c in Currency.values)
          RateQuote(c, c == Currency.jpy ? 0.3284 : 52.3777, 52.5),
      ],
      date: DateTime.utc(2026, 6, 1),
      fetchedAt: DateTime.utc(2026, 6, 1, 12),
    );
  }
}

final class PendingRepository extends FakeRepository {
  final pending = Completer<ExchangeRates>();

  @override
  Future<ExchangeRates> load() => pending.future;
}

void main() {
  testWidgets('initial home load shows content-shaped shimmer', (tester) async {
    final repository = PendingRepository();
    final bloc = ExchangeRatesBloc(GetExchangeRates(repository))
      ..add(RatesRequested());
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider.value(value: bloc, child: const ExchangeRatesView()),
      ),
    );
    await tester.pump();

    expect(find.byType(ExchangeRatesShimmer), findsOneWidget);
    expect(find.text('USD'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);

    repository.pending.complete(await FakeRepository().load());
    await tester.pumpAndSettle();
    expect(find.text('USD'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('home renders and refreshes: dark=$dark scale=$scale', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repository = FakeRepository();
        final bloc = ExchangeRatesBloc(GetExchangeRates(repository))
          ..add(RatesRequested());
        addTearDown(bloc.close);
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark : AppTheme.light,
            home: MediaQuery(
              data: MediaQueryData(
                size: const Size(390, 844),
                textScaler: TextScaler.linear(scale),
              ),
              child: BlocProvider.value(
                value: bloc,
                child: const ExchangeRatesView(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('poundwise'), findsOneWidget);
        expect(find.text('USD'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byTooltip('Refresh rates'));
        await tester.pumpAndSettle();
        expect(repository.calls, 2);
        await tester.drag(find.byType(ListView), const Offset(0, -1500));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
