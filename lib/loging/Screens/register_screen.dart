import 'package:altea/loging/widget/auth_text_field.dart';
import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../widgets_reutilizables/app_card.dart';

import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sky,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => Navigator.pop(context)),
              const SizedBox(height: 20),
              const Text('Crea tu cuenta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 4),
              const Text('Empieza a cuidar tu corazón hoy', style: TextStyle(fontSize: 13.5, color: AppColors.slate, fontWeight: FontWeight.w600)),
              const SizedBox(height: 28),

              const AuthTextField(label: 'Nombre completo', hint: 'Tu nombre'),
              const SizedBox(height: 16),
              const AuthTextField(label: 'Correo electrónico', hint: 'tucorreo@ejemplo.com', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              const AuthTextField(label: 'Contraseña', hint: 'Crea una contraseña', esPassword: true),
              const SizedBox(height: 16),
              const AuthTextField(label: 'Confirmar contraseña', hint: 'Repite tu contraseña', esPassword: true),
              const SizedBox(height: 26),

              PillButton(label: 'Registrarme', color: AppColors.teal, onPressed: () {}),
              const SizedBox(height: 24),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta? ', style: TextStyle(color: AppColors.slate, fontSize: 12.5)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                      child: const Text('Inicia sesión', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w800, fontSize: 12.5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
