import 'package:flutter/material.dart';
import 'informe_item.dart';

class InformesSection extends StatelessWidget {
  const InformesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('Informes Recientes', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),

          InformeItem(),
          InformeItem(),
          InformeItem(),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {},
            child: const Text('Generar Informe PDF Completo'),
          ),
        ],
      ),
    );
  }
}
