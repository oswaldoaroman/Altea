import 'package:altea/features/resultado/models/resultado_model.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../widgets/resultado_card.dart';
import '../widgets/info_cards.dart';
import 'package:altea/features/resultado/service/resultado_service.dart';

class ResultadoScreen extends StatelessWidget {
  final double riesgo;
  ResultadoModel get resultado => ResultadoService.interpretarRiesgo(riesgo);

  final List<InfoItem> factores;

  final List<InfoItem> recomendaciones;

  const ResultadoScreen({
    super.key,
    required this.riesgo,
    required this.factores,
    required this.recomendaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBFF),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBFF),
        elevation: 0,

        leading: const BackButton(color: Colors.black),

        title: const Text(
          'Altea',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,

              colors: [AppColors.primary, Color(0xFFF3FBFF)],
            ),

            borderRadius: BorderRadius.circular(40),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Tu Evaluación Actual',

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 16),

              ResultadoCard(
                riesgo: resultado.riesgo,
                porcentajeNormalizado: resultado.porcentajeNormalizado,
                label: resultado.label,
                labelColor: resultado.color,
                descripcion: resultado.descripcion,
              ),

              const SizedBox(height: 12),

              FactoresCard(items: factores),

              const SizedBox(height: 12),

              RecomendacionesCard(items: recomendaciones),
            ],
          ),
        ),
      ),
    );
  }
}
