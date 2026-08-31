import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/colors.dart';
import '../../widgets_reutilizables/app_card.dart';
import '../../widgets_reutilizables/responsive_body.dart';
 
class UsageInstructions  extends StatelessWidget {
  const UsageInstructions({super.key});
 
  static const _pasos = [
    (Icons.favorite_rounded, 'Haz tu evaluación', 'Responde unas preguntas rápidas sobre tu estilo de vida.'),
    (Icons.insights_rounded, 'Revisa tu riesgo', 'Altea te muestra tu resultado y qué factores lo afectan.'),
    (Icons.forum_rounded, 'Actúa y da seguimiento', 'Sigue las recomendaciones, habla con Altea o agenda con tu médico.'),
  ];
 

  static const _urlAltea = 'https://altea.cis-itver.net/';
 
  Future<void> _abrirSitio() async {
    final uri = Uri.parse(_urlAltea);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sky,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopTitle(title: '¿Cómo usar Altea?', subtitle: 'Guía rápida', onBack: () => Navigator.pop(context)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      // Logo de la app en vez del ícono de corazón dibujado
                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset('assets/altea_logo.png', fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Cuida tu corazón en 3 pasos simples',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink),
                      ),
                      const SizedBox(height: 28),
 
                      ...List.generate(_pasos.length, (i) {
                        final (icon, titulo, desc) = _pasos[i];
                        final esUltimo = i == _pasos.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: esUltimo ? 0 : 22),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(color: AppColors.line, shape: BoxShape.circle, boxShadow: [
                                  BoxShadow(color: AppColors.ink.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
                                ]),
                                child: Icon(icon, color: AppColors.blue, size: 19),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(titulo, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.ink)),
                                    const SizedBox(height: 2),
                                    Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.slate, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
 
                      const SizedBox(height: 32),
                      PillButton(label: 'Conocer más', icon: Icons.open_in_new_rounded, onPressed: _abrirSitio),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 