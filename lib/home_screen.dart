import 'package:flutter/material.dart';
import 'widgets/informes_section.dart';
import 'widgets/voice_section.dart';
import 'widgets/medico_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Text(
              'Informes y Servicios',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF004A99),
              ),
            ),
            SizedBox(height: 20),

            InformesSection(),

            SizedBox(height: 20),

            VoiceSection(),

            SizedBox(height: 20),

            MedicoSection(),
          ],
        ),
      ),
    );
  }
}
