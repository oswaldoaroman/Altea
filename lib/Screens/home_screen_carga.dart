import 'package:flutter/material.dart';
import '../../../topics/colors.dart';
import '../homePantallaCarga/altea_logo.dart';
import '../homePantallaCarga/carga_textos.dart';
import '../homePantallaCarga/page_dots.dart';
import '../homePantallaCarga/cancelar_button.dart';

class PantallaCargaScreen extends StatelessWidget {
  const PantallaCargaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Opacity(
          opacity: 0.7,
          child: const Text('Evaluacion medica',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF2FBFF),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const AlteaLogo(),
                const CargaTextos(),
                const PageDots(total: 5, active: 1),
                CancelarButton(onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
