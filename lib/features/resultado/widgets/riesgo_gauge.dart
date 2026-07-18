import 'dart:math';
import 'package:flutter/material.dart';

class RiesgoGauge extends StatelessWidget {
  final double percent; // 0.0 a 1.0
  final String label;   // "Riesgo Alto"
  final Color labelColor;

  const RiesgoGauge({
    super.key,
    required this.percent,
    required this.label,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 220,
          height: 120,
          child: CustomPaint(
            painter: _GaugePainter(percent: percent),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: labelColor)),
                    Text('${(percent * 100).toInt()}%',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Bajo', style: TextStyle(fontSize: 13)),
            Text('Alto', style: TextStyle(fontSize: 13)),
          ],
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percent;
  const _GaugePainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height - 10;
    final r = size.width / 2 - 14;
    final stroke = 22.0;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // Verde (bajo)
    paint.color = const Color(0xFF008F06);
    canvas.drawArc(rect, pi, pi * 0.33, false, paint);

    // Amarillo (medio)
    paint.color = const Color(0xFFF59E0B);
    canvas.drawArc(rect, pi + pi * 0.33, pi * 0.34, false, paint);

    // Rojo (alto)
    paint.color = const Color(0xFFC51717);
    canvas.drawArc(rect, pi + pi * 0.67, pi * 0.33, false, paint);

    // Aguja
    final angle = pi + pi * percent;
    final needleX = cx + (r) * cos(angle);
    final needleY = cy + (r) * sin(angle);
    paint
      ..color = Colors.black54
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy), Offset(needleX, needleY), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
