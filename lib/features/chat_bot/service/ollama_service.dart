import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

// ==========================================================
// EXCEPCIÓN PERSONALIZADA
// ==========================================================

class OllamaException implements Exception {
  final String mensaje;

  OllamaException(this.mensaje);

  @override
  String toString() => mensaje;
}

class OllamaService {
  static const String _wsUrl = 'ws://127.0.0.1:8000/ollama/ws';

  // ==========================================================
  // WEBSOCKET
  // ==========================================================

  static WebSocketChannel conectarWebSocket() {
    try {
      final uri = Uri.parse(_wsUrl);

      return WebSocketChannel.connect(uri);
    } catch (e) {
      throw OllamaException('No se pudo conectar con el servidor de Altea.');
    }
  }

  // ==========================================================
  // ENVIAR PROMPT
  // ==========================================================

  static void enviarPrompt(WebSocketChannel channel, String prompt) {
    try {
      if (prompt.trim().isEmpty) {
        throw OllamaException('El prompt no puede estar vacío.');
      }

      channel.sink.add(jsonEncode({'prompt': prompt}));
    } catch (e) {
      if (e is OllamaException) {
        rethrow;
      }

      throw OllamaException('No se pudo enviar el mensaje a Altea.');
    }
  }

  // ==========================================================
  // CERRAR CONEXIÓN
  // ==========================================================

  static Future<void> cerrarWebSocket(WebSocketChannel channel) async {
    try {
      await channel.sink.close();
    } catch (e) {
      throw OllamaException('No se pudo cerrar la conexión con Altea.');
    }
  }
}
