import 'package:flutter/material.dart';

class ResultadoModel {
  final double riesgo;
  final double porcentajeNormalizado;
  final String label;
  final Color color;
  final String descripcion;

  const ResultadoModel({
    required this.riesgo,
    required this.porcentajeNormalizado,
    required this.label,
    required this.color,
    required this.descripcion,
  });
}
