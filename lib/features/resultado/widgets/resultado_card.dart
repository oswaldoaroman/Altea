import 'dart:ui';
import 'package:flutter/material.dart';
import 'riesgo_gauge.dart';

class ResultadoCard extends StatelessWidget {
  final double porcentajeNormalizado;
  final double riesgo;
  final String label;
  final Color labelColor;
  final String descripcion;

  const ResultadoCard({
    super.key,
    required this.porcentajeNormalizado,
    required this.riesgo,
    required this.label,
    required this.labelColor,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
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
              RiesgoGauge(percent: porcentajeNormalizado),

              const SizedBox(height: 12),

              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),

              Text(
                '${riesgo.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
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
