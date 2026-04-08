import 'package:flutter/material.dart';

class MedicoSection extends StatelessWidget {
  const MedicoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Encuentra Médicos y Laboratorios',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),

        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Dr. Ejemplo'),
          subtitle: const Text('(0.6 km)'),
        ),

        ListTile(
          leading: const Icon(Icons.science),
          title: const Text('Laboratorio X'),
          subtitle: const Text('(0.6 km)'),
        ),

        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: () {},
          child: const Text('Ver todos en el mapa'),
        )
      ],
    );
  }
}
