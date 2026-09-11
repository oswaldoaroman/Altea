class EvaluationState {
  bool activa = false;

  bool? fuma;
  bool? consumeAlcohol;

  int? actividadFisica;

  double? presionSistolica;
  double? presionDiastolica;

  int? glucosa;
  int? colesterol;

  double? peso;
  double? altura;

  // ==========================================================
  // INICIAR EVALUACIÓN
  // ==========================================================

  void iniciar() {
    activa = true;

    fuma = null;
    consumeAlcohol = null;
    actividadFisica = null;
    presionSistolica = null;
    presionDiastolica = null;
    glucosa = null;
    colesterol = null;
    peso = null;
    altura = null;
  }

  // ==========================================================
  // ASIGNAR DATO
  // ==========================================================

  bool asignarDato(String field, dynamic value) {
    try {
      switch (field) {
        case 'fuma':
          fuma = _toBool(value);
          break;

        case 'consumeAlcohol':
          consumeAlcohol = _toBool(value);
          break;

        case 'actividadFisica':
          actividadFisica = _toInt(value);
          break;

        case 'presionSistolica':
          presionSistolica = _toDouble(value);
          break;

        case 'presionDiastolica':
          presionDiastolica = _toDouble(value);
          break;

        case 'glucosa':
          glucosa = _toInt(value);
          break;

        case 'colesterol':
          colesterol = _toInt(value);
          break;

        case 'peso':
          peso = _toDouble(value);
          break;

        case 'altura':
          altura = _toDouble(value);
          break;

        default:
          return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  // ==========================================================
  // ¿ESTÁ COMPLETA?
  // ==========================================================

  bool get completa {
    return fuma != null &&
        consumeAlcohol != null &&
        actividadFisica != null &&
        glucosa != null &&
        colesterol != null &&
        peso != null &&
        altura != null;
  }

  // ==========================================================
  // FINALIZAR
  // ==========================================================

  void finalizar() {
    activa = false;
  }

  // ==========================================================
  // LIMPIAR
  // ==========================================================

  void limpiar() {
    activa = false;

    fuma = null;
    consumeAlcohol = null;
    actividadFisica = null;
    presionSistolica = null;
    presionDiastolica = null;
    glucosa = null;
    colesterol = null;
    peso = null;
    altura = null;
  }

  // ==========================================================
  // JSON
  // ==========================================================

  Map<String, dynamic> toJson() {
    return {
      'fuma': fuma,
      'consumeAlcohol': consumeAlcohol,
      'actividadFisica': actividadFisica,
      'presionSistolica': presionSistolica,
      'presionDiastolica': presionDiastolica,
      'glucosa': glucosa,
      'colesterol': colesterol,
      'peso': peso,
      'altura': altura,
    };
  }

  // ==========================================================
  // CONVERSIONES
  // ==========================================================

  bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final texto = value.toLowerCase().trim();

      if (texto == 'true' || texto == 'si' || texto == 'sí') {
        return true;
      }

      if (texto == 'false' || texto == 'no') {
        return false;
      }
    }

    throw FormatException('Valor booleano inválido: $value');
  }

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.parse(value);
    }

    throw FormatException('Valor entero inválido: $value');
  }

  double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.parse(value);
    }

    throw FormatException('Valor decimal inválido: $value');
  }
}
