/// Modelos tipados para los mensajes del WebSocket.
///
/// Cada mensaje del backend tiene un `type` string. En lugar de
/// manejar `Map<String, dynamic>` por todo el código, parseamos a
/// objetos tipados.
///
/// Sealed class → el compilador obliga a manejar todos los casos
/// en un `switch`.
sealed class WsMessage {
  const WsMessage();

  /// Parsea un JSON recibido del backend al subtipo correcto.
  factory WsMessage.fromJson(Map<String, dynamic> json) {
    final type = json['type'];

    if (type is! String) {
      return const UnknownMessage(type: 'desconocido', raw: {});
    }

    try {
      switch (type) {
        case 'assistant_message':
          return AssistantMessage.fromJson(json);
        case 'evaluation_started':
          return EvaluationStarted.fromJson(json);
        case 'evaluation_data':
          return EvaluationData.fromJson(json);
        case 'evaluation_complete':
          return EvaluationComplete.fromJson(json);
        case 'evaluation_error':
          return EvaluationErrorMessage.fromJson(json);
        case 'evaluation_cancelled':
          return EvaluationCancelled.fromJson(json);
        case 'error':
          return ErrorMessage.fromJson(json);
        case 'done':
          return const DoneMessage();
        default:
          return UnknownMessage(type: type, raw: json);
      }
    } catch (_) {
      // Si el parsing falla, no rompemos el stream.
      return UnknownMessage(type: type, raw: json);
    }
  }
}

// ==========================================================
// ASSISTANT MESSAGE
// ==========================================================

class AssistantMessage extends WsMessage {
  final String content;

  const AssistantMessage({required this.content});

  factory AssistantMessage.fromJson(Map<String, dynamic> json) {
    return AssistantMessage(content: json['content'] as String? ?? '');
  }

  @override
  String toString() => 'AssistantMessage(content: $content)';
}

// ==========================================================
// EVALUATION STARTED
// ==========================================================

class EvaluationStarted extends WsMessage {
  final List<String> requiredFields;

  const EvaluationStarted({required this.requiredFields});

  factory EvaluationStarted.fromJson(Map<String, dynamic> json) {
    final raw = json['required_fields'];
    final fields = (raw is List)
        ? raw.map((e) => e.toString()).toList()
        : <String>[];

    return EvaluationStarted(requiredFields: fields);
  }

  @override
  String toString() => 'EvaluationStarted(requiredFields: $requiredFields)';
}

// ==========================================================
// EVALUATION DATA
// ==========================================================

class EvaluationData extends WsMessage {
  final String field;
  final dynamic value;
  final int progress;
  final int total;

  const EvaluationData({
    required this.field,
    required this.value,
    required this.progress,
    required this.total,
  });

  factory EvaluationData.fromJson(Map<String, dynamic> json) {
    return EvaluationData(
      field: json['field'] as String? ?? '',
      value: json['value'],
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  String toString() =>
      'EvaluationData(field: $field, value: $value, '
      'progress: $progress/$total)';
}

// ==========================================================
// EVALUATION COMPLETE
// ==========================================================

class EvaluationComplete extends WsMessage {
  /// Resultado del motor: score, level, factors, recommendations.
  final Map<String, dynamic> result;

  /// Datos crudos que se usaron para evaluar.
  /// Los 9 campos del EvaluationInput.
  final Map<String, dynamic> input;

  const EvaluationComplete({required this.result, required this.input});

  factory EvaluationComplete.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    final rawInput = json['input'];

    return EvaluationComplete(
      result: (rawResult is Map<String, dynamic>)
          ? rawResult
          : <String, dynamic>{},
      input: (rawInput is Map<String, dynamic>)
          ? rawInput
          : <String, dynamic>{},
    );
  }

  double get score => (result['score'] as num?)?.toDouble() ?? 0.0;

  String get level => result['level'] as String? ?? 'desconocido';

  @override
  String toString() => 'EvaluationComplete(score: $score, level: $level)';
}

// ==========================================================
// EVALUATION ERROR
// ==========================================================

class EvaluationErrorMessage extends WsMessage {
  final String field;
  final String message;

  const EvaluationErrorMessage({required this.field, required this.message});

  factory EvaluationErrorMessage.fromJson(Map<String, dynamic> json) {
    return EvaluationErrorMessage(
      field: json['field'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  @override
  String toString() =>
      'EvaluationErrorMessage(field: $field, message: $message)';
}

// ==========================================================
// EVALUATION CANCELLED
// ==========================================================

class EvaluationCancelled extends WsMessage {
  final String reason;

  const EvaluationCancelled({required this.reason});

  factory EvaluationCancelled.fromJson(Map<String, dynamic> json) {
    return EvaluationCancelled(reason: json['reason'] as String? ?? 'unknown');
  }

  @override
  String toString() => 'EvaluationCancelled(reason: $reason)';
}

// ==========================================================
// ERROR
// ==========================================================

class ErrorMessage extends WsMessage {
  final String code;
  final String message;

  const ErrorMessage({required this.code, required this.message});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      code: json['code'] as String? ?? 'unknown',
      message: json['message'] as String? ?? '',
    );
  }

  @override
  String toString() => 'ErrorMessage(code: $code, message: $message)';
}

// ==========================================================
// DONE
// ==========================================================

class DoneMessage extends WsMessage {
  const DoneMessage();

  @override
  String toString() => 'DoneMessage()';
}

// ==========================================================
// UNKNOWN
// ==========================================================

class UnknownMessage extends WsMessage {
  final String type;
  final Map<String, dynamic> raw;

  const UnknownMessage({required this.type, required this.raw});

  @override
  String toString() => 'UnknownMessage(type: $type)';
}
