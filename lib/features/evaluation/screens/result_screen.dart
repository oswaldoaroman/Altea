import 'package:flutter/material.dart';

import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';
import 'package:altea/core/widgets/risk_gauge.dart';
import 'package:altea/core/service/url_service.dart';
import 'package:altea/features/evaluation/models/recommendation_model.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.resultado,
    required this.recommendationResult,
    required this.onBack,
    required this.onNavigate,
  });

  final double resultado;

  final RecommendationResult recommendationResult;

  final VoidCallback onBack;
  final void Function(int) onNavigate;

  @override
  Widget build(BuildContext context) {
    final factores = recommendationResult.factores;
    final recomendaciones = recommendationResult.recomendaciones;

    return Scaffold(
      backgroundColor: AppColors.sky,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopTitle(
                  title: 'Resultados de tu evaluación',
                  subtitle: 'Paso 2 de 2',
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      // =====================================================
                      // RESULTADO / RIESGO
                      // =====================================================
                      AppCard(
                        child: Column(
                          children: [
                            RiskGauge(percent: resultado),

                            const SizedBox(height: 10),

                            const Text(
                              'Probabilidad estimada · años de riesgo clínico',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.slate,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =====================================================
                      // FACTORES DETECTADOS
                      // =====================================================
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Factores detectados',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                            color: AppColors.navy,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (factores.isEmpty)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'No se detectaron factores de riesgo.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.slate,
                            ),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: factores.map((factor) {
                            return _buildFactorChip(factor);
                          }).toList(),
                        ),

                      const SizedBox(height: 16),

                      // =====================================================
                      // RECOMENDACIONES
                      // =====================================================
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recomendaciones inmediatas',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                                color: AppColors.navy,
                              ),
                            ),

                            const SizedBox(height: 10),

                            if (recomendaciones.isEmpty)
                              const Text(
                                'Continúa manteniendo hábitos saludables.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              )
                            else
                              ...List.generate(recomendaciones.length, (index) {
                                final recomendacion = recomendaciones[index];

                                return _buildRecommendation(
                                  index,
                                  recomendacion,
                                );
                              }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // =====================================================
                      // BOTONES
                      // =====================================================
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                onNavigate(3);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.blue,
                                side: const BorderSide(
                                  color: AppColors.blue,
                                  width: 1.5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: const Text(
                                'Preguntar a Altea',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: PillButton(
                              label: 'Contactar doctor',
                              color: AppColors.navy,
                              onPressed: () {
                                UrlService.abrirGoogleMaps(
                                  'doctores cerca de mí',
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // =====================================================
                      // VOLVER
                      // =====================================================
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text(
                            'Volver a la evaluación',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.navy,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // FACTOR CHIP
  // ===============================================================

  Widget _buildFactorChip(DetectedFactor factor) {
    final config = _factorConfig(factor.id);

    return Chip(
      avatar: Icon(config.icon, size: 15, color: config.color),
      label: Text(
        factor.nombre,
        style: TextStyle(
          color: config.color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
      backgroundColor: config.color.withOpacity(0.08),
      side: BorderSide.none,
    );
  }

  // ===============================================================
  // RECOMMENDATION
  // ===============================================================

  Widget _buildRecommendation(int index, Recommendation recommendation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.sky,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.blue,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              recommendation.texto,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // CONFIGURACIÓN VISUAL DE FACTORES
  // ===============================================================

  _FactorConfig _factorConfig(String id) {
    switch (id) {
      case 'cigarrillo':
        return const _FactorConfig(
          icon: Icons.smoking_rooms_rounded,
          color: AppColors.coral,
        );

      case 'alcohol':
        return const _FactorConfig(
          icon: Icons.local_bar_rounded,
          color: AppColors.amber,
        );

      case 'sedentarismo':
        return const _FactorConfig(
          icon: Icons.directions_walk_rounded,
          color: AppColors.amber,
        );

      case 'presion_alta':
        return const _FactorConfig(
          icon: Icons.favorite_rounded,
          color: AppColors.coral,
        );

      case 'glucosa':
        return const _FactorConfig(
          icon: Icons.water_drop_rounded,
          color: AppColors.coral,
        );

      case 'colesterol':
        return const _FactorConfig(
          icon: Icons.bloodtype_rounded,
          color: AppColors.amber,
        );

      case 'imc':
        return const _FactorConfig(
          icon: Icons.monitor_weight_rounded,
          color: AppColors.amber,
        );

      default:
        return const _FactorConfig(
          icon: Icons.warning_amber_rounded,
          color: AppColors.amber,
        );
    }
  }
}

// ===============================================================
// CONFIGURACIÓN INTERNA DEL CHIP
// ===============================================================

class _FactorConfig {
  final IconData icon;
  final Color color;

  const _FactorConfig({required this.icon, required this.color});
}
