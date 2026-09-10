import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/data_source_exception.dart';
import '../../../domain/entities/exchange_rates.dart';
import '../../../domain/entities/currency_history.dart';
import '../../../domain/usecases/get_exchange_rates.dart';
import '../../../domain/usecases/get_currency_history.dart';

final class DetailSection<T> {
  const DetailSection({this.data, this.loading = false, this.error});
  final T? data;
  final bool loading;
  final String? error;
}

final class CurrencyDetailState {
  const CurrencyDetailState({
    this.summary = const DetailSection(),
    this.history = const DetailSection(),
  });
  final DetailSection<ExchangeRates> summary;
  final DetailSection<CurrencyHistory> history;
}

sealed class CurrencyDetailEvent {}

final class SummaryRequested extends CurrencyDetailEvent {}

final class HistoryRequested extends CurrencyDetailEvent {
  HistoryRequested({this.refresh = false});
  final bool refresh;
}

final class CurrencyDetailBloc
    extends Bloc<CurrencyDetailEvent, CurrencyDetailState> {
  CurrencyDetailBloc({
    required this.currency,
    required GetExchangeRates getRates,
    required GetCurrencyHistory getHistory,
    ExchangeRates? initial,
    Stream<bool> networkChanges = const Stream.empty(),
  }) : super(CurrencyDetailState(summary: DetailSection(data: initial))) {
    on<SummaryRequested>((event, emit) async {
      if (state.summary.loading) return;
      emit(
        CurrencyDetailState(
          summary: DetailSection(data: state.summary.data, loading: true),
          history: state.history,
        ),
      );
      try {
        final result = await getRates();
        emit(
          CurrencyDetailState(
            summary: DetailSection(data: result),
            history: state.history,
          ),
        );
      } catch (error) {
        emit(
          CurrencyDetailState(
            summary: DetailSection(
              data: state.summary.data,
              error: _message(error),
            ),
            history: state.history,
          ),
        );
      }
    });
    on<HistoryRequested>((event, emit) async {
      if (state.history.loading) return;
      emit(
        CurrencyDetailState(
          summary: state.summary,
          history: DetailSection(data: state.history.data, loading: true),
        ),
      );
      try {
        final result = await getHistory(currency, refresh: event.refresh);
        emit(
          CurrencyDetailState(
            summary: state.summary,
            history: DetailSection(data: result),
          ),
        );
      } catch (error) {
        emit(
          CurrencyDetailState(
            summary: state.summary,
            history: DetailSection(
              data: state.history.data,
              error: _message(error),
            ),
          ),
        );
      }
    });
    bool? previous;
    _subscription = networkChanges.listen((available) {
      if (available && previous == false && !isClosed) refresh();
      previous = available;
    }, onError: (Object error) {});
  }
  final Currency currency;
  late final StreamSubscription<bool> _subscription;
  void refresh() {
    add(SummaryRequested());
    add(HistoryRequested(refresh: true));
  }

  String _message(Object error) => error is DataSourceException
      ? error.message
      : 'Something went wrong. Please try again.';
  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
