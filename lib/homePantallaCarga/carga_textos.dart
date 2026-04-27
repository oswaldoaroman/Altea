import 'package:flutter/material.dart';

class CargaTextos extends StatelessWidget {
  const CargaTextos({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Estamos analizando\ntus datos',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, height: 1.3),
        ),
        const SizedBox(height: 16),
        const Text(
          'Altea analiza tus datos y calcula tu nivel de riesgo cardiovascular',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 10),
        Opacity(
          opacity: 0.65,
          child: const Text(
            'Este proceso puede tardar unos minutos...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
        ),
      ],
    );
  }
}
