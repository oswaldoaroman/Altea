import 'package:flutter/material.dart';
import 'widgets/informes_section.dart';
import 'widgets/voice_section.dart';
import 'widgets/medico_section.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1F0F7),
      appBar: AppBar(
        title: Text("Informes y Servicios"),
        backgroundColor: Color(0xFF004A99),
      ),
      body: ListView(
        children: [
          InformesSection(),
          VoiceSection(),
          MedicoSection(),
        ],
      ),
    );
  }
}
