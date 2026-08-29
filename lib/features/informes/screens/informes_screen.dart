import 'package:flutter/material.dart';
import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';

class InformesScreen extends StatefulWidget {
  const InformesScreen({super.key});
  @override
  State<InformesScreen> createState() => _InformesScreenState();
}

class _InformesScreenState extends State<InformesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  static const _reportes = [
    'Chequeo cardiovascular',
    'Perfil de lípidos',
    'Evaluación de riesgo',
  ];
  static const _registros = ['Cómo me siento hoy', 'Después de caminar'];
  static const _medicos = [
    ('Dr. Taylor Alan Cole', 'Cardiólogo · 1.2 km'),
    ('Laboratorio Central', 'Laboratorio clínico · 0.8 km'),
    ('Dr. Adam Wolf Smith', 'Medicina interna · 2.4 km'),
  ];

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopTitle(
            title: 'Informes y servicios',
            subtitle: 'Todo tu historial en un lugar',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.sky,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(4),
              child: TabBar(
                controller: _tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: AppColors.blue,
                unselectedLabelColor: AppColors.slate,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Informes'),
                  Tab(text: 'Voz'),
                  Tab(text: 'Médicos'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _ListaSimple(
                  items: _reportes,
                  icon: Icons.description_rounded,
                  actionLabel: 'Generar informe PDF completo',
                ),
                _ListaSimple(
                  items: _registros,
                  icon: Icons.mic_rounded,
                  actionLabel: 'Grabar nuevo registro',
                  actionColor: AppColors.teal,
                ),
                _ListaMedicos(medicos: _medicos),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListaSimple extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  final String actionLabel;
  final Color actionColor;
  const _ListaSimple({
    required this.items,
    required this.icon,
    required this.actionLabel,
    this.actionColor = AppColors.navy,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
      children: [
        ...items.map(
          (label) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Row(
                children: [
                  Icon(icon, color: AppColors.blue, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.teal,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        PillButton(label: actionLabel, color: actionColor, onPressed: () {}),
      ],
    );
  }
}

class _ListaMedicos extends StatelessWidget {
  final List<(String, String)> medicos;
  const _ListaMedicos({required this.medicos});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
      children: medicos.map((m) {
        final (nombre, detalle) = m;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppCard(
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.navy,
                  child: Icon(
                    Icons.medical_services_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                      Text(
                        detalle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.slate,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.blue,
                    side: const BorderSide(color: AppColors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    'Agendar',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
