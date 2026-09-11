import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class OllamaException implements Exception {
  final String mensaje;

  OllamaException(this.mensaje);

  @override
  String toString() => mensaje;
}

class OllamaService {
  static const String _wsUrl = 'ws://127.0.0.1:8000/ollama/ws';

  // ==========================================================
  // CONECTAR
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
  // ENVIAR MENSAJE
  // ==========================================================

  static void enviarMensaje(WebSocketChannel channel, String contenido) {
    if (contenido.trim().isEmpty) {
      throw OllamaException('El mensaje no puede estar vacío.');
    }

    channel.sink.add(jsonEncode({'type': 'message', 'content': contenido}));
  }

  // ==========================================================
  // CERRAR
  // ==========================================================

  static Future<void> cerrarWebSocket(WebSocketChannel channel) async {
    try {
      await channel.sink.close();
    } catch (e) {
      throw OllamaException('No se pudo cerrar la conexión con Altea.');
    }
  }
}
