import 'package:flutter_test/flutter_test.dart';

import 'package:altea/features/chat_bot/models/ws_message.dart';
import 'package:altea/features/chat_bot/service/ollama_service.dart';

import 'fake_websocket.dart';

void main() {
  late FakeWebSocketChannel fakeChannel;
  late OllamaService service;

  setUp(() {
    fakeChannel = FakeWebSocketChannel();
    service = OllamaService(
      url: 'ws://fake',
      channelFactory: (_) => fakeChannel,
    );
  });

  tearDown(() async {
    await service.dispose();
  });

  // ==========================================================
  // CONEXIÓN
  // ==========================================================

  group('conexión', () {
    test('connect cambia el estado a connected', () async {
      await service.connect();
      expect(service.isConnected, true);
    });

    test('al conectar envía session_init', () async {
      await service.connect();

      expect(fakeChannel.enviados.length, 1);

      final enviado = fakeChannel.enviados.first as String;
      expect(enviado.contains('"type":"session_init"'), true);
      expect(enviado.contains('"user_id":null'), true);
    });

    test('session_init con user_id', () async {
      await service.connect(userId: 'abc');

      final enviado = fakeChannel.enviados.first as String;
      expect(enviado.contains('"user_id":"abc"'), true);
    });

    test('disconnect cambia el estado', () async {
      await service.connect();
      expect(service.isConnected, true);

      await service.disconnect();
      expect(service.isConnected, false);
    });

    test('no se reconecta si ya está conectado', () async {
      await service.connect();
      fakeChannel.enviados.clear();

      await service.connect();

      // No debe haber enviado otro session_init.
      expect(fakeChannel.enviados.length, 0);
    });
  });

  // ==========================================================
  // ENVÍO
  // ==========================================================

  group('envío', () {
    test('sendChat envía el mensaje correcto', () async {
      await service.connect();
      fakeChannel.enviados.clear();

      service.sendChat('hola');

      expect(fakeChannel.enviados.length, 1);

      final enviado = fakeChannel.enviados.first as String;
      expect(enviado.contains('"type":"chat"'), true);
      expect(enviado.contains('"content":"hola"'), true);
    });

    test('sendChat con texto vacío no envía nada', () async {
      await service.connect();
      fakeChannel.enviados.clear();

      service.sendChat('   ');

      expect(fakeChannel.enviados.length, 0);
    });

    test('sendStartEvaluation envía el mensaje correcto', () async {
      await service.connect();
      fakeChannel.enviados.clear();

      service.sendStartEvaluation();

      expect(fakeChannel.enviados.length, 1);

      final enviado = fakeChannel.enviados.first as String;
      expect(enviado.contains('"type":"start_evaluation"'), true);
    });

    test('sendChat sin conexión emite ErrorMessage', () async {
      final recibidos = <WsMessage>[];
      service.messages.listen(recibidos.add);

      service.sendChat('hola');

      await Future.delayed(Duration.zero);

      expect(recibidos.length, 1);
      expect(recibidos.first, isA<ErrorMessage>());
      expect((recibidos.first as ErrorMessage).code, 'not_connected');
    });
  });

  // ==========================================================
  // RECEPCIÓN
  // ==========================================================

  group('recepción', () {
    test('recibe y parsea assistant_message', () async {
      await service.connect();

      final recibidos = <WsMessage>[];
      service.messages.listen(recibidos.add);

      fakeChannel.emitirDesdeServidor({
        'type': 'assistant_message',
        'content': 'hola',
      });

      await Future.delayed(Duration.zero);

      expect(recibidos.length, 1);
      expect(recibidos.first, isA<AssistantMessage>());
      expect((recibidos.first as AssistantMessage).content, 'hola');
    });

    test('recibe y parsea evaluation_data', () async {
      await service.connect();

      final recibidos = <WsMessage>[];
      service.messages.listen(recibidos.add);

      fakeChannel.emitirDesdeServidor({
        'type': 'evaluation_data',
        'field': 'peso',
        'value': 76.0,
        'progress': 1,
        'total': 10,
      });

      await Future.delayed(Duration.zero);

      expect(recibidos.length, 1);
      expect(recibidos.first, isA<EvaluationData>());
      expect((recibidos.first as EvaluationData).field, 'peso');
    });

    test('recibe y parsea evaluation_complete', () async {
      await service.connect();

      final recibidos = <WsMessage>[];
      service.messages.listen(recibidos.add);

      fakeChannel.emitirDesdeServidor({
        'type': 'evaluation_complete',
        'result': {'score': 66.14, 'level': 'alto'},
        'input': {'weight': 76.0},
      });

      await Future.delayed(Duration.zero);

      expect(recibidos.length, 1);
      expect(recibidos.first, isA<EvaluationComplete>());

      final complete = recibidos.first as EvaluationComplete;
      expect(complete.score, 66.14);
      expect(complete.level, 'alto');
      expect(complete.input['weight'], 76.0);
    });

    test('recibe y parsea error', () async {
      await service.connect();

      final recibidos = <WsMessage>[];
      service.messages.listen(recibidos.add);

      fakeChannel.emitirDesdeServidor({
        'type': 'error',
        'code': 'llm_unavailable',
        'message': 'no disponible',
      });

      await Future.delayed(Duration.zero);

      expect(recibidos.length, 1);
      expect(recibidos.first, isA<ErrorMessage>());
    });

    test('recibe y parsea done', () async {
      await service.connect();

      final recibidos = <WsMessage>[];
      service.messages.listen(recibidos.add);

      fakeChannel.emitirDesdeServidor({'type': 'done'});

      await Future.delayed(Duration.zero);

      expect(recibidos.length, 1);
      expect(recibidos.first, isA<DoneMessage>());
    });

    test('JSON malformado → UnknownMessage', () async {
      await service.connect();

      final recibidos = <WsMessage>[];
      service.messages.listen(recibidos.add);

      fakeChannel.emitirRaw('no es json');

      await Future.delayed(Duration.zero);

      expect(recibidos.length, 1);
      expect(recibidos.first, isA<UnknownMessage>());
    });

    test('tipo desconocido → UnknownMessage', () async {
      await service.connect();

      final recibidos = <WsMessage>[];
      service.messages.listen(recibidos.add);

      fakeChannel.emitirDesdeServidor({'type': 'tipo_que_no_existe'});

      await Future.delayed(Duration.zero);

      expect(recibidos.length, 1);
      expect(recibidos.first, isA<UnknownMessage>());
    });
  });

  // ==========================================================
  // ERRORES
  // ==========================================================

  group('errores', () {
    test('error del canal emite ErrorMessage', () async {
      await service.connect();

      final recibidos = <WsMessage>[];
      service.messages.listen(recibidos.add);

      fakeChannel.emitirError(Exception('boom'));

      await Future.delayed(Duration.zero);

      expect(recibidos.length, 1);
      expect(recibidos.first, isA<ErrorMessage>());
      expect((recibidos.first as ErrorMessage).code, 'connection_error');
    });

    test('cierre del canal cambia el estado', () async {
      await service.connect();
      expect(service.isConnected, true);

      fakeChannel.emitirCierre();

      await Future.delayed(Duration.zero);

      expect(service.isConnected, false);
    });
  });
}
