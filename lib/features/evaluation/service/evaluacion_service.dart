import '../models/evaluation_input.dart';
import 'evaluation_engine.dart';
import 'evaluation_mapper.dart';

/// Fachada de evaluación.
///
/// ⚠️ Esta clase existe para compatibilidad con `EvalScreen`, que la
/// sigue llamando con la firma antigua.
///
/// Internamente delega en `EvaluationMapper` + `EvaluationEngine`.
///
/// En el futuro, `EvalScreen` debería llamar directamente al engine
/// construyendo un `EvaluationInput`, y esta clase desaparecería.
class EvaluacionService {
  EvaluacionService._();

  // ==========================================================
  // API ANTIGUA (compatibilidad)
  // ==========================================================

  /// Mantenida por compatibilidad. Delega en `EvaluationMapper`.
  ///
  /// ⚠️ La edad hardcodeada (30) es un bug latente. Ver TODO abajo.
  static Map<String, double> convertirPresion(
    int? presion,
    int edad,
    double peso,
  ) {
    return EvaluationMapper.convertirPresion(presion, edad, peso);
  }

  /// Evalúa el riesgo cardiovascular.
  ///
  /// Firma idéntica a la versión antigua: recibe parámetros sueltos
  /// y devuelve un `double` (el score).
  ///
  /// Internamente:
  /// 1. Construye un `EvaluationInput` con los datos recibidos.
  /// 2. Llama al `EvaluationEngine`.
  /// 3. Devuelve `result.score`.
  ///
  /// ⚠️ La edad hardcodeada (20) es un bug latente. Ver TODO abajo.
  static double evaluar({
    double? apHi,
    double? apLo,
    required double age,
    double? cholesterol,
    double? gluc,
    required double weight,
    required double height,
    double? smoke,
    double? alco,
    required double active,
  }) {
    // Los campos con `?` en la firma antigua son, en la práctica,
    // obligatorios (la implementación usaba `!`). Aquí los
    // exigimos explícitamente.
    assert(apHi != null, 'apHi es obligatorio');
    assert(apLo != null, 'apLo es obligatorio');
    assert(cholesterol != null, 'cholesterol es obligatorio');
    assert(gluc != null, 'gluc es obligatorio');
    assert(smoke != null, 'smoke es obligatorio');
    assert(alco != null, 'alco es obligatorio');

    final input = EvaluationInput(
      apHi: apHi!,
      apLo: apLo!,
      weight: weight,
      height: height,
      cholesterol: cholesterol!,
      gluc: gluc!,
      smoke: smoke!,
      alco: alco!,
      active: active,
    );

    final result = EvaluationEngine.evaluar(input: input, age: age);

    return result.score;
  }
}
