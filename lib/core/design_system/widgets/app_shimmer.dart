import 'package:flutter/material.dart';

import '../theme/exchange_colors.dart';

class AppShimmer extends StatefulWidget {
  const AppShimmer({required this.child, this.label = 'Loading', super.key});

  final Widget child;
  final String label;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).exchangeColors;
    return Semantics(
      label: widget.label,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment(-3 + 6 * _controller.value, 0),
              end: Alignment(-1 + 6 * _controller.value, 0),
              colors: [
                colors.shimmerBase,
                colors.shimmerHighlight,
                colors.shimmerBase,
              ],
            ).createShader(bounds),
            child: child,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class ShimmerBlock extends StatelessWidget {
  const ShimmerBlock({
    required this.height,
    this.width = double.infinity,
    this.radius = 8,
    super.key,
  });

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Theme.of(context).exchangeColors.shimmerBase,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
