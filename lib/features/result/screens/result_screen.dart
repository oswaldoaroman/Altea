import 'package:flutter/material.dart';
import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';
import 'package:altea/core/widgets/risk_gauge.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static const _factores = [
    (Icons.smoking_rooms_rounded, 'Consumo de cigarro', AppColors.coral),
    (Icons.directions_walk_rounded, 'Sedentarismo', AppColors.amber),
    (Icons.local_bar_rounded, 'Consumo de alcohol', AppColors.amber),
  ];

  static const _recs = [
    'Consulta con un médico esta semana',
    'Aumenta tu actividad física a 30 min/día',
    'Reduce el consumo de alcohol y cigarro',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sky,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopTitle(
                  title: 'Tu evaluación',
                  subtitle: 'Resultado actual',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      AppCard(
                        child: Column(
                          children: const [
                            RiskGauge(percent: 70),
                            SizedBox(height: 10),
                            Text(
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Factores detectados',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _factores.map((f) {
                          final (icon, label, color) = f;
                          return Chip(
                            avatar: Icon(icon, size: 15, color: color),
                            label: Text(
                              label,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: color.withOpacity(0.08),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
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
                            ...List.generate(
                              _recs.length,
                              (i) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: AppColors.sky,
                                      child: Text(
                                        '${i + 1}',
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
                                        _recs[i],
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
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
                              onPressed: () {},
                            ),
                          ),
                        ],
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
}
