import 'package:flutter/material.dart';

import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';

import 'package:altea/features/home/models/consejo.dart';
import 'package:altea/features/home/service/consejo_service.dart';
import 'package:altea/features/home/service/fecha_service.dart';
import 'package:altea/core/service/url_service.dart';
import 'package:altea/features/home/screens/use_instructions.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FechaService _fechaService = FechaService();
  final ConsejoService _consejoService = ConsejoService();

  late Consejo consejo;
  late String fecha;

  @override
  void initState() {
    super.initState();
    consejo = _consejoService.obtenerConsejo();
    fecha = _fechaService.obtenerFechaActual();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopTitle(title: 'Hola, Isela', subtitle: fecha),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  // Panel ultimo resultado
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.navy, AppColors.blue],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Tu último resultado',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '70% Alto',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Actualizado hace 2 días',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Panel de consejo diario
                  AppCard(
                    child: Row(
                      children: [
                        Icon(consejo.icono, color: AppColors.blue, size: 34),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                consejo.titulo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12.5,
                                ),
                              ),

                              Text(
                                consejo.descripcion,
                                style: const TextStyle(
                                  color: AppColors.slate,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  PillButton(
                    label: 'Nueva evaluación',
                    icon: Icons.assignment_rounded,
                    color: AppColors.teal,
                    onPressed: () {
                      widget.onNavigate(1);
                    },
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Accesos rápidos',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                        color: AppColors.navy,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.6,
                    children: [
                      _QuickAction(
                        icon: Icons.medical_services_rounded,
                        label: 'Contactar doctor',
                        onTap: () {
                          UrlService.abrirGoogleMaps('doctores cerca de mí');
                        },
                      ),
                      _QuickAction(
                        icon: Icons.science_rounded,
                        label: 'Laboratorios',
                        onTap: () {
                          UrlService.abrirGoogleMaps(
                            'laboratorios cerca de mí',
                          );
                        },
                      ),
                      const _QuickAction(
                        icon: Icons.menu_book_rounded,
                        label: 'Recomendaciones',
                      ),
                      _QuickAction(
                        icon: Icons.chat_bubble_rounded,
                        label: 'Chat Altea',
                        onTap: () {
                          widget.onNavigate(3);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PillButton(
                    label: '¿Como usar altea?',
                    color: AppColors.navy,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UsageInstructions(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickAction({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 1.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.blue, size: 20),
              const Spacer(),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
