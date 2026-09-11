import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../widgets_reutilizables/app_card.dart';
import '../../loging/widget/auth_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              const Text('Bienvenido de nuevo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink)),
              const SizedBox(height: 4),
              const Text('Nos alegra verte otra vez', style: TextStyle(fontSize: 13.5, color: AppColors.slate, fontWeight: FontWeight.w600)),
              const SizedBox(height: 28),

              const AuthTextField(label: 'Correo electrónico', hint: 'tucorreo@ejemplo.com', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              const AuthTextField(label: 'Contraseña', hint: 'Tu contraseña', esPassword: true),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
              const SizedBox(height: 10),

              PillButton(label: 'Iniciar sesión', onPressed: () {}),
              const SizedBox(height: 24),

              Row(
                children: const [
                  Expanded(child: Divider(color: AppColors.line)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('O inicia sesión con', style: TextStyle(color: AppColors.slate, fontSize: 11.5, fontWeight: FontWeight.w600)),
                  ),
                  Expanded(child: Divider(color: AppColors.line)),
                ],
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(child: _BotonSocial(icono: Icons.g_mobiledata_rounded, texto: 'Google')),
                  const SizedBox(width: 12),
                  Expanded(child: _BotonSocial(icono: Icons.facebook_rounded, texto: 'Facebook')),
                ],
              ),
              const SizedBox(height: 28),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? ', style: TextStyle(color: AppColors.slate, fontSize: 12.5)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: const Text('Regístrate', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w800, fontSize: 12.5)),
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

class _BotonSocial extends StatelessWidget {
  final IconData icono;
  final String texto;
  const _BotonSocial({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icono, size: 20, color: AppColors.ink),
      label: Text(texto, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, fontSize: 12.5)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.line),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
