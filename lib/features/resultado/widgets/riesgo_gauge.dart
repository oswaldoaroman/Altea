import 'dart:math';
import 'package:flutter/material.dart';

class RiesgoGauge extends StatelessWidget {
  final double percent; // Valor entre 0.0 y 1.0

  const RiesgoGauge({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 220,
          height: 120,
          child: CustomPaint(painter: _GaugePainter(percent: percent)),
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
    const stroke = 22.0;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // Zona verde
    paint.color = const Color(0xFF008F06);
    canvas.drawArc(rect, pi, pi * 0.33, false, paint);

    // Zona amarilla
    paint.color = const Color(0xFFF59E0B);
    canvas.drawArc(rect, pi + pi * 0.33, pi * 0.34, false, paint);

    // Zona roja
    paint.color = const Color(0xFFC51717);
    canvas.drawArc(rect, pi + pi * 0.67, pi * 0.33, false, paint);

    // Aguja
    final angle = pi + (pi * percent);

    final needleX = cx + r * cos(angle);
    final needleY = cy + r * sin(angle);

    paint
      ..color = Colors.black54
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx, cy), Offset(needleX, needleY), paint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percent != percent;
  }
}
