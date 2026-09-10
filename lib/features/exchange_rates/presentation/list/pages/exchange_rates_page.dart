import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/design_system/app_assets.dart';
import '../../../../../core/design_system/theme/exchange_colors.dart';
import '../../../../../core/utilities/calendar_date.dart';
import '../../../di/exchange_rates_dependencies.dart';
import '../bloc/exchange_rates_bloc.dart';
import '../widgets/base_currency_card.dart';
import '../widgets/rate_tile.dart';

class ExchangeRatesPage extends StatelessWidget {
  const ExchangeRatesPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) =>
        context.read<ExchangeRatesDependencies>().createBloc()
          ..add(RatesRequested()),
    child: const ExchangeRatesView(),
  );
}

class ExchangeRatesView extends StatefulWidget {
  const ExchangeRatesView({super.key});
  @override
  State<ExchangeRatesView> createState() => _ExchangeRatesViewState();
}

class _ExchangeRatesViewState extends State<ExchangeRatesView>
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
      context.read<ExchangeRatesBloc>().add(RatesRequested());
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<ExchangeRatesBloc, ExchangeRatesState>(
    builder: (context, state) {
      final theme = Theme.of(context);
      final scheme = theme.colorScheme;
      final colors = theme.exchangeColors;
      final data = state.data;
      return Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: context.read<ExchangeRatesBloc>().refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colors.heroBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: SvgPicture.asset(
                                AppAssets.exchange,
                                width: 22,
                                colorFilter: ColorFilter.mode(
                                  colors.heroAccent,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'poundwise',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            IconButton.filledTonal(
                              tooltip: 'Refresh rates',
                              onPressed: state.loading
                                  ? null
                                  : () => context.read<ExchangeRatesBloc>().add(
                                      RatesRequested(),
                                    ),
                              icon: SvgPicture.asset(
                                AppAssets.refresh,
                                width: 22,
                                colorFilter: ColorFilter.mode(
                                  scheme.onSurface,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Your pound.\nA world of currencies.',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A little clarity for your everyday exchange.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        BaseCurrencyCard(
                          dateLabel: data == null
                              ? 'Daily exchange rates'
                              : 'Rates dated ${calendarDate(data.date)}',
                        ),
                        const SizedBox(height: 26),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Exchange rates',
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              '5 currencies',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'EGP per 1 foreign unit',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        if (state.loading) ...[
                          const SizedBox(height: 18),
                          const LinearProgressIndicator(
                            semanticsLabel: 'Loading exchange rates',
                          ),
                        ],
                        if (state.error != null || data?.notice != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colors.offlineBackground,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              state.error ?? data!.notice!,
                              style: TextStyle(color: colors.onOffline),
                            ),
                          ),
                        ],
                        if (data != null && !data.isEmpty) ...[
                          for (var i = 0; i < data.quotes.length; i++) ...[
                            RateTile(quote: data.quotes[i]),
                            if (i < data.quotes.length - 1)
                              const Divider(height: 1),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            '${data.cached ? 'Saved data' : 'Last fetched'} · ${calendarDate(data.fetchedAt.toLocal())} ${TimeOfDay.fromDateTime(data.fetchedAt.toLocal()).format(context)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (data?.isEmpty == true)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'No exchange rates are available. Please try again later.',
                            ),
                          ),
                        if (!state.loading &&
                            (state.error != null || data?.isEmpty == true))
                          TextButton(
                            onPressed: () => context
                                .read<ExchangeRatesBloc>()
                                .add(RatesRequested()),
                            child: const Text('Try again'),
                          ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.arrowDown,
                              width: 16,
                              colorFilter: ColorFilter.mode(
                                scheme.onSurfaceVariant,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Pull down to refresh',
                                style: TextStyle(
                                  color: scheme.onSurfaceVariant,
                                ),
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
        ),
      );
    },
  );
}
