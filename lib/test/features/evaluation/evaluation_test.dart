import 'package:flutter_test/flutter_test.dart';

import 'package:altea/features/evaluation/models/evaluation_input.dart';
import 'package:altea/features/evaluation/service/evaluacion_service.dart';
import 'package:altea/features/evaluation/service/evaluation_engine.dart';

import 'package:altea/test/features/evaluation/case.dart';

void main() {
  group('EvaluationEngine', () {
    // ==========================================================
    // VALIDACIÓN CONTRA cases.json
    // ==========================================================

    test('coincide con los expected_score de cases.json', () {
      for (final caso in casosEvaluacion) {
        final input = EvaluationInput(
          apHi: caso['apHi'] as double,
          apLo: caso['apLo'] as double,
          weight: caso['weight'] as double,
          height: caso['height'] as double,
          cholesterol: caso['cholesterol'] as double,
          gluc: caso['gluc'] as double,
          smoke: caso['smoke'] as double,
          alco: caso['alco'] as double,
          active: caso['active'] as double,
        );

        final result = EvaluationEngine.evaluar(
          input: input,
          age: caso['age'] as double,
        );

        expect(
          result.score,
          closeTo(caso['expected'] as double, 1e-6),
          reason: 'Caso "${caso['name']}" no coincide con expected',
        );
      }
    });

    // ==========================================================
    // VALIDACIÓN CONTRA EvaluacionService VIEJO
    // ==========================================================

    test('coincide con EvaluacionService (motor viejo)', () {
      for (final caso in casosEvaluacion) {
        final input = EvaluationInput(
          apHi: caso['apHi'] as double,
          apLo: caso['apLo'] as double,
          weight: caso['weight'] as double,
          height: caso['height'] as double,
          cholesterol: caso['cholesterol'] as double,
          gluc: caso['gluc'] as double,
          smoke: caso['smoke'] as double,
          alco: caso['alco'] as double,
          active: caso['active'] as double,
        );

        final resultNuevo = EvaluationEngine.evaluar(
          input: input,
          age: caso['age'] as double,
        );

        final resultViejo = EvaluacionService.evaluar(
          apHi: caso['apHi'] as double,
          apLo: caso['apLo'] as double,
          age: caso['age'] as double,
          weight: caso['weight'] as double,
          height: caso['height'] as double,
          cholesterol: caso['cholesterol'] as double,
          gluc: caso['gluc'] as double,
          smoke: caso['smoke'] as double,
          alco: caso['alco'] as double,
          active: caso['active'] as double,
        );

        expect(
          resultNuevo.score,
          closeTo(resultViejo, 1e-6),
          reason: 'Caso "${caso['name']}" diverge entre motor nuevo y viejo',
        );
      }
    });

    // ==========================================================
    // NIVEL
    // ==========================================================

    test('deriva el nivel correctamente del score', () {
      final input = EvaluationInput(
        apHi: 110,
        apLo: 70,
        weight: 60,
        height: 165,
        cholesterol: 1,
        gluc: 1,
        smoke: 0,
        alco: 0,
        active: 1,
      );

      final result = EvaluationEngine.evaluar(input: input, age: 25);

      expect(result.level, 'bajo');
      expect(result.score, closeTo(20.28, 1e-6));
    });
  });
}
