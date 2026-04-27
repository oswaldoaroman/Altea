import 'package:flutter/material.dart';
import '../topics/colors.dart';
import '../homeInicio/home_header.dart';
import '../homeInicio/altea_info_card.dart';
import '../homeInicio/quick_action_button.dart';
import '../homeInicio/daily_tip_card.dart';
import '../homeInicio/patient_card.dart';
import '../homeInicio/premium_toggle.dart';

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
            children: const [
              HomeHeader(),
              SizedBox(height: 16),
              AlteaInfoCard(),
              SizedBox(height: 12),
              QuickActionButton(label: 'Registro por voz', icon: Icons.mic_none),
              QuickActionButton(label: 'Chequeo rapido', icon: Icons.favorite_border, opacity: 0.85),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text('Mis consejos diarios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
