import 'package:flutter/material.dart';

import '../../../../../core/design_system/theme/exchange_colors.dart';
import '../../../../../core/design_system/widgets/app_shimmer.dart';

class CurrencySummaryShimmer extends StatelessWidget {
  const CurrencySummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) => AppShimmer(
    label: 'Loading current rate details',
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).exchangeColors.shimmerBase,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerBlock(width: 44, height: 44, radius: 14),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBlock(width: 128, height: 22),
                  SizedBox(height: 7),
                  ShimmerBlock(width: 80, height: 16),
                ],
              ),
            ],
          ),
          SizedBox(height: 26),
          ShimmerBlock(width: 196, height: 34),
          SizedBox(height: 10),
          ShimmerBlock(width: 130, height: 16),
          SizedBox(height: 18),
          ShimmerBlock(width: 156, height: 54, radius: 16),
          SizedBox(height: 28),
          ShimmerBlock(height: 1),
          SizedBox(height: 14),
          ShimmerBlock(width: 194, height: 16),
        ],
      ),
    ),
  );
}
