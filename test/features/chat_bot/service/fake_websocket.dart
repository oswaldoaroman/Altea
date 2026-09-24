import 'dart:async';
import 'dart:convert';

import 'package:stream_channel/stream_channel.dart';

/// Un `StreamChannel` de prueba que simula un WebSocket.
///
/// - Permite inspeccionar los mensajes que el servicio envía.
/// - Permite inyectar mensajes desde el "servidor".
/// - Permite simular errores y cierres.
///
/// No implementa `WebSocketChannel` porque esa clase no es
/// implementable fácilmente en `web_socket_channel` 3.x.
/// Extiende `StreamChannelMixin` que provee todas las
/// implementaciones por defecto.
class FakeWebSocketChannel extends StreamChannelMixin<dynamic> {
  final StreamController<dynamic> _incoming =
      StreamController<dynamic>.broadcast();

  final List<dynamic> enviados = [];

  bool cerrado = false;

  // ==========================================================
  // StreamChannel
  // ==========================================================

  @override
  Stream<dynamic> get stream => _incoming.stream;

  @override
  StreamSink<dynamic> get sink => _FakeSink(this);

  // ==========================================================
  // SIMULACIÓN DE SERVIDOR
  // ==========================================================

  /// Emite un mensaje JSON desde el servidor.
  void emitirDesdeServidor(Map<String, dynamic> json) {
    _incoming.add(jsonEncode(json));
  }

  /// Emite un string crudo (para simular JSON malformado).
  void emitirRaw(String raw) {
    _incoming.add(raw);
  }

  /// Emite un error de conexión.
  void emitirError(Object error) {
    _incoming.addError(error);
  }

  /// Simula el cierre del canal.
  void emitirCierre() {
    _incoming.close();
  }

  // ==========================================================
  // INTERNOS
  // ==========================================================

  void registrarEnvio(dynamic mensaje) {
    enviados.add(mensaje);
  }

  void cerrar() {
    if (cerrado) return;
    cerrado = true;
    _incoming.close();
  }
}

class _FakeSink implements StreamSink<dynamic> {
  final FakeWebSocketChannel _parent;

  _FakeSink(this._parent);

  @override
  void add(dynamic data) {
    _parent.registrarEnvio(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    // Ignorar.
  }

  @override
  Future<void> addStream(Stream<dynamic> stream) async {
    // Ignorar.
  }

  @override
  Future<void> close() async {
    _parent.cerrar();
  }

  @override
  Future<void> get done => Future.value();
}
