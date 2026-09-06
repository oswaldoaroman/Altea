import 'package:flutter/material.dart';

import 'package:altea/features/evaluation/models/recommendation_model.dart';
import 'package:altea/features/evaluation/screens/eval_screen.dart';
import 'package:altea/features/evaluation/screens/result_screen.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key, required this.onNavigate});

  final void Function(int) onNavigate;

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  bool mostrarResultado = false;

  double? resultado;

  RecommendationResult? recomendaciones;

  void mostrarResultados(
    double nuevoResultado,
    RecommendationResult nuevasRecomendaciones,
  ) {
    setState(() {
      resultado = nuevoResultado;
      recomendaciones = nuevasRecomendaciones;
      mostrarResultado = true;
    });
  }

  void volverEvaluacion() {
    setState(() {
      mostrarResultado = false;
      resultado = null;
      recomendaciones = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mostrarResultado) {
      return ResultScreen(
        resultado: resultado!,
        recommendationResult: recomendaciones!,
        onBack: volverEvaluacion,
        onNavigate: widget.onNavigate,
      );
    }

    return EvalScreen(onFinished: mostrarResultados);
  }
}
