enum RecommendationPriority { alta, media, baja }

class DetectedFactor {
  final String id;
  final String nombre;

  const DetectedFactor({required this.id, required this.nombre});
}

class Recommendation {
  final String id;
  final String texto;
  final RecommendationPriority prioridad;

  const Recommendation({
    required this.id,
    required this.texto,
    required this.prioridad,
  });
}

class RecommendationResult {
  final List<DetectedFactor> factores;
  final List<Recommendation> recomendaciones;

  const RecommendationResult({
    required this.factores,
    required this.recomendaciones,
  });
}
