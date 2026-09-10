import 'package:flutter/material.dart';

import '../../../../../core/design_system/theme/exchange_colors.dart';

class HistoryShimmer extends StatefulWidget {
  const HistoryShimmer({super.key});
  @override
  State<HistoryShimmer> createState() => _HistoryShimmerState();
}

class _HistoryShimmerState extends State<HistoryShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      controller.stop();
    } else {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).exchangeColors;
    return Semantics(
      label: 'Loading historical rates',
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment(-3 + 6 * controller.value, 0),
              end: Alignment(-1 + 6 * controller.value, 0),
              colors: [
                colors.shimmerBase,
                colors.shimmerHighlight,
                colors.shimmerBase,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
