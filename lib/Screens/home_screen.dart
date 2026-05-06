import 'package:flutter/material.dart';
import '../topics/colors.dart';
import '../homeInicio/home_header.dart';
import '../homeInicio/altea_info_card.dart';
import '../homeInicio/quick_action_button.dart';
import '../homeInicio/daily_tip_card.dart';
import '../homeInicio/patient_card.dart';
import '../homeInicio/premium_toggle.dart';
import 'home_screen_evaluacion.dart';
import 'home_screen_servicios.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHeader(),
              SizedBox(height: 16),
              AlteaInfoCard(),
              SizedBox(height: 12),

              // Quick action buttons
              QuickActionButton(
                label: 'Registro por voz',
                icon: Icons.mic_none,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeServicesScreen()),
                  );
                },
              ),
              QuickActionButton(
                label: 'Chequeo rapido',
                icon: Icons.favorite_border,
                opacity: 0.85,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EvaluacionScreen()),
                  );
                },
              ),

              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  'Mis consejos diarios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              DailyTipCard(),
              SizedBox(height: 16),
              PatientCard(),
              SizedBox(height: 20),
              PremiumToggle(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
