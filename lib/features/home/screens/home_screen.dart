import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../widgets/home_header.dart';
import '../widgets/altea_info_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/daily_tip_card.dart';
import '../widgets/patient_card.dart';
import '../widgets/premium_toggle.dart';
import '../../form/screens/screen_evaluacion.dart';
import '../../services/screens/screen_servicios.dart';

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
