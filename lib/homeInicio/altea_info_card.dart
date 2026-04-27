import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../topics/colors.dart';

class AlteaInfoCard extends StatelessWidget {
  const AlteaInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(children: [
                    const TextSpan(text: '¿Que es ', style: TextStyle(fontSize: 22, color: Color(0xFF3D3D3D))),
                    TextSpan(text: 'Altea', style: TextStyle(fontSize: 22, color: AppColors.dark, fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' ?', style: TextStyle(fontSize: 22, color: Color(0xFF3D3D3D))),
                  ])),
                  const SizedBox(height: 10),
                  const Text(
                    'Nuestra aplicación es una herramienta tecnológica diseñada para actuar como un filtro inteligente de salud. El biomarcador clave es la homocisteína; su estudio clínico oscila entre \$700 y \$1,200 MXN.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF4F4F4F), height: 1.5),
                    
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: const [
                      Text('Leer mas', style: TextStyle(fontSize: 13,color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: Colors.white, size: 18),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(80), topRight: Radius.circular(80), bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              child: Container(
                width: 100,
                height: 130,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFE1F0F7), Color(0xFFC2EBFF)],
                  ),
                ),
                child: SvgPicture.asset('assets/Group_1.svg', fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
