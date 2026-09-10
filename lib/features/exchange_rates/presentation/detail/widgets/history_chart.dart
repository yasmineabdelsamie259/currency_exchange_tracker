import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/utilities/calendar_date.dart';
import '../../../domain/entities/currency_history.dart';

class HistoryChart extends StatefulWidget {
  const HistoryChart({required this.history, super.key});
  final CurrencyHistory history;
  @override
  State<HistoryChart> createState() => _HistoryChartState();
}

class _HistoryChartState extends State<HistoryChart> {
  int selected = 6;
  @override
  Widget build(BuildContext context) {
    final points = widget.history.points;
    if (points.isEmpty) return const Text('No historical rates available.');
    final index = math.min(selected, points.length - 1);
    final point = points[index];
    final theme = Theme.of(context);
    return Column(
      children: [
        Semantics(
          label:
              'Exchange rate history in EGP. ${points.map((p) => '${calendarDate(p.date)}: ${p.rate.toStringAsFixed(4)}').join(', ')}',
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: CustomPaint(
              painter: HistoryPainter(
                points,
                index,
                theme.colorScheme.primary,
                theme.colorScheme.outlineVariant,
                theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Semantics(
          liveRegion: true,
          child: Text(
            '${calendarDate(point.date)} · ${point.rate.toStringAsFixed(4)} EGP',
            style: theme.textTheme.titleSmall,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < points.length; i++)
              Semantics(
                label: 'Inspect ${calendarDate(points[i].date)}',
                child: ChoiceChip(
                  label: Text('${points[i].date.day}/${points[i].date.month}'),
                  selected: index == i,
                  onSelected: (_) => setState(() => selected = i),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class HistoryPainter extends CustomPainter {
  HistoryPainter(
    this.points,
    this.selected,
    this.line,
    this.grid,
    this.labelStyle,
  );
  final List<HistoryPoint> points;
  final int selected;
  final Color line;
  final Color grid;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final low = points.map((p) => p.rate).reduce(math.min);
    final high = points.map((p) => p.rate).reduce(math.max);
    final padding = math.max(
      (high - low) * 0.15,
      math.max(high.abs() * 0.0001, 0.00001),
    );
    final min = low - padding, max = high + padding;
    TextPainter text(String value) => TextPainter(
      text: TextSpan(text: value, style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    final labels = [
      for (var i = 0; i < 3; i++)
        text((min + (max - min) * i / 2).toStringAsFixed(4)),
    ];
    final left = labels.map((p) => p.width).reduce(math.max) + 10;
    final right = size.width - 8, top = 12.0, bottom = size.height - 30;
    double x(int i) =>
        left +
        (right - left) * (points.length == 1 ? 0.5 : i / (points.length - 1));
    double y(double value) =>
        bottom - (value - min) / (max - min) * (bottom - top);
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var i = 0; i < 3; i++) {
      final ypos = y(min + (max - min) * i / 2);
      canvas.drawLine(Offset(left, ypos), Offset(right, ypos), gridPaint);
      labels[i].paint(
        canvas,
        Offset(left - labels[i].width - 8, ypos - labels[i].height / 2),
      );
    }
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(x(i), y(points[i].rate));
      } else {
        path.lineTo(x(i), y(points[i].rate));
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(
        Offset(x(i), y(points[i].rate)),
        i == selected ? 5 : 2.5,
        Paint()..color = line,
      );
    }
    for (final i in {0, points.length ~/ 2, points.length - 1}) {
      final date = points[i].date;
      final label = text('${date.day}/${date.month}');
      final xpos = (x(i) - label.width / 2).clamp(left, right - label.width);
      label.paint(canvas, Offset(xpos, bottom + 10));
    }
  }

  @override
  bool shouldRepaint(HistoryPainter old) =>
      old.points != points ||
      old.selected != selected ||
      old.line != line ||
      old.grid != grid ||
      old.labelStyle != labelStyle;
}
