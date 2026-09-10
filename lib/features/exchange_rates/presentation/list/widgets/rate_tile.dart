import 'package:flutter/material.dart';

import '../../../../../core/design_system/theme/exchange_colors.dart';
import '../../../domain/entities/exchange_rates.dart';

class RateTile extends StatelessWidget {
  const RateTile({required this.quote, super.key});
  final RateQuote quote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.exchangeColors;
    final change = quote.change;
    final color = change == null || change == 0
        ? colors.unchanged
        : change < 0
        ? colors.strengthening
        : colors.weakening;
    final delta = change == null
        ? 'Change unavailable'
        : '${change < 0
                  ? '↓ −'
                  : change > 0
                  ? '↑ +'
                  : ''}${change.abs().toStringAsFixed(4)} '
              '(${change < 0
                  ? '−'
                  : change > 0
                  ? '+'
                  : ''}${quote.percentage!.abs().toStringAsFixed(2)}%)';
    final identity = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 46,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(quote.currency.symbol, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(quote.currency.code, style: theme.textTheme.titleMedium),
              Text(
                quote.currency.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
    final value = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          quote.rate == null
              ? 'Unavailable'
              : '${quote.rate!.toStringAsFixed(4)} EGP',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Semantics(
          label: change == null
              ? 'Daily change unavailable'
              : change < 0
              ? 'EGP strengthening'
              : change > 0
              ? 'EGP weakening'
              : 'Unchanged',
          child: Text(
            delta,
            style: theme.textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked =
              constraints.maxWidth < 330 ||
              MediaQuery.textScalerOf(context).scale(14) > 19;
          return stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [identity, const SizedBox(height: 10), value],
                )
              : Row(
                  children: [
                    Expanded(child: identity),
                    const SizedBox(width: 12),
                    value,
                  ],
                );
        },
      ),
    );
  }
}
