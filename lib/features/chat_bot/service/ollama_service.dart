import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/ws_message.dart';
import 'ws_url.dart';

// ==========================================================
// EXCEPCIÓN
// ==========================================================

class OllamaException implements Exception {
  final String mensaje;

  OllamaException(this.mensaje);

  @override
  String toString() => mensaje;
}

// ==========================================================
// ESTADO DE CONEXIÓN
// ==========================================================

enum ConnectionState { disconnected, connecting, connected, error }

// ==========================================================
// SERVICIO
// ==========================================================

/// Cliente WebSocket para el chatbot de Altea.
class OllamaService {
  final String _url;
  final StreamChannel<dynamic> Function(Uri)? _channelFactory;

  StreamChannel<dynamic>? _channel;
  StreamSubscription? _subscription;

  final StreamController<WsMessage> _messagesController =
      StreamController<WsMessage>.broadcast();

  final StreamController<ConnectionState> _connectionStateController =
      StreamController<ConnectionState>.broadcast();

  ConnectionState _state = ConnectionState.disconnected;

  OllamaService({
    String? url,
    StreamChannel<dynamic> Function(Uri)? channelFactory,
  }) : _url = url ?? defaultWsUrl(),
       _channelFactory = channelFactory;

  // ==========================================================
  // API PÚBLICA
  // ==========================================================

  Stream<WsMessage> get messages => _messagesController.stream;

  Stream<ConnectionState> get connectionState =>
      _connectionStateController.stream;

  ConnectionState get state => _state;

  bool get isConnected => _state == ConnectionState.connected;

  // ==========================================================
  // CONECTAR
  // ==========================================================

  Future<void> connect({String? userId}) async {
    if (_state == ConnectionState.connecting ||
        _state == ConnectionState.connected) {
      return;
    }

    _setState(ConnectionState.connecting);

    debugPrint('═══════════════════════════════════════');
    debugPrint('OllamaService: intentando conectar a $_url');
    debugPrint('═══════════════════════════════════════');

    try {
      final uri = Uri.parse(_url);

      if (_channelFactory != null) {
        _channel = _channelFactory!(uri);
      } else {
        _channel = WebSocketChannel.connect(uri);
      }

      _subscription = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _setState(ConnectionState.connected);

      sendSessionInit(userId: userId);
    } catch (e) {
      _setState(ConnectionState.error);
      _messagesController.add(
        ErrorMessage(
          code: 'connection_error',
          message: 'No se pudo conectar con el servidor de Altea.',
        ),
      );
    }
  }

  // ==========================================================
  // DESCONECTAR
  // ==========================================================

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;

    try {
      await _channel?.sink.close();
    } catch (_) {
      // Ignorar.
    }

    _channel = null;
    _setState(ConnectionState.disconnected);
  }

  // ==========================================================
  // ENVIAR
  // ==========================================================

  void sendChat(String content) {
    final texto = content.trim();
    if (texto.isEmpty) return;

    _send({'type': 'chat', 'content': texto});
  }

  void sendStartEvaluation() {
    _send({'type': 'start_evaluation'});
  }

  void sendSessionInit({String? userId}) {
    _send({'type': 'session_init', 'user_id': userId});
  }

  // ==========================================================
  // LIBERAR
  // ==========================================================

  Future<void> dispose() async {
    await disconnect();
    await _messagesController.close();
    await _connectionStateController.close();
  }

  // ==========================================================
  // INTERNOS
  // ==========================================================

  void _send(Map<String, dynamic> payload) {
    if (_channel == null || _state != ConnectionState.connected) {
      _messagesController.add(
        ErrorMessage(
          code: 'not_connected',
          message: 'No hay conexión con el servidor de Altea.',
        ),
      );
      return;
    }

    try {
      _channel!.sink.add(jsonEncode(payload));
    } catch (e) {
      _messagesController.add(
        ErrorMessage(
          code: 'send_error',
          message: 'No se pudo enviar el mensaje al servidor.',
        ),
      );
    }
  }

  void _onData(dynamic data) {
    if (data is! String) return;

    Map<String, dynamic> json;
    try {
      final decoded = jsonDecode(data);
      if (decoded is! Map<String, dynamic>) return;
      json = decoded;
    } catch (_) {
      _messagesController.add(
        const UnknownMessage(type: 'invalid_json', raw: {}),
      );
      return;
    }

    final msg = WsMessage.fromJson(json);
    _messagesController.add(msg);
  }

  void _onError(dynamic error) {
    _setState(ConnectionState.error);
    _messagesController.add(
      ErrorMessage(
        code: 'connection_error',
        message: 'Se perdió la conexión con el servidor de Altea.',
      ),
    );
  }

  void _onDone() {
    _setState(ConnectionState.disconnected);
  }

  void _setState(ConnectionState newState) {
    if (_state == newState) return;
    _state = newState;
    _connectionStateController.add(newState);
  }
}
