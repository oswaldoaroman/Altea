import 'package:flutter/material.dart';

import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/app_card.dart';
import 'package:altea/core/widgets/responsive_body.dart';

import '../controllers/chat_controller.dart';
import '../models/chat_message.dart';

/// Vista de conversación del chat.
///
/// Solo renderiza:
/// - La lista de mensajes.
/// - El input de texto.
/// - El botón de enviar.
///
/// NO conoce WebSocket, NO conoce el controller internamente.
/// Recibe el controller y lo escucha.
class ChatConversationView extends StatefulWidget {
  const ChatConversationView({super.key, required this.controller});

  final ChatController controller;

  @override
  State<ChatConversationView> createState() => _ChatConversationViewState();
}

class _ChatConversationViewState extends State<ChatConversationView> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scrollAlFinal);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollAlFinal);
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollAlFinal() {
    // Esperar al siguiente frame para que el ListView esté actualizado.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _enviar() {
    final texto = _inputController.text.trim();
    if (texto.isEmpty) return;

    widget.controller.enviarMensaje(texto);
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final mensajes = widget.controller.mensajes;
    final cargando = widget.controller.cargando;

    return ResponsiveBody(
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
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              itemCount: mensajes.length,
              itemBuilder: (context, i) {
                final m = mensajes[i];

                return _BurbujaMensaje(mensaje: m);
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
                    controller: _inputController,
                    enabled: !cargando,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _enviar(),
                    decoration: InputDecoration(
                      hintText: cargando
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
                  backgroundColor: cargando ? Colors.grey : AppColors.blue,
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: cargando ? null : _enviar,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// BURBUJA
// ==========================================================

class _BurbujaMensaje extends StatelessWidget {
  const _BurbujaMensaje({required this.mensaje});

  final ChatMessage mensaje;

  @override
  Widget build(BuildContext context) {
    final esUsuario = mensaje.esUsuario;
    final esError = mensaje.esError;

    // Colores según el rol.
    final Color fondo;
    final Color colorTexto;

    if (esUsuario) {
      fondo = AppColors.blue;
      colorTexto = Colors.white;
    } else if (esError) {
      fondo = Colors.red.shade50;
      colorTexto = Colors.red.shade900;
    } else {
      fondo = Colors.white;
      colorTexto = AppColors.ink;
    }

    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 260),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(16),
          boxShadow: esUsuario
              ? null
              : [
                  BoxShadow(
                    color: AppColors.ink.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: mensaje.estaVacio
            ? const SizedBox(
                width: 35,
                height: 20,
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : Text(
                mensaje.texto,
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
