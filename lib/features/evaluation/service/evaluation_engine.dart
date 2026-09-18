import '../models/evaluation_input.dart';
import '../models/evaluation_result.dart';

/// Motor determinista de evaluación de riesgo cardiovascular.
///
/// Port literal del motor original (`EvaluacionService.evaluar`).
/// Validado contra 12 casos compartidos con el motor Python
/// (`altea-api/service/evaluation/engine.py`).
///
/// REGLAS:
/// - Sin estado.
/// - Sin IO.
/// - Sin dependencias de Flutter.
/// - Cualquier cambio aquí DEBE replicarse en Python.
class EvaluationEngine {
  EvaluationEngine._();

  // ==========================================================
  // API PÚBLICA
  // ==========================================================

  /// Evalúa el riesgo cardiovascular.
  ///
  /// `input` contiene los datos del usuario (sin edad).
  /// `age` es la edad en años, parámetro aparte.
  static EvaluationResult evaluar({
    required EvaluationInput input,
    required double age,
  }) {
    final score = _score(input, age);

    return EvaluationResult(score: score, level: _nivelDesdeScore(score));
  }

  // ==========================================================
  // NIVEL
  // ==========================================================

  /// Cortes provisionales. Idénticos a `levels.py` del backend.
  static String _nivelDesdeScore(double score) {
    if (score < 30.0) return 'bajo';
    if (score < 55.0) return 'moderado';
    if (score < 75.0) return 'alto';
    return 'muy_alto';
  }

  // ==========================================================
  // ÁRBOL (PORT LITERAL)
  // ==========================================================

  static double _score(EvaluationInput input, double age) {
    final apHi = input.apHi;
    final apLo = input.apLo;
    final weight = input.weight;
    final height = input.height;
    final cholesterol = input.cholesterol;
    final gluc = input.gluc;
    final smoke = input.smoke;
    final alco = input.alco;
    final active = input.active;

    if (apHi <= 129.5) {
      if (age <= 52.5) {
        if (cholesterol <= 2.5) {
          if (age <= 43.5) {
            if (apHi <= 114.5) {
              if (cholesterol <= 1.5) {
                return 20.28;
              } else {
                return 34.84;
              }
            } else {
              if (cholesterol <= 1.5) {
                return 30.15;
              } else {
                return 45.35;
              }
            }
          } else {
            if (apHi <= 118.5) {
              if (weight <= 64.5) {
                return 26.33;
              } else {
                return 35.90;
              }
            } else {
              if (cholesterol <= 1.5) {
                return 40.18;
              } else {
                return 50.76;
              }
            }
          }
        } else {
          if (gluc <= 2.5) {
            if (apLo <= 79.5) {
              if (age <= 41.5) {
                return 56.20;
              } else {
                return 70.03;
              }
            } else {
              if (weight <= 73.5) {
                return 74.17;
              } else {
                return 81.92;
              }
            }
          } else {
            if (age <= 40.5) {
              if (apHi <= 105) {
                return 18.67;
              } else {
                return 45.14;
              }
            } else {
              if (apLo <= 77) {
                return 51.14;
              } else {
                return 65.76;
              }
            }
          }
        }
      } else {
        if (cholesterol <= 2.5) {
          if (age <= 60.5) {
            if (apHi <= 119.5) {
              if (weight <= 64.25) {
                return 38.41;
              } else {
                return 48.07;
              }
            } else {
              if (age <= 54.5) {
                return 48.87;
              } else {
                return 57.21;
              }
            }
          } else {
            if (apLo <= 78.5) {
              if (weight <= 54.5) {
                return 44.64;
              } else {
                return 60.03;
              }
            } else {
              if (active <= 0.5) {
                return 70.81;
              } else {
                return 64.91;
              }
            }
          }
        } else {
          if (gluc <= 2.5) {
            if (apHi <= 102.5) {
              if (alco <= 0.5) {
                return 70.99;
              } else {
                return 53.14;
              }
            } else {
              if (height <= 185.5) {
                return 82.49;
              } else {
                return 48.12;
              }
            }
          } else {
            if (age <= 60.5) {
              if (weight <= 77.5) {
                return 69.32;
              } else {
                return 77.30;
              }
            } else {
              if (weight <= 65.5) {
                return 79.05;
              } else {
                return 83.16;
              }
            }
          }
        }
      }
    }
    // =========================
    // PRESIÓN > 129.5
    // =========================
    else {
      if (apHi <= 138.5) {
        if (cholesterol <= 2.5) {
          if (age <= 58.5) {
            if (apLo <= 89.5) {
              if (smoke <= 0.5) {
                return 66.14;
              } else {
                return 56.68;
              }
            } else {
              if (smoke <= 0.5) {
                return 74.17;
              } else {
                return 65.12;
              }
            }
          } else {
            if (smoke <= 0.5) {
              if (apLo <= 88.5) {
                return 75.11;
              } else {
                return 78.50;
              }
            } else {
              if (apLo <= 82.5) {
                return 67.15;
              } else {
                return 71.84;
              }
            }
          }
        } else {
          if (smoke <= 0.5) {
            if (gluc <= 2.5) {
              if (height <= 178.5) {
                return 87.65;
              } else {
                return 82.27;
              }
            } else {
              if (age <= 60.5) {
                return 83.68;
              } else {
                return 87.66;
              }
            }
          } else {
            if (weight <= 62.5) {
              return 63.30;
            } else {
              if (height <= 179.5) {
                return 82.99;
              } else {
                return 74.53;
              }
            }
          }
        }
      } else {
        if (apLo <= 86.5) {
          if (apLo <= 68.5) {
            if (apHi <= 249.5) {
              if (age <= 59.5) {
                return 75.11;
              } else {
                return 84.35;
              }
            } else {
              return 45.18;
            }
          } else {
            if (cholesterol <= 1.5) {
              if (age <= 53.5) {
                return 84.98;
              } else {
                return 87.79;
              }
            } else {
              if (weight <= 55.5) {
                return 82.09;
              } else {
                return 89.28;
              }
            }
          }
        } else {
          if (apHi <= 148.5) {
            if (gluc <= 2.5) {
              if (weight <= 54.5) {
                return 86.92;
              } else {
                return 90.43;
              }
            } else {
              if (age <= 41.5) {
                return 77.14;
              } else {
                return 87.32;
              }
            }
          } else {
            if (weight <= 43.5) {
              return 71.79;
            } else {
              if (gluc <= 2.5) {
                return 91.88;
              } else {
                return 89.99;
              }
            }
          }
        }
      }
    }
  }
}
