import 'dart:ui';
import 'package:flutter/material.dart';
import 'riesgo_gauge.dart';

class ResultadoCard extends StatelessWidget {
  const ResultadoCard({super.key});

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
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              const RiesgoGauge(
                percent: 0.70,
                label: 'Riesgo Alto',
                labelColor: Color(0xFFC51717),
              ),
              const SizedBox(height: 8),
              Opacity(
                opacity: 0.7,
                child: const Text(
                  'Probabilidad estimada: Alta\nSe recomienda atención médica',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
