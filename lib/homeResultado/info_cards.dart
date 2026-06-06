import 'dart:ui';
import 'package:flutter/material.dart';

class InfoItem {
  final IconData icon;
  final String text;
  final String? subtitle;

  const InfoItem({required this.icon, required this.text, this.subtitle});
}

class InfoGlassCard extends StatelessWidget {
  final String titulo;
  final List<InfoItem> items;

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
            color: Colors.white.withOpacity(0.35),

            borderRadius: BorderRadius.circular(16),

            border: Border.all(color: Colors.white.withOpacity(0.5)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Opacity(
                opacity: 0.5,

                child: Text(
                  titulo,

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Icon(item.icon, size: 16, color: Colors.black54),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              item.text,

                              style: const TextStyle(fontSize: 14, height: 1.3),
                            ),

                            if (item.subtitle != null)
                              Opacity(
                                opacity: 0.55,

                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),

                                  child: Text(
                                    item.subtitle!,

                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FactoresCard extends StatelessWidget {
  final List<InfoItem> items;

  const FactoresCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return InfoGlassCard(titulo: 'Factores Detectados', items: items);
  }
}

class RecomendacionesCard extends StatelessWidget {
  final List<InfoItem> items;

  const RecomendacionesCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return InfoGlassCard(titulo: 'Recomendaciones inmediatas', items: items);
  }
}
