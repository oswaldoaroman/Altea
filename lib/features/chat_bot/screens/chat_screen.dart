import 'package:flutter/material.dart';

import 'package:altea/features/evaluation/screens/result_screen.dart';

import '../controllers/chat_controller.dart';
import 'chat_conversation_view.dart';

/// Contenedor del flujo del chat.
///
/// Alterna entre dos vistas internas según `ChatController.modo`:
/// - `chat` → `ChatConversationView` (burbujas + input).
/// - `resultado` → `ResultScreen` (reutilizada del formulario).
///
/// La barra de navegación inferior se mantiene siempre, porque este
/// widget sigue siendo una pestaña del `IndexedStack` del `RootShell`.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.onNavigate});

  final void Function(int) onNavigate;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ChatController();
    _controller.inicializar();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Modo resultado.
        if (_controller.modo == ChatMode.resultado) {
          final outcome = _controller.resultado!;

          return ResultScreen(
            resultado: outcome.score,
            recommendationResult: outcome.recomendaciones,
            onBack: _controller.volverAlChat,
            onNavigate: widget.onNavigate,
            mostrarBotonPreguntarAltea: false,
            textoBotonVolver: 'Volver al chat',
          );
        }

        // Modo chat.
        return ChatConversationView(controller: _controller);
      },
    );
  }
}
