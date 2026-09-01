import 'package:flutter/material.dart';
import 'package:altea/features/evaluation/widgets/segmented_optiones.dart';
import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/app_card.dart';

/// Tarjeta de estilo de vida
class LifestyleCard extends StatelessWidget {
  static const actividadOpts = ['Activo', 'Ligera', 'Sedentario'];
  static const colesterolOpts = ['Bajo', 'Normal', 'Alto'];
  static const glucosaOpts = ['Bajo', 'Normal', 'Alto'];
  static const presionOpts = ['Normal', 'Elevada', 'Alta'];

  final int actividadFisica;
  final int colesterol;
  final int glucosa;
  final int presion;
  final bool fuma;
  final bool alcohol;
  final ValueChanged<int> onActividadChanged;
  final ValueChanged<int> onColesterolChanged;
  final ValueChanged<int> onGlucosaChanged;
  final ValueChanged<int> onPresionChanged;
  final ValueChanged<bool> onFumaChanged;
  final ValueChanged<bool> onAlcoholChanged;

  const LifestyleCard({
    super.key,
    required this.actividadFisica,
    required this.colesterol,
    required this.glucosa,
    required this.presion,
    required this.fuma,
    required this.alcohol,
    required this.onActividadChanged,
    required this.onColesterolChanged,
    required this.onGlucosaChanged,
    required this.onPresionChanged,
    required this.onFumaChanged,
    required this.onAlcoholChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedOptions(
            label: 'Nivel de actividad física',
            opciones: actividadOpts,
            seleccionado: actividadFisica,
            onChanged: onActividadChanged,
          ),
          const SizedBox(height: 16),
          SegmentedOptions(
            label: '¿Cómo está tu colesterol?',
            opciones: colesterolOpts,
            seleccionado: colesterol,
            onChanged: onColesterolChanged,
          ),
          const SizedBox(height: 16),
          SegmentedOptions(
            label: '¿Cómo está tu glucosa?',
            opciones: glucosaOpts,
            seleccionado: glucosa,
            onChanged: onGlucosaChanged,
          ),
          const SizedBox(height: 16),
          SegmentedOptions(
            label: '¿Cómo está tu presion?',
            opciones: presionOpts,
            seleccionado: presion,
            onChanged: onPresionChanged,
          ),
          const SizedBox(height: 8),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Consumo de cigarro',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
            ),
            value: fuma,
            activeColor: AppColors.teal,
            onChanged: onFumaChanged,
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Consumo de alcohol',
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
            ),
            value: alcohol,
            activeColor: AppColors.teal,
            onChanged: onAlcoholChanged,
          ),
        ],
      ),
    );
  }
}
