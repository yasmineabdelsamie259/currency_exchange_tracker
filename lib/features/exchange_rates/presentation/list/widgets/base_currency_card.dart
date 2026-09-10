import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/design_system/app_assets.dart';
import '../../../../../core/design_system/theme/exchange_colors.dart';

class BaseCurrencyCard extends StatelessWidget {
  const BaseCurrencyCard({required this.dateLabel, super.key});
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.exchangeColors;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.heroBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          for (final offset in [-36.0, -15.0])
            Positioned(
              right: offset,
              top: offset + 25,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.heroDecoration),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: DefaultTextStyle(
              style: theme.textTheme.bodyMedium!.copyWith(color: colors.onHero),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('BASE CURRENCY')),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.heroAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'EGP',
                          style: TextStyle(color: colors.onHeroAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.egyptFlag,
                        width: 32,
                        semanticsLabel: 'Egypt',
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Egyptian Pound',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colors.onHero,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text('Foreign currencies, priced in EGP'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: colors.heroDecoration),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.calendar,
                        width: 18,
                        colorFilter: ColorFilter.mode(
                          colors.onHero,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(dateLabel)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
