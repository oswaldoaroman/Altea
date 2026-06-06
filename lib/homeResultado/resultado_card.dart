import 'dart:ui';
import 'package:flutter/material.dart';
import 'riesgo_gauge.dart';

class ResultadoCard extends StatelessWidget {
  final double riesgo;

  const ResultadoCard({super.key, required this.riesgo});

  @override
  Widget build(BuildContext context) {
    String label;
    Color labelColor;
    String descripcion;

    final double riesgoNormalizado = (riesgo / 100).clamp(0.0, 1.0);

    final double truncado = (riesgoNormalizado * 100).truncateToDouble() / 100;

    print('Riesgo normalizado: $riesgoNormalizado, truncado: $truncado');

    if (riesgo >= 0.7) {
      label = 'Riesgo Alto';
      labelColor = const Color(0xFFC51717);
      descripcion =
          'Probabilidad estimada: Alta\nSe recomienda atención médica';
    } else if (riesgo >= 0.4) {
      label = 'Riesgo Medio';
      labelColor = Colors.orange;
      descripcion = 'Probabilidad estimada: Media\nSe recomienda monitoreo';
    } else {
      label = 'Riesgo Bajo';
      labelColor = Colors.green;
      descripcion = 'Probabilidad estimada: Baja\nMantenga hábitos saludables';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              RiesgoGauge(
                percent: truncado,
                label: label,
                labelColor: labelColor,
              ),
              const SizedBox(height: 8),
              Opacity(
                opacity: 0.7,
                child: Text(
                  descripcion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
