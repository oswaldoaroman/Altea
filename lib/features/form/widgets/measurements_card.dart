import 'package:flutter/material.dart';
import 'package:altea/features/form/widgets/slider_with_input.dart';
import 'package:altea/core/widgets/app_card.dart';

/// Tarjeta de peso y estatura
class MeasurementsCard extends StatelessWidget {
  final double peso;
  final double estatura;
  final ValueChanged<double> onPesoChanged;
  final ValueChanged<double> onEstaturaChanged;

  const MeasurementsCard({
    super.key,
    required this.peso,
    required this.estatura,
    required this.onPesoChanged,
    required this.onEstaturaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SliderWithInput(
            label: 'Peso',
            value: peso,
            min: 40,
            max: 150,
            suffix: 'kg',
            onChanged: onPesoChanged,
          ),
          const SizedBox(height: 10),
          SliderWithInput(
            label: 'Estatura',
            value: estatura,
            min: 130,
            max: 210,
            suffix: 'cm',
            onChanged: onEstaturaChanged,
          ),
        ],
      ),
    );
  }
}
