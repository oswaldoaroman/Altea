import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:altea/features/evaluation/models/recommendation_model.dart';
import 'package:altea/features/evaluation/service/recommendation_service.dart';

import '../models/chat_message.dart';
import '../models/ws_message.dart';
import '../service/ollama_service.dart';

// ==========================================================
// MODOS DE LA PANTALLA
// ==========================================================

enum ChatMode { chat, resultado }

// ==========================================================
// RESULTADO DE EVALUACIÓN
// ==========================================================

class EvaluationOutcome {
  final double score;
  final RecommendationResult recomendaciones;

  const EvaluationOutcome({required this.score, required this.recomendaciones});
}

// ==========================================================
// CONTROLLER
// ==========================================================

/// Controlador del flujo del chat.
///
/// Responsabilidades:
/// - Mantener el estado de la conversación (mensajes, cargando).
/// - Consumir el `Stream<WsMessage>` del `OllamaService`.
/// - Convertir `WsMessage` a `ChatMessage` para la UI.
/// - Al recibir `evaluation_complete`, generar las recomendaciones
///   y cambiar el modo a `resultado`.
/// - Exponer acciones para que la UI envíe mensajes al backend.
///
/// NO conoce WebSocket. NO conoce la UI. Solo orquesta.
class ChatController extends ChangeNotifier {
  final OllamaService _service;
  StreamSubscription<WsMessage>? _subscription;

  // ==========================================================
  // ESTADO
  // ==========================================================

  final List<ChatMessage> _mensajes = [];

  bool _cargando = false;
  ChatMode _modo = ChatMode.chat;
  EvaluationOutcome? _resultado;
  bool _disposed = false;

  // ==========================================================
  // CONSTRUCTOR
  // ==========================================================

  ChatController({OllamaService? service})
    : _service = service ?? OllamaService() {
    // Añadir mensaje de bienvenida.
    _mensajes.add(
      ChatMessage.assistant('Hola, soy Altea. ¿En qué puedo ayudarte?'),
    );
  }

  // ==========================================================
  // GETTERS
  // ==========================================================

  List<ChatMessage> get mensajes => List.unmodifiable(_mensajes);

  bool get cargando => _cargando;

  ChatMode get modo => _modo;

  EvaluationOutcome? get resultado => _resultado;

  bool get conectado => _service.isConnected;

  // ==========================================================
  // CICLO DE VIDA
  // ==========================================================

  /// Conecta el WebSocket y empieza a escuchar mensajes.
  Future<void> inicializar() async {
    if (_disposed) return;

    _subscription = _service.messages.listen(_onWsMessage);

    try {
      await _service.connect();
    } catch (e) {
      _agregarError('No se pudo conectar con el servidor.');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    _service.dispose();
    super.dispose();
  }

  // ==========================================================
  // ACCIONES PÚBLICAS
  // ==========================================================

  /// Envía un mensaje de chat.
  void enviarMensaje(String texto) {
    final limpio = texto.trim();
    if (limpio.isEmpty || _cargando) return;

    if (!_service.isConnected) {
      _agregarError('Sin conexión con el servidor.');
      return;
    }

    _mensajes.add(ChatMessage.user(limpio));
    _cargando = true;

    // Añadir burbuja vacía de Altea para ir rellenando con chunks.
    _mensajes.add(ChatMessage.assistant(''));

    _notificar();

    _service.sendChat(limpio);
  }

  /// Pide iniciar la evaluación.
  void iniciarEvaluacion() {
    if (_cargando) return;

    if (!_service.isConnected) {
      _agregarError('Sin conexión con el servidor.');
      return;
    }

    _cargando = true;
    _notificar();

    _service.sendStartEvaluation();
  }

  /// Vuelve del modo resultado al modo chat.
  void volverAlChat() {
    _modo = ChatMode.chat;
    _resultado = null;
    _notificar();
  }

  // ==========================================================
  // MANEJO DE MENSAJES DEL WS
  // ==========================================================

  void _onWsMessage(WsMessage msg) {
    if (_disposed) return;

    switch (msg) {
      case AssistantMessage():
        _onAssistantMessage(msg);
      case EvaluationStarted():
        _onEvaluationStarted();
      case EvaluationData():
        _onEvaluationData(msg);
      case EvaluationComplete():
        _onEvaluationComplete(msg);
      case EvaluationErrorMessage():
        _onEvaluationErrorMessage(msg);
      case EvaluationCancelled():
        _onEvaluationCancelled(msg);
      case ErrorMessage():
        _onErrorMessage(msg);
      case DoneMessage():
        _onDone();
      case UnknownMessage():
        // Ignorar silenciosamente.
        break;
    }
  }

  void _onAssistantMessage(AssistantMessage msg) {
    // Si la última burbuja es de Altea y está vacía, la rellenamos.
    if (_mensajes.isNotEmpty &&
        _mensajes.last.esAsistente &&
        _mensajes.last.estaVacio) {
      _mensajes[_mensajes.length - 1] = _mensajes.last.copyWith(
        texto: msg.content,
      );
    } else {
      // Si no, añadimos una nueva.
      _mensajes.add(ChatMessage.assistant(msg.content));
    }

    _notificar();
  }

  void _onEvaluationStarted() {
    // No añadimos mensaje. El backend ya manda un `assistant_message`
    // justo después con la primera pregunta.
  }

  void _onEvaluationData(EvaluationData msg) {
    // No mostramos los datos extraídos como burbujas.
    // Solo se usan internamente en el backend.
    // Flutter podría mostrar un progreso, pero para v1 no lo hacemos.
  }

  void _onEvaluationComplete(EvaluationComplete msg) {
    // Construir recomendaciones localmente.
    final recomendaciones = _construirRecomendaciones(msg.input);

    _resultado = EvaluationOutcome(
      score: msg.score,
      recomendaciones: recomendaciones,
    );

    _modo = ChatMode.resultado;

    _notificar();
  }

  void _onEvaluationErrorMessage(EvaluationErrorMessage msg) {
    _mensajes.add(ChatMessage.error(msg.message));
    _notificar();
  }

  void _onEvaluationCancelled(EvaluationCancelled msg) {
    _mensajes.add(ChatMessage.assistant('La evaluación se ha cancelado.'));
    _notificar();
  }

  void _onErrorMessage(ErrorMessage msg) {
    _agregarError(msg.message);
  }

  void _onDone() {
    _cargando = false;

    // Si la última burbuja de Altea quedó vacía, poner algo.
    if (_mensajes.isNotEmpty &&
        _mensajes.last.esAsistente &&
        _mensajes.last.estaVacio) {
      _mensajes[_mensajes.length - 1] = _mensajes.last.copyWith(texto: '...');
    }

    _notificar();
  }

  // ==========================================================
  // HELPERS
  // ==========================================================

  void _agregarError(String texto) {
    _mensajes.add(ChatMessage.error(texto));
    _cargando = false;
    _notificar();
  }

  void _notificar() {
    if (_disposed) return;
    notifyListeners();
  }

  RecommendationResult _construirRecomendaciones(Map<String, dynamic> input) {
    // Extraer valores con defaults seguros.
    final apHi = (input['ap_hi'] as num?)?.toDouble() ?? 120.0;
    final apLo = (input['ap_lo'] as num?)?.toDouble() ?? 80.0;
    final peso = (input['weight'] as num?)?.toDouble() ?? 70.0;
    final altura = (input['height'] as num?)?.toDouble() ?? 170.0;
    final colesterol = (input['cholesterol'] as num?)?.toInt() ?? 1;
    final gluc = (input['gluc'] as num?)?.toInt() ?? 1;
    final smoke = ((input['smoke'] as num?)?.toDouble() ?? 0) > 0.5;
    final alco = ((input['alco'] as num?)?.toDouble() ?? 0) > 0.5;
    final active = (input['active'] as num?)?.toInt() ?? 1;

    return RecommendationService.generarRecomendaciones(
      fuma: smoke,
      consumeAlcohol: alco,
      actividadFisica: active,
      presionSistolica: apHi,
      presionDiastolica: apLo,
      glucosa: gluc,
      colesterol: colesterol,
      peso: peso,
      altura: altura,
    );
  }
}
