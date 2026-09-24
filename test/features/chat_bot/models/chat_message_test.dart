import 'package:flutter_test/flutter_test.dart';

import 'package:altea/features/chat_bot/models/chat_message.dart';

void main() {
  group('ChatMessage', () {
    test('crea mensaje de usuario', () {
      final msg = ChatMessage.user('hola');
      expect(msg.role, ChatMessageRole.user);
      expect(msg.esUsuario, true);
      expect(msg.esAsistente, false);
      expect(msg.texto, 'hola');
    });

    test('crea mensaje de asistente', () {
      final msg = ChatMessage.assistant('hola');
      expect(msg.role, ChatMessageRole.assistant);
      expect(msg.esAsistente, true);
      expect(msg.texto, 'hola');
    });

    test('crea mensaje de error', () {
      final msg = ChatMessage.error('ups');
      expect(msg.role, ChatMessageRole.error);
      expect(msg.esError, true);
      expect(msg.texto, 'ups');
    });

    test('copyWith cambia solo el texto', () {
      final msg = ChatMessage.user('hola');
      final copia = msg.copyWith(texto: 'adiós');

      expect(copia.texto, 'adiós');
      expect(copia.role, msg.role);
      expect(copia.timestamp, msg.timestamp);
    });

    test('estaVacio detecta texto vacío', () {
      expect(ChatMessage.assistant('').estaVacio, true);
      expect(ChatMessage.assistant('algo').estaVacio, false);
    });
  });
}
