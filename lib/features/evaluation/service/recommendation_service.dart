import 'package:altea/features/evaluation/models/recommendation_model.dart';

class RecommendationService {
  static RecommendationResult generarRecomendaciones({
    required bool fuma,
    required bool consumeAlcohol,
    required int actividadFisica,
    double? presionSistolica,
    double? presionDiastolica,
    required int glucosa,
    required int colesterol,
    required double peso,
    required double altura,
  }) {
    final factores = <DetectedFactor>[];
    final recomendaciones = <Recommendation>[];

    // =========================================================
    // 1. DETECCIÓN DE FACTORES
    // =========================================================

    // Tabaquismo
    if (fuma) {
      factores.add(
        const DetectedFactor(id: 'cigarrillo', nombre: 'Consumo de cigarro'),
      );
    }

    // Alcohol
    if (consumeAlcohol) {
      factores.add(
        const DetectedFactor(id: 'alcohol', nombre: 'Consumo de alcohol'),
      );
    }

    // Sedentarismo
    final sedentario =
        actividadFisica == 2; // 1 = Activo, 2 = Moderado, 3 = Sedentario

    if (sedentario) {
      factores.add(
        const DetectedFactor(id: 'sedentarismo', nombre: 'Sedentarismo'),
      );
    }

    // Presión arterial
    if (presionSistolica! >= 140 || presionDiastolica! >= 90) {
      factores.add(
        const DetectedFactor(
          id: 'presion_alta',
          nombre: 'Presión arterial elevada',
        ),
      );
    }

    // Glucosa
    // 1 = Normal
    // 2 = Elevada
    // 3 = Alta
    if (glucosa >= 2) {
      factores.add(
        const DetectedFactor(id: 'glucosa', nombre: 'Glucosa elevada'),
      );
    }

    // Colesterol
    // 1 = Normal
    // 2 = Elevado
    // 3 = Alto
    if (colesterol >= 2) {
      factores.add(
        const DetectedFactor(id: 'colesterol', nombre: 'Colesterol elevado'),
      );
    }

    // IMC
    final imc = calcularIMC(peso: peso, altura: altura);

    if (imc >= 25) {
      factores.add(const DetectedFactor(id: 'imc', nombre: 'IMC elevado'));
    }

    // =========================================================
    // 2. GENERACIÓN DE RECOMENDACIONES
    // =========================================================

    // -----------------------------------------
    // Tabaquismo
    // -----------------------------------------

    if (fuma) {
      recomendaciones.add(
        const Recommendation(
          id: 'reducir_cigarro',
          texto:
              'Reduce progresivamente el consumo de cigarro y considera buscar apoyo profesional para dejarlo.',
          prioridad: RecommendationPriority.alta,
        ),
      );
    }

    // -----------------------------------------
    // Alcohol
    // -----------------------------------------

    if (consumeAlcohol) {
      recomendaciones.add(
        const Recommendation(
          id: 'reducir_alcohol',
          texto:
              'Reduce el consumo de alcohol y evita que se convierta en un hábito frecuente.',
          prioridad: RecommendationPriority.media,
        ),
      );
    }

    // -----------------------------------------
    // Actividad física
    // -----------------------------------------

    if (sedentario) {
      recomendaciones.add(
        const Recommendation(
          id: 'actividad_fisica',
          texto:
              'Aumenta progresivamente tu actividad física hasta alcanzar aproximadamente 30 minutos al día.',
          prioridad: RecommendationPriority.media,
        ),
      );
    }

    // -----------------------------------------
    // Presión arterial
    // -----------------------------------------

    if (presionSistolica >= 140 || presionDiastolica! >= 90) {
      recomendaciones.add(
        const Recommendation(
          id: 'control_presion',
          texto:
              'Controla periódicamente tu presión arterial y consulta con un profesional de la salud para darle seguimiento.',
          prioridad: RecommendationPriority.alta,
        ),
      );
    }

    // -----------------------------------------
    // Glucosa
    // -----------------------------------------
    //
    // 1 = Normal
    // 2 = Elevada
    // 3 = Alta
    //

    if (glucosa == 3) {
      recomendaciones.add(
        const Recommendation(
          id: 'control_glucosa',
          texto:
              'Da seguimiento a tus niveles de glucosa y consulta con un profesional de la salud.',
          prioridad: RecommendationPriority.alta,
        ),
      );
    } else if (glucosa == 2) {
      recomendaciones.add(
        const Recommendation(
          id: 'cuidar_glucosa',
          texto:
              'Mantén una alimentación equilibrada y realiza actividad física regularmente para favorecer un mejor control de la glucosa.',
          prioridad: RecommendationPriority.media,
        ),
      );
    }

    // -----------------------------------------
    // Colesterol
    // -----------------------------------------
    //
    // 1 = Normal
    // 2 = Elevado
    // 3 = Alto
    //

    if (colesterol == 3) {
      recomendaciones.add(
        const Recommendation(
          id: 'control_colesterol',
          texto:
              'Presta especial atención a tu alimentación y consulta con un profesional para dar seguimiento a tu colesterol.',
          prioridad: RecommendationPriority.alta,
        ),
      );
    } else if (colesterol == 2) {
      recomendaciones.add(
        const Recommendation(
          id: 'cuidar_colesterol',
          texto:
              'Procura una alimentación equilibrada y limita el consumo de grasas saturadas.',
          prioridad: RecommendationPriority.media,
        ),
      );
    }

    // =========================================================
    // 3. COMBINACIÓN DE FACTORES
    // =========================================================

    // -----------------------------------------
    // Sedentarismo + IMC elevado
    // -----------------------------------------

    if (sedentario && imc >= 25) {
      eliminarRecomendacion(recomendaciones, 'actividad_fisica');

      recomendaciones.add(
        const Recommendation(
          id: 'actividad_peso',
          texto:
              'Aumenta progresivamente tu actividad física para favorecer un peso saludable.',
          prioridad: RecommendationPriority.media,
        ),
      );
    }

    // -----------------------------------------
    // Sedentarismo + glucosa elevada
    // -----------------------------------------

    if (sedentario && glucosa >= 2) {
      eliminarRecomendacion(recomendaciones, 'cuidar_glucosa');

      recomendaciones.add(
        const Recommendation(
          id: 'actividad_glucosa',
          texto:
              'Incorpora actividad física regular para ayudar a mantener niveles saludables de glucosa.',
          prioridad: RecommendationPriority.media,
        ),
      );
    }

    // -----------------------------------------
    // Sedentarismo + colesterol elevado
    // -----------------------------------------

    if (sedentario && colesterol >= 2) {
      recomendaciones.add(
        const Recommendation(
          id: 'actividad_colesterol',
          texto:
              'Combina actividad física regular con una alimentación equilibrada para cuidar tu salud cardiovascular.',
          prioridad: RecommendationPriority.media,
        ),
      );
    }

    // =========================================================
    // 4. ORDENAR POR PRIORIDAD
    // =========================================================

    recomendaciones.sort(
      (a, b) =>
          prioridadValor(b.prioridad).compareTo(prioridadValor(a.prioridad)),
    );

    // =========================================================
    // 5. ELIMINAR DUPLICADOS
    // =========================================================

    final recomendacionesUnicas = <String, Recommendation>{};

    for (final recomendacion in recomendaciones) {
      recomendacionesUnicas[recomendacion.id] = recomendacion;
    }

    // =========================================================
    // 6. MOSTRAR SOLO LAS 3 RECOMENDACIONES MÁS IMPORTANTES
    // =========================================================

    final inmediatas = recomendacionesUnicas.values.take(3).toList();

    // =========================================================
    // 7. RESULTADO
    // =========================================================

    return RecommendationResult(
      factores: factores,
      recomendaciones: inmediatas,
    );
  }

  // =========================================================
  // CALCULAR IMC
  // =========================================================

  static double calcularIMC({required double peso, required double altura}) {
    if (altura <= 0) {
      return 0;
    }

    // La altura se recibe en centímetros.
    final alturaMetros = altura / 100;

    return peso / (alturaMetros * alturaMetros);
  }

  // =========================================================
  // ELIMINAR RECOMENDACIÓN
  // =========================================================

  static void eliminarRecomendacion(
    List<Recommendation> recomendaciones,
    String id,
  ) {
    recomendaciones.removeWhere((recomendacion) => recomendacion.id == id);
  }

  // =========================================================
  // VALOR DE PRIORIDAD
  // =========================================================

  static int prioridadValor(RecommendationPriority prioridad) {
    switch (prioridad) {
      case RecommendationPriority.alta:
        return 3;

      case RecommendationPriority.media:
        return 2;

      case RecommendationPriority.baja:
        return 1;
    }
  }
}
