/// DTO de salida del motor de evaluación.
///
/// Contrato compartido con el backend Python
/// (`altea-api/service/evaluation/models.py`).
///
/// Cualquier cambio aquí DEBE replicarse en Python.
///
/// - `score`: número crudo del árbol (18..91 aprox).
/// - `level`: categoría derivada del score.
/// - `factors`: factores detectados (derivados del input).
///   VACÍO por ahora. La UI sigue usando `RecommendationResult`.
/// - `recommendations`: recomendaciones (derivadas del nivel + factores).
///   VACÍO por ahora. La UI sigue usando `RecommendationResult`.
class EvaluationResult {
  final double score;
  final String level;
  final List<String> factors;
  final List<String> recommendations;

  const EvaluationResult({
    required this.score,
    required this.level,
    this.factors = const [],
    this.recommendations = const [],
  });

  // ==========================================================
  // JSON
  // ==========================================================

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'level': level,
      'factors': factors,
      'recommendations': recommendations,
    };
  }

  factory EvaluationResult.fromJson(Map<String, dynamic> json) {
    return EvaluationResult(
      score: (json['score'] as num).toDouble(),
      level: json['level'] as String,
      factors: (json['factors'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  // ==========================================================
  // DEBUG
  // ==========================================================

  @override
  String toString() {
    return 'EvaluationResult('
        'score: $score, '
        'level: $level, '
        'factors: $factors, '
        'recommendations: $recommendations'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EvaluationResult &&
        other.score == score &&
        other.level == level &&
        _listEquals(other.factors, factors) &&
        _listEquals(other.recommendations, recommendations);
  }

  @override
  int get hashCode {
    return Object.hash(
      score,
      level,
      Object.hashAll(factors),
      Object.hashAll(recommendations),
    );
  }
}

// ==========================================================
// HELPERS
// ==========================================================

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;

  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }

  return true;
}
