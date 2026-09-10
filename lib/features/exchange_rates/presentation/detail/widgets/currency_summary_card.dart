import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/design_system/app_assets.dart';
import '../../../../../core/design_system/theme/exchange_colors.dart';
import '../../../../../core/utilities/calendar_date.dart';
import '../../../domain/entities/exchange_rates.dart';

class CurrencySummaryCard extends StatelessWidget {
  const CurrencySummaryCard({
    required this.currency,
    required this.summary,
    super.key,
  });
  final Currency currency;
  final ExchangeRates? summary;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.exchangeColors, scheme = theme.colorScheme;
    final matches = summary?.quotes.where((q) => q.currency == currency);
    final quote = matches == null || matches.isEmpty ? null : matches.first;
    final change = quote?.change;
    Widget icon(String path, Color color) => SvgPicture.asset(
      path,
      width: 20,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.heroBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.heroAccent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  currency.symbol,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colors.onHeroAccent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency.label,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colors.onHero,
                      ),
                    ),
                    Text(
                      '${currency.code} / EGP',
                      style: TextStyle(color: colors.onHero),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            quote?.rate == null
                ? 'Rate unavailable'
                : '${quote!.rate!.toStringAsFixed(4)} EGP',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: colors.onHero,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'for 1 ${currency.label}',
            style: TextStyle(color: colors.onHero),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              change == null
                  ? 'Daily change unavailable'
                  : '${change < 0
                        ? '↓ −'
                        : change > 0
                        ? '↑ +'
                        : ''}${change.abs().toStringAsFixed(4)} (${change < 0
                        ? '−'
                        : change > 0
                        ? '+'
                        : ''}${quote!.percentage!.abs().toStringAsFixed(2)}%)\n${change < 0
                        ? 'EGP stronger'
                        : change > 0
                        ? 'EGP weaker'
                        : 'Unchanged'}',
              style: TextStyle(
                color: change == null || change == 0
                    ? colors.unchanged
                    : change < 0
                    ? colors.strengthening
                    : colors.weakening,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: colors.heroDecoration),
          const SizedBox(height: 8),
          Row(
            children: [
              icon(AppAssets.calendar, colors.onHero),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  summary == null
                      ? 'Waiting for latest rates'
                      : 'Rates dated ${calendarDate(summary!.date)}',
                  style: TextStyle(color: colors.onHero),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
