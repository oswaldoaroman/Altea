import 'package:flutter/material.dart';
import '../../topics/colors.dart';

class SustanciasSection extends StatelessWidget {
  final bool cigarro;
  final bool alcohol;
  final ValueChanged<bool?> onCigarroChanged;
  final ValueChanged<bool?> onAlcoholChanged;

  const SustanciasSection({
    super.key,
    required this.cigarro,
    required this.alcohol,
    required this.onCigarroChanged,
    required this.onAlcoholChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.7,
          child: const Text('¿Consumes alguna de las siguientes sustancias?',
              style: TextStyle(fontSize: 15)),
        ),
        const SizedBox(height: 8),
        _checkRow('Cigarro', Icons.smoking_rooms, cigarro, onCigarroChanged),
        _checkRow('Alcohol', Icons.local_bar, alcohol, onAlcoholChanged),
      ],
    );
  }

  Widget _checkRow(String label, IconData icon, bool value, ValueChanged<bool?> onChanged) {
    return Row(children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        activeColor: AppColors.dark,
      ),
      Icon(icon, size: 18, color: AppColors.dark),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 15)),
    ]);
  }
}
