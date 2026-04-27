import 'package:flutter/material.dart';
import '../../topics/colors.dart';
import '../homeResultado/resultado_card.dart';
import '../homeResultado/info_cards.dart';
import '../homeResultado/accion_button.dart';

class ResultadoScreen extends StatelessWidget {
  const ResultadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBFF),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Altea',
            style: TextStyle(color: AppColors.dark, fontSize: 22, fontWeight: FontWeight.w400)),
        actions: const [
          Icon(Icons.notifications_outlined, color: Colors.black),
          SizedBox(width: 8),
          Icon(Icons.tune, color: Colors.black),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, Color(0xFFF3FBFF)],
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tu Evaluacion Actual',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              const ResultadoCard(),
              const SizedBox(height: 12),
              const FactoresCard(),
              const SizedBox(height: 12),
              const RecomendacionesCard(),
              const SizedBox(height: 16),
              AccionButton(
                label: 'Contactar un doctor',
                icon: Icons.chat_bubble_outline,
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              AccionButton(
                label: 'Ver Laboratorios',
                icon: Icons.science_outlined,
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              AccionButton(
                label: 'Ver recomendaciones',
                icon: Icons.arrow_forward,
                bgColor: AppColors.dark,
                textColor: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF91E3B),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Calcular riesgo a 10 años',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Historial médico  ›',
                      style: TextStyle(color: AppColors.dark, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
