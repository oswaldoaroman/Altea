import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:altea/features/chat_bot/controllers/chat_controller.dart';
import 'package:altea/features/chat_bot/models/chat_message.dart';
import 'package:altea/features/chat_bot/service/ollama_service.dart';

import '../service/fake_websocket.dart';

void main() {
  late FakeWebSocketChannel fakeChannel;
  late OllamaService service;
  late ChatController controller;

  setUp(() {
    fakeChannel = FakeWebSocketChannel();
    service = OllamaService(
      url: 'ws://fake',
      channelFactory: (_) => fakeChannel,
    );
    controller = ChatController(service: service);
  });

  tearDown(() async {
    controller.dispose();
  });

  // ==========================================================
  // ESTADO INICIAL
  // ==========================================================

  group('estado inicial', () {
    test('tiene mensaje de bienvenida', () {
      expect(controller.mensajes.length, 1);
      expect(controller.mensajes.first.esAsistente, true);
    });

    test('modo es chat', () {
      expect(controller.modo, ChatMode.chat);
    });

    test('cargando es false', () {
      expect(controller.cargando, false);
    });

    test('resultado es null', () {
      expect(controller.resultado, isNull);
    });
  });

  // ==========================================================
  // ENVIAR MENSAJE
  // ==========================================================

  group('enviarMensaje', () {
    test('no envía si está vacío', () async {
      await controller.inicializar();
      final antes = controller.mensajes.length;

      controller.enviarMensaje('   ');

      expect(controller.mensajes.length, antes);
    });

    test('no envía si no hay conexión', () {
      // No inicializamos.
      final antes = controller.mensajes.length;

      controller.enviarMensaje('hola');

      // Se añade un mensaje de error.
      expect(controller.mensajes.length, antes + 1);
      expect(controller.mensajes.last.esError, true);
    });

    test('añade mensaje de usuario y burbuja vacía de Altea', () async {
      await controller.inicializar();
      final antes = controller.mensajes.length;

      controller.enviarMensaje('hola');

      expect(controller.mensajes.length, antes + 2);
      expect(controller.mensajes[antes].esUsuario, true);
      expect(controller.mensajes[antes + 1].esAsistente, true);
      expect(controller.mensajes[antes + 1].estaVacio, true);
    });

    test('cargando es true tras enviar', () async {
      await controller.inicializar();

      controller.enviarMensaje('hola');

      expect(controller.cargando, true);
    });
  });

  // ==========================================================
  // MENSAJES DEL WS
  // ==========================================================

  group('assistant_message', () {
    test('rellena la burbuja vacía de Altea', () async {
      await controller.inicializar();

      controller.enviarMensaje('hola');
      final idx = controller.mensajes.length - 1;

      fakeChannel.emitirDesdeServidor({
        'type': 'assistant_message',
        'content': '¡Hola! ¿En qué te ayudo?',
      });

      await Future.delayed(Duration.zero);

      expect(controller.mensajes[idx].texto, '¡Hola! ¿En qué te ayudo?');
    });
  });

  group('done', () {
    test('cargando vuelve a false', () async {
      await controller.inicializar();

      controller.enviarMensaje('hola');
      expect(controller.cargando, true);

      fakeChannel.emitirDesdeServidor({'type': 'done'});

      await Future.delayed(Duration.zero);

      expect(controller.cargando, false);
    });
  });

  group('error', () {
    test('añade mensaje de error', () async {
      await controller.inicializar();

      fakeChannel.emitirDesdeServidor({
        'type': 'error',
        'code': 'llm_unavailable',
        'message': 'no disponible',
      });

      await Future.delayed(Duration.zero);

      expect(controller.mensajes.last.esError, true);
      expect(controller.cargando, false);
    });
  });

  // ==========================================================
  // EVALUACIÓN COMPLETA
  // ==========================================================

  group('evaluation_complete', () {
    test('cambia el modo a resultado', () async {
      await controller.inicializar();

      fakeChannel.emitirDesdeServidor({
        'type': 'evaluation_complete',
        'result': {'score': 66.14, 'level': 'alto'},
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

      await Future.delayed(Duration.zero);

      expect(controller.modo, ChatMode.resultado);
      expect(controller.resultado, isNotNull);
      expect(controller.resultado!.score, 66.14);
    });

    test('genera las recomendaciones correctamente', () async {
      await controller.inicializar();

      fakeChannel.emitirDesdeServidor({
        'type': 'evaluation_complete',
        'result': {'score': 66.14, 'level': 'alto'},
        'input': {
          'ap_hi': 130.0,
          'ap_lo': 85.0,
          'weight': 76.0,
          'height': 175.0,
          'cholesterol': 2.0,
          'gluc': 2.0,
          'smoke': 1.0,
          'alco': 0.0,
          'active': 1.0,
        },
      });

      await Future.delayed(Duration.zero);

      final rec = controller.resultado!.recomendaciones;
      // Al fumar=true, debe haber al menos un factor relacionado.
      expect(rec.factores.isNotEmpty, true);
    });

    test('volverAlChat cambia el modo a chat', () async {
      await controller.inicializar();

      fakeChannel.emitirDesdeServidor({
        'type': 'evaluation_complete',
        'result': {'score': 66.14, 'level': 'alto'},
        'input': {},
      });

      await Future.delayed(Duration.zero);
      expect(controller.modo, ChatMode.resultado);

      controller.volverAlChat();

      expect(controller.modo, ChatMode.chat);
      expect(controller.resultado, isNull);
    });
  });

  // ==========================================================
  // NOTIFICACIONES
  // ==========================================================

  group('notificaciones', () {
    test('notifyListeners se llama al enviar', () async {
      await controller.inicializar();

      var count = 0;
      controller.addListener(() => count++);

      controller.enviarMensaje('hola');

      expect(count, greaterThan(0));
    });

    test('notifyListeners se llama al recibir done', () async {
      await controller.inicializar();

      var count = 0;
      controller.addListener(() => count++);

      fakeChannel.emitirDesdeServidor({'type': 'done'});

      await Future.delayed(Duration.zero);

      expect(count, greaterThan(0));
    });
  });
}
