import 'package:flutter/material.dart';
import '../models/resultado_model.dart';

class ResultadoService {
  static ResultadoModel interpretarRiesgo(double riesgo) {
    final porcentajeNormalizado =
        ((riesgo / 100).clamp(0.0, 1.0) * 100).truncateToDouble() / 100;

    if (riesgo >= 70) {
      return ResultadoModel(
        riesgo: riesgo,
        porcentajeNormalizado: porcentajeNormalizado,
        label: 'Riesgo Alto',
        color: const Color(0xFFC51717),
        descripcion:
            'Probabilidad estimada: Alta\nSe recomienda atención médica.',
      );
    }

    if (riesgo >= 40) {
      return ResultadoModel(
        riesgo: riesgo,
        porcentajeNormalizado: porcentajeNormalizado,
        label: 'Riesgo Medio',
        color: Colors.orange,
        descripcion: 'Probabilidad estimada: Media\nSe recomienda monitoreo.',
      );
    }

    return ResultadoModel(
      riesgo: riesgo,
      porcentajeNormalizado: porcentajeNormalizado,
      label: 'Riesgo Bajo',
      color: Colors.green,
      descripcion: 'Probabilidad estimada: Baja\nMantenga hábitos saludables.',
    );
  }
}
