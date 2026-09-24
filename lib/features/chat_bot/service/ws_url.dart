import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Devuelve la URL por defecto del WebSocket según la plataforma.
///
/// En Android emulador, `127.0.0.1` apunta al propio emulador, no al
/// host. El alias `10.0.2.2` apunta al host.
///
/// En iOS simulador, web y desktop, `127.0.0.1` funciona directamente.
///
/// En dispositivo físico, hay que sustituir por la IP del PC.
String defaultWsUrl() {
  const port = 8000;
  const path = '/ollama/ws';

  if (kIsWeb) {
    return 'ws://127.0.0.1:$port$path';
  }

  if (Platform.isAndroid) {
    return 'ws://10.0.2.2:$port$path';
  }

  return 'ws://127.0.0.1:$port$path';
}
