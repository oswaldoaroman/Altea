import 'package:flutter/material.dart';

import 'package:altea/features/result/screens/result_screen.dart';
import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';

class EvalScreen extends StatefulWidget {
  const EvalScreen({super.key});

  @override
  State<EvalScreen> createState() => _EvalScreenState();
}

class _EvalScreenState extends State<EvalScreen> {
  double _peso = 76;
  double _estatura = 175;
  int _actividad_fisica = 1; // 0 activo, 1 ligera, 2 sedentario
  int _actividad_colesterol = 1;
  int _actividad_glucosa = 1;
  bool _fuma = true;
  bool _alcohol = false;

  static const _niveles = ['Activo', 'Ligera', 'Sedentario'];
  static const _colesterol = ['Bajo', 'Normal', 'Alto'];
  static const _glucosa = ['Bajo', 'Normal', 'Alto'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopTitle(
                title: 'Evaluación corporal',
                subtitle: 'Paso 1 de 2',
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Peso: ${_peso.toInt()} kg',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),

                          Slider.adaptive(
                            value: _peso,
                            min: 40,
                            max: 150,
                            activeColor: AppColors.blue,
                            onChanged: (v) => setState(() => _peso = v),
                          ),

                          Text(
                            'Estatura: ${_estatura.toInt()} cm',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),

                          Slider.adaptive(
                            value: _estatura,
                            min: 130,
                            max: 210,
                            activeColor: AppColors.blue,
                            onChanged: (v) => setState(() => _estatura = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nivel de actividad física',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: List.generate(_niveles.length, (i) {
                              final active = _actividad_fisica == i;

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: ChoiceChip(
                                    label: Text(_niveles[i]),
                                    selected: active,
                                    onSelected: (_) =>
                                        setState(() => _actividad_fisica = i),
                                    selectedColor: AppColors.blue,
                                    backgroundColor: AppColors.sky,
                                    labelStyle: TextStyle(
                                      color: active
                                          ? Colors.white
                                          : AppColors.ink,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const Text(
                            '¿Como esta tu colesterol?',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: List.generate(_colesterol.length, (i) {
                              final active = _actividad_colesterol == i;

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: ChoiceChip(
                                    label: Text(_colesterol[i]),
                                    selected: active,
                                    onSelected: (_) => setState(
                                      () => _actividad_colesterol = i,
                                    ),
                                    selectedColor: AppColors.blue,
                                    backgroundColor: AppColors.sky,
                                    labelStyle: TextStyle(
                                      color: active
                                          ? Colors.white
                                          : AppColors.ink,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const Text(
                            '¿Como esta tu glucosa?',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: List.generate(_glucosa.length, (i) {
                              final active = _actividad_glucosa == i;

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: ChoiceChip(
                                    label: Text(_glucosa[i]),
                                    selected: active,
                                    onSelected: (_) =>
                                        setState(() => _actividad_glucosa = i),
                                    selectedColor: AppColors.blue,
                                    backgroundColor: AppColors.sky,
                                    labelStyle: TextStyle(
                                      color: active
                                          ? Colors.white
                                          : AppColors.ink,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 6),

                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Consumo de cigarro',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            value: _fuma,
                            activeColor: AppColors.teal,
                            onChanged: (v) => setState(() => _fuma = v),
                          ),

                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Consumo de alcohol',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            value: _alcohol,
                            activeColor: AppColors.teal,
                            onChanged: (v) => setState(() => _alcohol = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    PillButton(
                      label: 'Calcular mi riesgo',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResultScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
