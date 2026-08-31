import 'package:flutter/material.dart';
import 'package:altea/core/theme/colors.dart';

class SegmentedOptions extends StatelessWidget {
  final String label;
  final List<String> opciones;
  final int seleccionado;
  final ValueChanged<int> onChanged;

  const SegmentedOptions({
    super.key,
    required this.label,
    required this.opciones,
    required this.seleccionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(opciones.length, (i) {
            final activo = seleccionado == i;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ChoiceChip(
                  label: Text(opciones[i]),
                  selected: activo,

                  // you are joto?
                  onSelected: (_) => onChanged(i),
                  selectedColor: AppColors.blue,
                  backgroundColor: AppColors.sky,
                  labelStyle: TextStyle(
                    color: activo ? Colors.white : AppColors.ink,
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
      ],
    );
  }
}
