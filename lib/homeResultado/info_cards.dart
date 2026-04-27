import 'dart:ui';
import 'package:flutter/material.dart';

class InfoGlassCard extends StatelessWidget {
  final String titulo;
  final List<_InfoItem> items;

  const InfoGlassCard({super.key, required this.titulo, required this.items});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: 0.5,
                child: Text(titulo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 10),
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(children: [
                      Icon(item.icon, size: 16, color: Colors.black54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(item.text,
                            style: const TextStyle(fontSize: 14, height: 1.3),
                            overflow: TextOverflow.visible),
                      ),
                      if (item.subtitle != null)
                        Opacity(
                          opacity: 0.5,
                          child: Text(item.subtitle!,
                              style: const TextStyle(fontSize: 11)),
                        ),
                    ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String text;
  final String? subtitle;
  const _InfoItem(this.icon, this.text, {this.subtitle});
}

// Instancias listas para usar
class FactoresCard extends StatelessWidget {
  const FactoresCard({super.key});
  @override
  Widget build(BuildContext context) => InfoGlassCard(
        titulo: 'Factores Detectados',
        items: const [
          _InfoItem(Icons.directions_walk, 'Sedentarismo', subtitle: '(actividad física ligera)'),
          _InfoItem(Icons.local_bar, 'Consumo Alcohol'),
          _InfoItem(Icons.smoking_rooms, 'Consumo de cigarro'),
        ],
      );
}

class RecomendacionesCard extends StatelessWidget {
  const RecomendacionesCard({super.key});
  @override
  Widget build(BuildContext context) => InfoGlassCard(
        titulo: 'Recomendaciones inmediatas',
        items: const [
          _InfoItem(Icons.medical_services_outlined, 'Consulta un médico'),
          _InfoItem(Icons.fitness_center, 'Aumenta tu actividad física'),
          _InfoItem(Icons.no_drinks, 'Reduce o elimina consumo de alcohol y cigarro'),
        ],
      );
}
