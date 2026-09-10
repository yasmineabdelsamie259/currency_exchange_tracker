import 'package:flutter/material.dart';

import '../../../../../core/design_system/widgets/app_shimmer.dart';

class ExchangeRatesShimmer extends StatelessWidget {
  const ExchangeRatesShimmer({super.key});

  @override
  Widget build(BuildContext context) => AppShimmer(
    label: 'Loading exchange rates',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ShimmerBlock(height: 212, radius: 24),
        const SizedBox(height: 26),
        const Row(
          children: [
            ShimmerBlock(width: 156, height: 24),
            Spacer(),
            ShimmerBlock(width: 80, height: 16),
          ],
        ),
        const SizedBox(height: 10),
        const ShimmerBlock(width: 180, height: 16),
        const SizedBox(height: 12),
        for (var index = 0; index < 5; index++) ...[
          const _RateTileShimmer(),
          if (index < 4) const Divider(height: 1),
        ],
      ],
    ),
  );
}

class _RateTileShimmer extends StatelessWidget {
  const _RateTileShimmer();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 330;
        final identity = const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShimmerBlock(width: 46, height: 48, radius: 16),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBlock(width: 46, height: 18),
                SizedBox(height: 7),
                ShimmerBlock(width: 86, height: 14),
              ],
            ),
          ],
        );
        const value = Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ShimmerBlock(width: 104, height: 18),
            SizedBox(height: 7),
            ShimmerBlock(width: 92, height: 14),
          ],
        );
        return compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [identity, SizedBox(height: 12), value],
              )
            : Row(
                children: [
                  Expanded(child: identity),
                  SizedBox(width: 12),
                  value,
                ],
              );
      },
    ),
  );
}
