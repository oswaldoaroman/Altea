import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

import '../models/resultado_model.dart';
import '../service/resultado_service.dart';

import '../widgets/resultado_card.dart';
import '../widgets/info_cards.dart';
import '../widgets/accion_button.dart';

class ResultadoScreen extends StatelessWidget {
  final double riesgo;

  final List<InfoItem> factores;
  final List<InfoItem> recomendaciones;

  const ResultadoScreen({
    super.key,
    required this.riesgo,
    required this.factores,
    required this.recomendaciones,
  });

  ResultadoModel get resultado => ResultadoService.interpretarRiesgo(riesgo);

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

              const SizedBox(height: 16),

              AccionButton(
                label: 'Contactar un doctor',
                icon: Icons.chat_bubble_outline,
                onPressed: () {},
              ),

              const SizedBox(height: 8),

              AccionButton(
                label: 'Ver Laboratorios',
                icon: Icons.science_outlined,
                onPressed: () {},
              ),

              const SizedBox(height: 8),

              AccionButton(
                label: 'Ver recomendaciones',
                icon: Icons.arrow_forward,
                bgColor: AppColors.dark,
                textColor: Colors.white,
                onPressed: () {},
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF91E3B),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Calcular riesgo a 10 años',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Historial médico  ›',
                    style: TextStyle(color: AppColors.dark, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
