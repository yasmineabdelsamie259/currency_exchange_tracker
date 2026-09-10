import 'package:poundwise/features/exchange_rates/domain/entities/currency_history.dart';

import 'dart:async';

import 'package:poundwise/core/error/data_source_exception.dart';
import 'package:poundwise/features/exchange_rates/domain/entities/exchange_rates.dart';
import 'package:poundwise/features/exchange_rates/domain/repositories/exchange_rates_repository.dart';
import 'package:poundwise/features/exchange_rates/domain/usecases/get_exchange_rates.dart';
import 'package:poundwise/features/exchange_rates/presentation/list/bloc/exchange_rates_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

final class ControlledRepository implements ExchangeRatesRepository {
  final requests = <Completer<ExchangeRates>>[];
  @override
  Future<CurrencyHistory> loadHistory(
    Currency currency, {
    bool refresh = false,
  }) => throw UnimplementedError('Not used by home tests');

  @override
  Future<ExchangeRates> load() {
    final pending = Completer<ExchangeRates>();
    requests.add(pending);
    return pending.future;
  }
}

void main() {
  test(
    'loading, success, failed refresh retains content, reconnect refresh',
    () async {
      final repository = ControlledRepository();
      final network = StreamController<bool>();
      final bloc = ExchangeRatesBloc(
        GetExchangeRates(repository),
        networkChanges: network.stream,
      );
      final sample = ExchangeRates(
        quotes: [const RateQuote(Currency.usd, 50, 51)],
        date: DateTime.utc(2026, 6, 1),
        fetchedAt: DateTime.utc(2026, 6, 1),
      );
      var loading = bloc.stream.firstWhere((s) => s.loading);
      bloc.add(RatesRequested());
      await loading;
      expect(bloc.state.data, isNull);
      var done = bloc.stream.firstWhere((s) => !s.loading);
      repository.requests.last.complete(sample);
      await done;
      expect(bloc.state.data, sample);
      loading = bloc.stream.firstWhere((s) => s.loading);
      final refresh = bloc.refresh();
      await loading;
      repository.requests.last.completeError(
        const DataSourceException(DataSourceFailure.network),
      );
      await refresh;
      expect(bloc.state.data, sample);
      expect(bloc.state.error, contains('internet'));
      loading = bloc.stream.firstWhere((s) => s.loading);
      network.add(false);
      network.add(true);
      await loading;
      expect(repository.requests.length, 3);
      done = bloc.stream.firstWhere((s) => !s.loading);
      repository.requests.last.complete(sample);
      await done;
      expect(bloc.state.error, isNull);
      await bloc.close();
      expect(network.hasListener, isFalse);
      await network.close();
    },
  );
}
