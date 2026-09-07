import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';
import 'package:altea/features/chat_bot/service/ollama_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _Msg {
  String texto;
  final bool esUsuario;

  _Msg(this.texto, this.esUsuario);
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  // ==========================================================
  // MENSAJES
  // ==========================================================

  final List<_Msg> _mensajes = [
    _Msg('Hola Isela, soy Altea. ¿Cómo te sientes hoy?', false),
  ];

  // ==========================================================
  // WEBSOCKET
  // ==========================================================

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  bool _cargando = false;

  // ==========================================================
  // CONECTAR WEBSOCKET
  // ==========================================================

  void _conectarWebSocket() {
    if (_channel != null) return;

    try {
      _channel = OllamaService.conectarWebSocket();

      _subscription = _channel!.stream.listen(
        _recibirMensaje,
        onError: _manejarError,
        onDone: _conexionTerminada,
        cancelOnError: false,
      );

      debugPrint('WebSocket conectado.');
    } on OllamaException catch (e) {
      debugPrint('Error de Altea: ${e.mensaje}');
      rethrow;
    } catch (e) {
      debugPrint('Error conectando WebSocket: $e');

      throw OllamaException('No se pudo conectar con el servidor de Altea.');
    }
  }

  // ==========================================================
  // RECIBIR MENSAJE
  // ==========================================================

  void _recibirMensaje(dynamic data) {
    if (!mounted) return;

    try {
      final mensaje = jsonDecode(data.toString());

      final tipo = mensaje['type'];

      // --------------------------------------------------------
      // CHUNK
      // --------------------------------------------------------

      if (tipo == 'chunk') {
        final contenido = mensaje['content']?.toString() ?? '';

        if (contenido.isEmpty) return;

        setState(() {
          if (_mensajes.isNotEmpty && !_mensajes.last.esUsuario) {
            _mensajes.last.texto += contenido;
          }
        });
      }
      // --------------------------------------------------------
      // DONE
      // --------------------------------------------------------
      else if (tipo == 'done') {
        setState(() {
          _cargando = false;
        });

        debugPrint('Respuesta de Altea terminada.');
      }
      // --------------------------------------------------------
      // ERROR
      // --------------------------------------------------------
      else if (tipo == 'error') {
        final error = mensaje['message']?.toString() ?? 'Error desconocido.';

        debugPrint('Error del servidor: $error');

        _manejarError(OllamaException(error));
      }
    } catch (e) {
      debugPrint('Error procesando mensaje WebSocket: $e');
    }
  }

  // ==========================================================
  // ENVIAR MENSAJE
  // ==========================================================

  void _enviar() {
    final texto = _controller.text.trim();

    if (texto.isEmpty || _cargando) return;

    try {
      // --------------------------------------------------------
      // Conectar si todavía no existe conexión
      // --------------------------------------------------------

      _conectarWebSocket();

      if (_channel == null) {
        throw OllamaException('No se pudo conectar con el servidor de Altea.');
      }

      // --------------------------------------------------------
      // Agregar mensaje del usuario
      // --------------------------------------------------------

      setState(() {
        _mensajes.add(_Msg(texto, true));

        // Crear mensaje vacío de Altea.
        // Los chunks se agregarán aquí.
        _mensajes.add(_Msg('', false));

        _controller.clear();

        _cargando = true;
      });

      // --------------------------------------------------------
      // Construir historial
      // --------------------------------------------------------

      final historial = _mensajes
          .where((mensaje) => mensaje.texto.isNotEmpty)
          .map(
            (mensaje) =>
                '${mensaje.esUsuario ? "Usuario" : "Altea"}: '
                '${mensaje.texto}',
          )
          .join('\n');

      // --------------------------------------------------------
      // Prompt
      // --------------------------------------------------------

      final prompt =
          '''
Esta es la conversación actual:

$historial

Responde al último mensaje del usuario de forma natural y clara.
''';

      // --------------------------------------------------------
      // Enviar prompt
      // --------------------------------------------------------

      OllamaService.enviarPrompt(_channel!, prompt);
    } on OllamaException catch (e) {
      debugPrint('Error de Altea: ${e.mensaje}');

      if (!mounted) return;

      setState(() {
        _cargando = false;

        _mensajes.add(_Msg(e.mensaje, false));
      });
    } catch (e) {
      debugPrint('Error inesperado: $e');

      if (!mounted) return;

      setState(() {
        _cargando = false;

        _mensajes.add(_Msg('Ocurrió un error inesperado.', false));
      });
    }
  }

  // ==========================================================
  // ERROR WEBSOCKET
  // ==========================================================

  void _manejarError(dynamic error) {
    debugPrint('Error WebSocket: $error');

    if (!mounted) return;

    final mensaje = error is OllamaException
        ? error.mensaje
        : 'Se perdió la conexión con el servidor de Altea.';

    setState(() {
      _cargando = false;

      // Si existe una burbuja vacía de Altea,
      // mostrar ahí el error.
      if (_mensajes.isNotEmpty &&
          !_mensajes.last.esUsuario &&
          _mensajes.last.texto.isEmpty) {
        _mensajes.last.texto = mensaje;
      } else {
        _mensajes.add(_Msg(mensaje, false));
      }
    });
  }

  // ==========================================================
  // CONEXIÓN TERMINADA
  // ==========================================================

  void _conexionTerminada() {
    debugPrint('WebSocket desconectado.');

    _channel = null;
    _subscription = null;

    if (!mounted) return;

    if (_cargando) {
      setState(() {
        _cargando = false;

        if (_mensajes.isNotEmpty &&
            !_mensajes.last.esUsuario &&
            _mensajes.last.texto.isEmpty) {
          _mensajes.last.texto =
              'Se perdió la conexión con el servidor de Altea.';
        }
      });
    }
  }

  // ==========================================================
  // CERRAR WEBSOCKET
  // ==========================================================

  Future<void> _cerrarWebSocket() async {
    try {
      await _subscription?.cancel();

      _subscription = null;

      if (_channel != null) {
        await OllamaService.cerrarWebSocket(_channel!);
      }

      _channel = null;
    } catch (e) {
      debugPrint('Error cerrando WebSocket: $e');
    }
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _controller.dispose();

    _cerrarWebSocket();

    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopTitle(
              title: 'Chat con Altea',
              subtitle: 'Asistente de salud',
            ),

            // ==================================================
            // MENSAJES
            // ==================================================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                itemCount: _mensajes.length,
                itemBuilder: (context, i) {
                  final m = _mensajes[i];

                  return Align(
                    alignment: m.esUsuario
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 260),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: m.esUsuario ? AppColors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: m.esUsuario
                            ? null
                            : [
                                BoxShadow(
                                  color: AppColors.ink.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                      ),
                      child: m.texto.isEmpty
                          ? const SizedBox(
                              width: 35,
                              height: 20,
                              child: Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              m.texto,
                              style: TextStyle(
                                color: m.esUsuario
                                    ? Colors.white
                                    : AppColors.ink,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),

            // ==================================================
            // INPUT
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_cargando,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _enviar(),
                      decoration: InputDecoration(
                        hintText: _cargando
                            ? 'Altea está escribiendo...'
                            : 'Escribe tu pregunta...',
                        filled: true,
                        fillColor: AppColors.sky,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  CircleAvatar(
                    backgroundColor: _cargando ? Colors.grey : AppColors.blue,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: _cargando ? null : _enviar,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
