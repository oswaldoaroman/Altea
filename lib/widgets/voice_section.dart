import 'package:flutter/material.dart';

class VoiceSection extends StatelessWidget {
  const VoiceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Registros por voz de Salud',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),

        ListTile(
          title: const Text('Resumen Diario'),
          subtitle: const Text('03 abril 2026 - 4:27 am'),
          trailing: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
        ),

        ListTile(
          title: const Text('Resumen Diario'),
          subtitle: const Text('03 abril 2026 - 4:27 am'),
          trailing: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
        ),

        const SizedBox(height: 10),

        Center(
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.mic),
              ),
              const SizedBox(height: 5),
              const Text('Grabar Nuevo Registro')
            ],
          ),
        )
      ],
    );
  }
}
