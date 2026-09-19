import '../models/evaluation_input.dart';

/// Convierte datos del formulario (bool, int categórico, peso, etc.)
/// a un `EvaluationInput` que el `EvaluationEngine` pueda consumir.
///
/// Aísla aquí toda la "traducción" entre lo que ve el usuario y lo que
/// el motor determinista necesita. Cualquier cambio en la forma del
/// formulario se refleja solo en este archivo.
class EvaluationMapper {
  EvaluationMapper._();

  // ==========================================================
  // PRESIÓN
  // ==========================================================

  /// Convierte una presión categórica (1, 2, 3) a un par
  /// sistólica/diastólica estimado.
  ///
  /// ⚠️ ESTA ES UNA ESTIMACIÓN SINTÉTICA, NO CLÍNICA.
  /// Los valores generados dependen de edad y peso, pero no
  /// representan una medición real. Se usa solo porque el
  /// formulario pide "nivel de presión" en lugar de valores
  /// concretos.
  ///
  /// TODO: en el futuro, pedir presión real (sistólica/diastólica)
  /// y eliminar esta función.
  static Map<String, double> convertirPresion(
    int? presion,
    int edad,
    double peso,
  ) {
    int seed = edad + peso.toInt();

    switch (presion) {
      case 1:
        return {
          'apHi': 110 + (seed % 20).toDouble(),
          'apLo': 70 + (seed % 15).toDouble(),
        };

      case 2:
        return {
          'apHi': 130 + (seed % 10).toDouble(),
          'apLo': 85 + (seed % 5).toDouble(),
        };

      case 3:
        return {
          'apHi': 140 + (seed % 20).toDouble(),
          'apLo': 90 + (seed % 10).toDouble(),
        };

      default:
        return {'apHi': 120, 'apLo': 80};
    }
  }

  // ==========================================================
  // CONSTRUCCIÓN DEL INPUT
  // ==========================================================

  /// Construye un `EvaluationInput` a partir de los datos del
  /// formulario tal cual los tiene `EvalScreen` hoy.
  ///
  /// Notas sobre las conversiones:
  /// - `fuma` (bool) → `smoke` (0.0 o 1.0).
  /// - `alcohol` (bool) → `alco` (0.0 o 1.0).
  /// - `colesterol` (int 0..2) → `cholesterol` (double 1..3).
  /// - `glucosa` (int 0..2) → `gluc` (double 1..3).
  /// - `presion` (int 0..2) → ap_hi/ap_lo vía `convertirPresion`.
  ///
  /// Los +1 son porque el formulario usa índices 0-based y el
  /// motor espera categorías 1-based.
  static EvaluationInput desdeFormulario({
    required double peso,
    required double estatura,
    required int actividadFisica,
    required int colesterol,
    required int glucosa,
    required int presion,
    required bool fuma,
    required bool alcohol,
    required int edad,
  }) {
    final presionValue = convertirPresion(presion + 1, edad, peso);

    return EvaluationInput(
      apHi: presionValue['apHi']!,
      apLo: presionValue['apLo']!,
      weight: peso,
      height: estatura,
      cholesterol: colesterol.toDouble() + 1,
      gluc: glucosa.toDouble() + 1,
      smoke: fuma ? 1.0 : 0.0,
      alco: alcohol ? 1.0 : 0.0,
      active: actividadFisica.toDouble(),
    );
  }
}
