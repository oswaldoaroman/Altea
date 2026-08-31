import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../widgets_reutilizables/app_card.dart';
import '../../widgets_reutilizables/responsive_body.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _modoMedico = false;

  static const _opciones = [
    (Icons.notifications_rounded, 'Notificaciones'),
    (Icons.science_rounded, 'Historial de laboratorios'),
    (Icons.medical_services_rounded, 'Mi médico'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopTitle(title: 'Perfil', subtitle: 'Isela · Paciente'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  AppCard(
                    child: Row(
                      children: const [
                        CircleAvatar(radius: 26, backgroundColor: AppColors.navy, child: Text('IC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Isela', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
                              Text('Monitoreo cardiovascular activo', style: TextStyle(fontSize: 11.5, color: AppColors.slate, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppCard(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Column(
                      children: _opciones.map((o) {
                        final (icon, label) = o;
                        return ListTile(
                          leading: Icon(icon, color: AppColors.blue),
                          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.slate),
                          onTap: () {},
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppCard(
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.badge_rounded, color: AppColors.blue),
                      title: const Text('Cambiar a modo médico', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      subtitle: const Text('Ver la app como personal de salud', style: TextStyle(fontSize: 10.5, color: AppColors.slate)),
                      value: _modoMedico,
                      activeColor: AppColors.teal,
                      onChanged: (v) => setState(() => _modoMedico = v),
                    ),
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
