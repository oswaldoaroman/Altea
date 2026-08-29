import 'package:flutter/material.dart';
import '../../result/widgets/info_cards.dart';

class RecomendacionService {
  static List<InfoItem> generarFactores({
    required bool fuma,
    required bool alcohol,
    required String actividad,
    required double colesterol,
  }) {
    List<InfoItem> factores = [];

    if (actividad == 'Sedentario') {
      factores.add(
        const InfoItem(
          icon: Icons.directions_walk,
          text: 'Sedentarismo',
          subtitle: 'Actividad física baja',
        ),
      );
    }

    if (fuma) {
      factores.add(
        const InfoItem(icon: Icons.smoking_rooms, text: 'Consumo de cigarro'),
      );
    }

    if (alcohol) {
      factores.add(
        const InfoItem(icon: Icons.local_bar, text: 'Consumo de alcohol'),
      );
    }

    if (colesterol > 200) {
      factores.add(
        const InfoItem(icon: Icons.monitor_heart, text: 'Colesterol elevado'),
      );
    }

    return factores;
  }

  static List<InfoItem> generarRecomendaciones({
    required bool fuma,
    required bool alcohol,
    required String actividad,
    required double colesterol,
  }) {
    List<InfoItem> recomendaciones = [];

    recomendaciones.add(
      const InfoItem(
        icon: Icons.medical_services_outlined,
        text: 'Consultar un médico',
      ),
    );

    if (actividad == 'Sedentario') {
      recomendaciones.add(
        const InfoItem(
          icon: Icons.fitness_center,
          text: 'Aumentar actividad física',
        ),
      );
    }

    if (fuma || alcohol) {
      recomendaciones.add(
        const InfoItem(
          icon: Icons.no_drinks,
          text: 'Reducir consumo de alcohol y cigarro',
        ),
      );
    }

    if (colesterol > 200) {
      recomendaciones.add(
        const InfoItem(
          icon: Icons.restaurant,
          text: 'Mejorar hábitos alimenticios',
        ),
      );
    }

    return recomendaciones;
  }
}
