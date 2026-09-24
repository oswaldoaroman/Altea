import 'package:flutter_test/flutter_test.dart';

import 'package:altea/features/chat_bot/models/ws_message.dart';

void main() {
  group('WsMessage.fromJson', () {
    test('parsea assistant_message', () {
      final msg = WsMessage.fromJson({
        'type': 'assistant_message',
        'content': 'Hola, soy Altea.',
      });

      expect(msg, isA<AssistantMessage>());
      expect((msg as AssistantMessage).content, 'Hola, soy Altea.');
    });

    test('parsea evaluation_started', () {
      final msg = WsMessage.fromJson({
        'type': 'evaluation_started',
        'required_fields': ['peso', 'altura', 'edad'],
      });

      expect(msg, isA<EvaluationStarted>());
      expect((msg as EvaluationStarted).requiredFields, [
        'peso',
        'altura',
        'edad',
      ]);
    });

    test('parsea evaluation_data', () {
      final msg = WsMessage.fromJson({
        'type': 'evaluation_data',
        'field': 'peso',
        'value': 76.0,
        'progress': 3,
        'total': 10,
      });

      expect(msg, isA<EvaluationData>());

      final data = msg as EvaluationData;
      expect(data.field, 'peso');
      expect(data.value, 76.0);
      expect(data.progress, 3);
      expect(data.total, 10);
    });

    test('parsea evaluation_complete', () {
      final msg = WsMessage.fromJson({
        'type': 'evaluation_complete',
        'result': {
          'score': 66.14,
          'level': 'alto',
          'factors': [],
          'recommendations': [],
        },
        'input': {
          'ap_hi': 130.0,
          'ap_lo': 85.0,
          'weight': 76.0,
          'height': 175.0,
          'cholesterol': 2.0,
          'gluc': 2.0,
          'smoke': 0.0,
          'alco': 0.0,
          'active': 1.0,
        },
      });

      expect(msg, isA<EvaluationComplete>());

      final complete = msg as EvaluationComplete;
      expect(complete.score, 66.14);
      expect(complete.level, 'alto');
      expect(complete.input['weight'], 76.0);
      expect(complete.input['ap_hi'], 130.0);
    });

    test('parsea error', () {
      final msg = WsMessage.fromJson({
        'type': 'error',
        'code': 'llm_unavailable',
        'message': 'No se pudo contactar con Ollama.',
      });

      expect(msg, isA<ErrorMessage>());

      final err = msg as ErrorMessage;
      expect(err.code, 'llm_unavailable');
      expect(err.message, 'No se pudo contactar con Ollama.');
    });

    test('parsea done', () {
      final msg = WsMessage.fromJson({'type': 'done'});
      expect(msg, isA<DoneMessage>());
    });

    test('parsea evaluation_error', () {
      final msg = WsMessage.fromJson({
        'type': 'evaluation_error',
        'field': 'peso',
        'message': 'El peso debe ser positivo.',
      });

      expect(msg, isA<EvaluationErrorMessage>());

      final err = msg as EvaluationErrorMessage;
      expect(err.field, 'peso');
      expect(err.message, 'El peso debe ser positivo.');
    });

    test('parsea evaluation_cancelled', () {
      final msg = WsMessage.fromJson({
        'type': 'evaluation_cancelled',
        'reason': 'user_request',
      });

      expect(msg, isA<EvaluationCancelled>());
      expect((msg as EvaluationCancelled).reason, 'user_request');
    });

    test('parsea tipo desconocido → UnknownMessage', () {
      final msg = WsMessage.fromJson({
        'type': 'tipo_que_no_existe',
        'foo': 'bar',
      });

      expect(msg, isA<UnknownMessage>());
      expect((msg as UnknownMessage).type, 'tipo_que_no_existe');
    });

    test('sin type → UnknownMessage', () {
      final msg = WsMessage.fromJson({'foo': 'bar'});
      expect(msg, isA<UnknownMessage>());
    });

    test('assistant_message sin content → content vacío', () {
      final msg = WsMessage.fromJson({'type': 'assistant_message'});

      expect(msg, isA<AssistantMessage>());
      expect((msg as AssistantMessage).content, '');
    });

    test('evaluation_complete sin result ni input → mapas vacíos', () {
      final msg = WsMessage.fromJson({'type': 'evaluation_complete'});

      final complete = msg as EvaluationComplete;
      expect(complete.result, isEmpty);
      expect(complete.input, isEmpty);
      expect(complete.score, 0.0);
      expect(complete.level, 'desconocido');
    });
  });
}
