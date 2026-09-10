import 'dart:async';

import 'package:poundwise/core/design_system/theme/app_theme.dart';
import 'package:poundwise/core/error/data_source_exception.dart';
import 'package:poundwise/features/exchange_rates/domain/entities/exchange_rates.dart';
import 'package:poundwise/features/exchange_rates/domain/entities/currency_history.dart';
import 'package:poundwise/features/exchange_rates/domain/repositories/exchange_rates_repository.dart';
import 'package:poundwise/features/exchange_rates/domain/usecases/get_exchange_rates.dart';
import 'package:poundwise/features/exchange_rates/domain/usecases/get_currency_history.dart';
import 'package:poundwise/features/exchange_rates/presentation/detail/bloc/currency_detail_bloc.dart';
import 'package:poundwise/features/exchange_rates/presentation/detail/pages/currency_detail_page.dart';
import 'package:poundwise/features/exchange_rates/presentation/detail/widgets/history_chart.dart';
import 'package:poundwise/features/exchange_rates/presentation/detail/widgets/history_shimmer.dart';
import 'package:poundwise/features/exchange_rates/presentation/detail/widgets/currency_summary_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

final summary = ExchangeRates(
  quotes: [const RateQuote(Currency.usd, 52.3777, 52.5)],
  date: DateTime.utc(2026, 6, 1),
  fetchedAt: DateTime.utc(2026, 6, 1),
);
final history = CurrencyHistory(
  points: [
    for (var i = 0; i < 7; i++)
      HistoryPoint(DateTime.utc(2026, 5, 25 + i), 52.8 - i * 0.05),
  ],
  fetchedAt: DateTime.utc(2026, 6, 1),
);

class DetailRepository implements ExchangeRatesRepository {
  Completer<CurrencyHistory> pending = Completer();
  bool failSummary = false;
  @override
  Future<ExchangeRates> load() async {
    if (failSummary) throw const DataSourceException(DataSourceFailure.network);
    return summary;
  }

  @override
  Future<CurrencyHistory> loadHistory(
    Currency currency, {
    bool refresh = false,
  }) => pending.future;
}

final class PendingDetailRepository extends DetailRepository {
  final pendingSummary = Completer<ExchangeRates>();

  @override
  Future<ExchangeRates> load() => pendingSummary.future;
}

void main() {
  testWidgets(
    'initial detail summary uses shimmer instead of a linear loader',
    (tester) async {
      final repository = PendingDetailRepository();
      final bloc = CurrencyDetailBloc(
        currency: Currency.usd,
        getRates: GetExchangeRates(repository),
        getHistory: GetCurrencyHistory(repository),
      )..add(SummaryRequested());
      addTearDown(bloc.close);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: BlocProvider.value(
            value: bloc,
            child: const CurrencyDetailView(currency: Currency.usd),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CurrencySummaryShimmer), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);

      repository.pendingSummary.complete(summary);
      await tester.pumpAndSettle();
      expect(find.text('52.3777 EGP'), findsOneWidget);
    },
  );

  testWidgets('large text and reduced motion keep detail readable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = DetailRepository();
    final bloc = CurrencyDetailBloc(
      currency: Currency.usd,
      getRates: GetExchangeRates(repository),
      getHistory: GetCurrencyHistory(repository),
      initial: summary,
    )..add(HistoryRequested());
    addTearDown(bloc.close);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 1100),
            textScaler: TextScaler.linear(2),
            disableAnimations: true,
          ),
          child: BlocProvider.value(
            value: bloc,
            child: const CurrencyDetailView(currency: Currency.usd),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HistoryShimmer), findsOneWidget);
    repository.pending.complete(history);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(HistoryChart));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  test('summary failure does not discard successful history', () async {
    final repository = DetailRepository()..failSummary = true;
    final bloc = CurrencyDetailBloc(
      currency: Currency.usd,
      getRates: GetExchangeRates(repository),
      getHistory: GetCurrencyHistory(repository),
    );
    final summaryDone = bloc.stream.firstWhere((s) => s.summary.error != null);
    final historyDone = bloc.stream.firstWhere((s) => s.history.data != null);
    bloc.add(SummaryRequested());
    bloc.add(HistoryRequested());
    repository.pending.complete(history);
    await Future.wait([summaryDone, historyDone]);
    expect(bloc.state.summary.error, contains('internet'));
    expect(bloc.state.history.data, history);
    await bloc.close();
  });
  for (final dark in [false, true]) {
    for (final width in [320.0, 390.0]) {
      testWidgets(
        'detail shimmer, selection and retry dark=$dark width=$width',
        (tester) async {
          tester.view.physicalSize = Size(width, 1100);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final repository = DetailRepository();
          final bloc = CurrencyDetailBloc(
            currency: Currency.usd,
            getRates: GetExchangeRates(repository),
            getHistory: GetCurrencyHistory(repository),
            initial: summary,
          )..add(HistoryRequested());
          addTearDown(bloc.close);
          await tester.pumpWidget(
            MaterialApp(
              theme: dark ? AppTheme.dark : AppTheme.light,
              home: BlocProvider.value(
                value: bloc,
                child: const CurrencyDetailView(currency: Currency.usd),
              ),
            ),
          );
          await tester.pump();
          expect(find.byType(HistoryShimmer), findsOneWidget);
          expect(find.text('52.3777 EGP'), findsOneWidget);
          repository.pending.complete(history);
          await tester.pumpAndSettle();
          expect(find.byType(HistoryChart), findsOneWidget);
          await tester.ensureVisible(find.widgetWithText(ChoiceChip, '25/5'));
          await tester.tap(find.widgetWithText(ChoiceChip, '25/5'));
          await tester.pumpAndSettle();
          expect(find.text('2026-05-25 · 52.8000 EGP'), findsOneWidget);
          expect(tester.takeException(), isNull);
          repository.pending = Completer();
          bloc.add(HistoryRequested(refresh: true));
          await tester.pump();
          repository.pending.completeError(
            const DataSourceException(DataSourceFailure.network),
          );
          await tester.pumpAndSettle();
          expect(find.text('Retry chart'), findsOneWidget);
          expect(find.byType(HistoryChart), findsOneWidget);
          expect(find.text('52.3777 EGP'), findsOneWidget);
        },
      );
    }
  }
}
