import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/data_source_exception.dart';
import '../../../domain/entities/exchange_rates.dart';
import '../../../domain/usecases/get_exchange_rates.dart';

sealed class ExchangeRatesEvent {}

final class RatesRequested extends ExchangeRatesEvent {}

final class ExchangeRatesState {
  const ExchangeRatesState({this.data, this.loading = false, this.error});
  final ExchangeRates? data;
  final bool loading;
  final String? error;
}

final class ExchangeRatesBloc
    extends Bloc<ExchangeRatesEvent, ExchangeRatesState> {
  ExchangeRatesBloc(
    this.getRates, {
    Stream<bool> networkChanges = const Stream.empty(),
  }) : super(const ExchangeRatesState()) {
    bool? previous;
    _networkSubscription = networkChanges.listen(
      (available) {
        if (available && previous == false && !isClosed) add(RatesRequested());
        previous = available;
      },
      onError: (Object error) {
        /* Requests remain the source of truth. */
      },
    );
    on<RatesRequested>((event, emit) async {
      if (state.loading) return;
      emit(ExchangeRatesState(data: state.data, loading: true));
      try {
        final data = await getRates();
        emit(ExchangeRatesState(data: data));
      } on DataSourceException catch (error) {
        emit(ExchangeRatesState(data: state.data, error: error.message));
      } catch (_) {
        emit(
          ExchangeRatesState(
            data: state.data,
            error: 'Something went wrong. Please try again.',
          ),
        );
      }
    });
  }
  final GetExchangeRates getRates;
  late final StreamSubscription<bool> _networkSubscription;

  @override
  Future<void> close() async {
    await _networkSubscription.cancel();
    return super.close();
  }

  Future<void> refresh() {
    final done = stream.firstWhere((state) => !state.loading);
    add(RatesRequested());
    return done.then((_) {});
  }
}
