import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

// ==========================================================
// CONFIGURACIÓN
// ==========================================================

/// Nombre MagicDNS del servidor Altea en Tailscale.
///
/// Se usa por defecto cuando no hay `--dart-define=WS_URL=...`.
///
/// Para cambiarlo:
/// - Renombra la máquina en el admin console de Tailscale, y
/// - Actualiza esta constante.
const String _tailscaleHost = 'archlinux.tail9963d9.ts.net';

/// Puerto del backend FastAPI.
const int _port = 8000;

/// Path del WebSocket.
const String _path = '/ollama/ws';

// ==========================================================
// API PÚBLICA
// ==========================================================

/// Devuelve la URL del WebSocket a usar.
///
/// Prioridad:
/// 1. `--dart-define=WS_URL=...` (override total).
/// 2. `--dart-define=WS_HOST=...` (override solo del host).
/// 3. Por plataforma:
///    - Web: `127.0.0.1` (desarrollo).
///    - Android: MagicDNS de Tailscale.
///    - iOS/desktop: `127.0.0.1` (desarrollo).
String defaultWsUrl() {
  // ------------------------------------------------------
  // 1. Override total
  // ------------------------------------------------------

  const fullOverride = String.fromEnvironment('WS_URL');
  if (fullOverride.isNotEmpty) {
    return fullOverride;
  }

  // ------------------------------------------------------
  // 2. Override solo del host
  // ------------------------------------------------------

  const hostOverride = String.fromEnvironment('WS_HOST');
  final host = hostOverride.isNotEmpty ? hostOverride : _tailscaleHost;

  // ------------------------------------------------------
  // 3. Por plataforma
  // ------------------------------------------------------

  if (kIsWeb) {
    return 'ws://127.0.0.1:$_port$_path';
  }

  if (Platform.isAndroid) {
    return 'ws://$host:$_port$_path';
  }

  // iOS, macOS, Linux, Windows: por defecto local.
  return 'ws://127.0.0.1:$_port$_path';
}
