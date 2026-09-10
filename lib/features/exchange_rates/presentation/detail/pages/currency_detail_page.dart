import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/design_system/app_assets.dart';
import '../widgets/currency_summary_card.dart';
import '../widgets/currency_summary_shimmer.dart';
import '../../../../../core/utilities/calendar_date.dart';
import '../../../domain/entities/exchange_rates.dart';
import '../bloc/currency_detail_bloc.dart';
import '../widgets/history_chart.dart';
import '../widgets/history_shimmer.dart';

class CurrencyDetailPage extends StatelessWidget {
  const CurrencyDetailPage({required this.currency, this.initial, super.key});
  final Currency currency;
  final ExchangeRates? initial;
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) {
      final bloc = serviceLocator<CurrencyDetailBloc>(
        param1: currency,
        param2: initial,
      );
      if (initial == null) bloc.add(SummaryRequested());
      bloc.add(HistoryRequested());
      return bloc;
    },
    child: CurrencyDetailView(currency: currency),
  );
}

class CurrencyDetailView extends StatefulWidget {
  const CurrencyDetailView({required this.currency, super.key});
  final Currency currency;
  @override
  State<CurrencyDetailView> createState() => _CurrencyDetailViewState();
}

class _CurrencyDetailViewState extends State<CurrencyDetailView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<CurrencyDetailBloc>().refresh();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<CurrencyDetailBloc, CurrencyDetailState>(
    builder: (context, state) {
      final theme = Theme.of(context), currency = widget.currency;
      final scheme = theme.colorScheme;
      final summary = state.summary.data;
      final history = state.history.data;
      Widget icon(String path, Color color) => SvgPicture.asset(
        path,
        width: 20,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
      Widget message(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text, style: TextStyle(color: scheme.onSurfaceVariant)),
      );
      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Back to rates',
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/');
                              }
                            },
                            icon: icon(AppAssets.back, scheme.onSurface),
                          ),
                          const Expanded(
                            child: Text(
                              'Currency details',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Refresh details',
                            onPressed:
                                state.summary.loading || state.history.loading
                                ? null
                                : context.read<CurrencyDetailBloc>().refresh,
                            icon: icon(AppAssets.refresh, scheme.onSurface),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (state.summary.loading && summary == null)
                        const CurrencySummaryShimmer()
                      else
                        CurrencySummaryCard(
                          currency: currency,
                          summary: summary,
                        ),
                      if (state.summary.error != null) ...[
                        message(state.summary.error!),
                        TextButton(
                          onPressed: () => context
                              .read<CurrencyDetailBloc>()
                              .add(SummaryRequested()),
                          child: const Text('Retry current rate'),
                        ),
                      ],
                      if (summary?.notice != null) message(summary!.notice!),
                      const SizedBox(height: 28),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rate history',
                            style: theme.textTheme.titleLarge,
                          ),
                          const Text('7 days'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'EGP per 1 ${currency.code} · Seven completed days',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLowest,
                          border: Border.all(color: scheme.outlineVariant),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            if (state.history.loading)
                              const HistoryShimmer()
                            else if (history != null)
                              HistoryChart(history: history)
                            else
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 36),
                                child: Text(
                                  'Historical rates are unavailable.',
                                ),
                              ),
                            if (state.history.error != null) ...[
                              message(state.history.error!),
                              TextButton(
                                onPressed: () => context
                                    .read<CurrencyDetailBloc>()
                                    .add(HistoryRequested(refresh: true)),
                                child: const Text('Retry chart'),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (history?.notice != null) message(history!.notice!),
                      if (history != null)
                        message(
                          '${history.cached ? 'Saved history' : 'History last fetched'} · ${calendarDate(history.fetchedAt.toLocal())} ${TimeOfDay.fromDateTime(history.fetchedAt.toLocal()).format(context)}',
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          icon(AppAssets.info, scheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Rates update daily',
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
