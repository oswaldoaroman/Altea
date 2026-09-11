import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';
import 'package:altea/features/chat_bot/service/ollama_service.dart';
import 'package:altea/features/chat_bot/models/evaluation_state.dart';

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
  // EVALUACIÓN
  // ==========================================================

  final EvaluationState _evaluation = EvaluationState();

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
  // CONECTAR
  // ==========================================================

  void _conectarWebSocket() {
    if (_channel != null) {
      return;
    }

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
    if (!mounted) {
      return;
    }

    try {
      final mensaje = jsonDecode(data.toString());

      if (mensaje is! Map<String, dynamic>) {
        debugPrint('Mensaje WebSocket inválido.');

        return;
      }

      final tipo = mensaje['type'];

      switch (tipo) {
        // ====================================================
        // CHUNK
        // ====================================================

        case 'chunk':
          _procesarChunk(mensaje);
          break;

        // ====================================================
        // EVALUATION START
        // ====================================================

        case 'evaluation_start':
          _procesarEvaluationStart();
          break;

        // ====================================================
        // EVALUATION DATA
        // ====================================================

        case 'evaluation_data':
          _procesarEvaluationData(mensaje);
          break;

        // ====================================================
        // EVALUATION COMPLETE
        // ====================================================

        case 'evaluation_complete':
          _procesarEvaluationComplete(mensaje);
          break;

        // ====================================================
        // DONE
        // ====================================================

        case 'done':
          _procesarDone();
          break;

        // ====================================================
        // ERROR
        // ====================================================

        case 'error':
          _procesarError(mensaje);
          break;

        default:
          debugPrint('Tipo de mensaje desconocido: $tipo');
      }
    } catch (e) {
      debugPrint('Error procesando mensaje WebSocket: $e');
    }
  }

  // ==========================================================
  // CHUNK
  // ==========================================================

  void _procesarChunk(Map<String, dynamic> mensaje) {
    final contenido = mensaje['content']?.toString() ?? '';

    if (contenido.isEmpty) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      if (_mensajes.isNotEmpty && !_mensajes.last.esUsuario) {
        _mensajes.last.texto += contenido;
      } else {
        _mensajes.add(_Msg(contenido, false));
      }
    });
  }

  // ==========================================================
  // EVALUATION START
  // ==========================================================

  void _procesarEvaluationStart() {
    debugPrint('Altea inició una evaluación.');

    _evaluation.iniciar();

    debugPrint(
      'Estado inicial: '
      '${_evaluation.toJson()}',
    );
  }

  // ==========================================================
  // EVALUATION DATA
  // ==========================================================

  void _procesarEvaluationData(Map<String, dynamic> mensaje) {
    final field = mensaje['field']?.toString();

    final value = mensaje['value'];

    if (field == null || field.isEmpty) {
      debugPrint('evaluation_data sin field.');

      return;
    }

    debugPrint(
      'Dato recibido: '
      '$field = $value',
    );

    final valido = _evaluation.asignarDato(field, value);

    if (valido == false) {
      debugPrint(
        'No se pudo guardar el dato: '
        '$field = $value',
      );

      return;
    }

    debugPrint(
      'Estado evaluación: '
      '${_evaluation.toJson()}',
    );
  }

  // ==========================================================
  // EVALUATION COMPLETE
  // ==========================================================

  void _procesarEvaluationComplete(Map<String, dynamic> mensaje) {
    debugPrint('Servidor indicó que la evaluación terminó.');

    debugPrint(
      'Datos locales: '
      '${_evaluation.toJson()}',
    );

    if (!_evaluation.completa) {
      debugPrint('La evaluación está incompleta.');

      _mostrarMensajeAltea(
        'Todavía me faltan algunos datos para '
        'poder completar tu evaluación.',
      );

      return;
    }

    _ejecutarDecisionTree();
  }

  // ==========================================================
  // EJECUTAR DECISION TREE
  // ==========================================================

  void _ejecutarDecisionTree() {
    if (!_evaluation.completa) {
      debugPrint('No se puede ejecutar el Decision Tree.');

      return;
    }

    debugPrint('========================================');

    debugPrint('EJECUTANDO DECISION TREE LOCAL');

    debugPrint('========================================');

    debugPrint('Datos: ${_evaluation.toJson()}');

    /*
     * AQUÍ conectaremos tu EvaluationService REAL.
     *
     * Ejemplo conceptual:
     *
     * final resultado =
     *     EvaluacionService.evaluar(
     *       age: edadUsuario,
     *       weight: _evaluation.peso!,
     *       height: _evaluation.altura!,
     *       cholesterol: _evaluation.colesterol!,
     *       gluc: _evaluation.glucosa!,
     *       smoke: _evaluation.fuma!,
     *       alco: _evaluation.consumeAlcohol!,
     *       active: _evaluation.actividadFisica!,
     *       apHi: _evaluation.presionSistolica,
     *       apLo: _evaluation.presionDiastolica,
     *     );
     *
     * Después navegaremos a ResultScreen.
     */

    _mostrarMensajeAltea(
      'He recopilado todos tus datos. '
      'Ahora voy a calcular tu evaluación.',
    );
  }

  // ==========================================================
  // DONE
  // ==========================================================

  void _procesarDone() {
    debugPrint('Respuesta de Altea terminada.');

    if (!mounted) {
      return;
    }

    setState(() {
      _cargando = false;
    });
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  void _procesarError(Map<String, dynamic> mensaje) {
    final error = mensaje['message']?.toString() ?? 'Error desconocido.';

    debugPrint('Error del servidor: $error');

    _manejarError(OllamaException(error));
  }

  // ==========================================================
  // MOSTRAR MENSAJE DE ALTEA
  // ==========================================================

  void _mostrarMensajeAltea(String texto) {
    if (!mounted) {
      return;
    }

    setState(() {
      _mensajes.add(_Msg(texto, false));
    });
  }

  // ==========================================================
  // ENVIAR
  // ==========================================================

  void _enviar() {
    final texto = _controller.text.trim();

    if (texto.isEmpty || _cargando) {
      return;
    }

    try {
      _conectarWebSocket();

      if (_channel == null) {
        throw OllamaException('No se pudo conectar con el servidor de Altea.');
      }

      setState(() {
        _mensajes.add(_Msg(texto, true));

        _mensajes.add(_Msg('', false));

        _controller.clear();

        _cargando = true;
      });

      OllamaService.enviarMensaje(_channel!, texto);
    } on OllamaException catch (e) {
      debugPrint('Error de Altea: ${e.mensaje}');

      if (!mounted) {
        return;
      }

      setState(() {
        _cargando = false;

        _mensajes.add(_Msg(e.mensaje, false));
      });
    } catch (e) {
      debugPrint('Error inesperado: $e');

      if (!mounted) {
        return;
      }

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

    if (!mounted) {
      return;
    }

    final mensaje = error is OllamaException
        ? error.mensaje
        : 'Se perdió la conexión con el servidor de Altea.';

    setState(() {
      _cargando = false;

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

    if (!mounted) {
      return;
    }

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
