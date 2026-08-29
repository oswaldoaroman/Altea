import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Anillo de riesgo 
class RiskGauge extends StatelessWidget {
  final double percent; // 0-100
  const RiskGauge({super.key, required this.percent});

  Color get _zoneColor =>
      percent < 34 ? AppColors.teal : (percent < 67 ? AppColors.amber : AppColors.coral);
  String get _zoneLabel => percent < 34 ? 'Bajo' : (percent < 67 ? 'Medio' : 'Alto');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(200, 200), painter: _RingPainter(percent, _zoneColor)),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${percent.toInt()}%',
                  style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _zoneColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('Riesgo $_zoneLabel',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: _zoneColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percent;
  final Color color;
  _RingPainter(this.percent, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 16.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - stroke) / 2;

    final bg = Paint()
      ..color = AppColors.sky
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, bg);

    final fg = Paint()
      ..shader = SweepGradient(colors: [AppColors.blueLight, color])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final sweep = 2 * pi * (percent / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, sweep, false, fg);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.percent != percent;
}
