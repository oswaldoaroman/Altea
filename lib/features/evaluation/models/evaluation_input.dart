/// DTO de entrada del motor de evaluación.
///
/// Contrato compartido con el backend Python
/// (`altea-api/service/evaluation/models.py`).
///
/// Cualquier cambio aquí DEBE replicarse en Python.
///
/// Todos los campos son requeridos y no nulos.
/// Los categóricos (cholesterol, gluc, active) son `double`, no `int`,
/// porque el motor compara contra umbrales decimales (2.5, 0.5, etc.).
///
/// La edad NO va aquí: es un parámetro separado de
/// `EvaluationEngine.evaluar()`, porque es un dato derivado
/// (de fecha de nacimiento).
class EvaluationInput {
  final double apHi;
  final double apLo;
  final double weight;
  final double height;
  final double cholesterol;
  final double gluc;
  final double smoke;
  final double alco;
  final double active;

  const EvaluationInput({
    required this.apHi,
    required this.apLo,
    required this.weight,
    required this.height,
    required this.cholesterol,
    required this.gluc,
    required this.smoke,
    required this.alco,
    required this.active,
  });

  // ==========================================================
  // JSON
  // ==========================================================

  /// Nombres snake_case para coincidir exactamente con el JSON
  /// que produce/consume Python.
  Map<String, dynamic> toJson() {
    return {
      'ap_hi': apHi,
      'ap_lo': apLo,
      'weight': weight,
      'height': height,
      'cholesterol': cholesterol,
      'gluc': gluc,
      'smoke': smoke,
      'alco': alco,
      'active': active,
    };
  }

  factory EvaluationInput.fromJson(Map<String, dynamic> json) {
    return EvaluationInput(
      apHi: (json['ap_hi'] as num).toDouble(),
      apLo: (json['ap_lo'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      cholesterol: (json['cholesterol'] as num).toDouble(),
      gluc: (json['gluc'] as num).toDouble(),
      smoke: (json['smoke'] as num).toDouble(),
      alco: (json['alco'] as num).toDouble(),
      active: (json['active'] as num).toDouble(),
    );
  }

  // ==========================================================
  // DEBUG
  // ==========================================================

  @override
  String toString() {
    return 'EvaluationInput('
        'apHi: $apHi, '
        'apLo: $apLo, '
        'weight: $weight, '
        'height: $height, '
        'cholesterol: $cholesterol, '
        'gluc: $gluc, '
        'smoke: $smoke, '
        'alco: $alco, '
        'active: $active'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EvaluationInput &&
        other.apHi == apHi &&
        other.apLo == apLo &&
        other.weight == weight &&
        other.height == height &&
        other.cholesterol == cholesterol &&
        other.gluc == gluc &&
        other.smoke == smoke &&
        other.alco == alco &&
        other.active == active;
  }

  @override
  int get hashCode {
    return Object.hash(
      apHi,
      apLo,
      weight,
      height,
      cholesterol,
      gluc,
      smoke,
      alco,
      active,
    );
  }
}
