import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class ActividadSection extends StatelessWidget {
  final String? actividad;
  final ValueChanged<String?> onChanged;

  const ActividadSection({
    super.key,
    required this.actividad,
    required this.onChanged,
  });

  static const _opciones = ['Activo', 'Ligero', 'Sedentario'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.7,
          child: const Text(
            '¿Cual es tu nivel de actividad física?',
            style: TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(height: 4),
        ..._opciones.map(
          (op) => RadioListTile<String>(
            title: Text(op, style: const TextStyle(fontSize: 15)),
            value: op,
            groupValue: actividad,
            onChanged: onChanged,
            activeColor: AppColors.dark,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
      ],
    );
  }
}
