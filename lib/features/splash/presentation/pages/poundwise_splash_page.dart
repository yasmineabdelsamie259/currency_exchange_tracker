import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/design_system/app_assets.dart';
import '../../../../core/design_system/theme/exchange_colors.dart';

class PoundwiseSplashPage extends StatefulWidget {
  const PoundwiseSplashPage({
    required this.onFinished,
    this.duration = const Duration(milliseconds: 1200),
    super.key,
  });

  final Duration duration;
  final VoidCallback onFinished;

  @override
  State<PoundwiseSplashPage> createState() => _PoundwiseSplashPageState();
}

class _PoundwiseSplashPageState extends State<PoundwiseSplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, widget.onFinished);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).exchangeColors;
    return Scaffold(
      backgroundColor: colors.heroBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: CustomPaint(
              painter: _SplashRingsPainter(colors.heroDecoration),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final markSize = (constraints.maxWidth * .28).clamp(
                  96.0,
                  128.0,
                ).toDouble();
                return Column(
                  children: [
                    const Spacer(flex: 3),
                    Semantics(
                      label: 'poundwise',
                      image: true,
                      child: Container(
                        width: markSize,
                        height: markSize,
                        decoration: BoxDecoration(
                          color: colors.heroAccent,
                          borderRadius: BorderRadius.circular(markSize * .3),
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AppAssets.exchange,
                          width: markSize * .52,
                          height: markSize * .52,
                          colorFilter: ColorFilter.mode(
                            colors.onHeroAccent,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'poundwise',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: colors.onHero,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Exchange rates, made clear',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: colors.heroAccent),
                    ),
                    const Spacer(flex: 4),
                    Semantics(
                      label: 'Loading exchange rates',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          3,
                          (index) => Container(
                            width: 6,
                            height: 6,
                            margin: EdgeInsets.only(right: index == 2 ? 0 : 7),
                            decoration: BoxDecoration(
                              color: colors.heroAccent.withValues(
                                alpha: .5 + (index * .2),
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashRingsPainter extends CustomPainter {
  const _SplashRingsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: .35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final radius = size.width * .58;
    canvas.drawCircle(
      Offset(size.width * 1.04, -size.height * .06),
      radius,
      paint,
    );
    canvas.drawCircle(
      Offset(-size.width * .12, size.height * 1.12),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SplashRingsPainter oldDelegate) =>
      oldDelegate.color != color;
}
