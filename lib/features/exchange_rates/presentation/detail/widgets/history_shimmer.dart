import 'package:flutter/material.dart';

import '../../../../../core/design_system/theme/exchange_colors.dart';
import '../../../../../core/design_system/widgets/app_shimmer.dart';

class HistoryShimmer extends StatefulWidget {
  const HistoryShimmer({super.key});
  @override
  State<HistoryShimmer> createState() => _HistoryShimmerState();
}

class _HistoryShimmerState extends State<HistoryShimmer> {
  @override
  Widget build(BuildContext context) => AppShimmer(
    label: 'Loading historical rates',
    child: const SizedBox(
      height: 220,
      child: Stack(
        children: [
          Positioned(
            left: 58,
            right: 0,
            top: 28,
            child: ShimmerBlock(height: 1),
          ),
          Positioned(
            left: 58,
            right: 0,
            top: 100,
            child: ShimmerBlock(height: 1),
          ),
          Positioned(
            left: 58,
            right: 0,
            top: 172,
            child: ShimmerBlock(height: 1),
          ),
          Positioned(left: 64, right: 14, top: 48, child: _ChartLine()),
          Positioned(
            left: 64,
            bottom: 0,
            child: ShimmerBlock(width: 34, height: 14),
          ),
          Positioned(
            right: 14,
            bottom: 0,
            child: ShimmerBlock(width: 34, height: 14),
          ),
        ],
      ),
    ),
  );
}

class _ChartLine extends StatelessWidget {
  const _ChartLine();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => CustomPaint(
      size: Size(constraints.maxWidth, 120),
      painter: _ChartLinePainter(Theme.of(context).exchangeColors.shimmerBase),
    ),
  );
}

class _ChartLinePainter extends CustomPainter {
  const _ChartLinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 10)
      ..lineTo(size.width * .16, 32)
      ..lineTo(size.width * .32, 48)
      ..lineTo(size.width * .5, 64)
      ..lineTo(size.width * .68, 82)
      ..lineTo(size.width * .84, 98)
      ..lineTo(size.width, 110);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_ChartLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
