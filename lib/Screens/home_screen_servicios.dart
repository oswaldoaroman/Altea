import 'package:flutter/material.dart';
import '../homeServ/informes_section.dart';
import '../homeServ/voice_section.dart';
import '../homeServ/medico_section.dart';

class HomeServicesScreen extends StatelessWidget {
  const HomeServicesScreen({super.key});

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
