import 'package:flutter/material.dart';
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
  final String texto;
  final bool esUsuario;

  _Msg(this.texto, this.esUsuario);
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<_Msg> _mensajes = [
    _Msg('Hola Isela, soy Altea. ¿Cómo te sientes hoy?', false),
  ];

  bool _cargando = false;

  Future<void> _enviar() async {
    final texto = _controller.text.trim();

    if (texto.isEmpty || _cargando) return;

    // Agregar mensaje del usuario
    setState(() {
      _mensajes.add(_Msg(texto, true));

      _controller.clear();
      _cargando = true;
    });

    try {
      // Construir el historial de conversación
      final historial = _mensajes
          .map(
            (mensaje) =>
                '${mensaje.esUsuario ? "Usuario" : "Altea"}: ${mensaje.texto}',
          )
          .join('\n');

      final prompt =
          '''
Eres Altea, un asistente virtual de salud.

Tu objetivo es orientar al usuario de forma clara, empática y responsable.

No debes realizar diagnósticos médicos definitivos.
Si el usuario describe síntomas potencialmente graves, recomienda buscar atención médica.

Esta es la conversación actual:

$historial

Responde al último mensaje del usuario de forma natural y clara.
''';

      final respuesta = await OllamaService.preguntar(prompt);

      if (!mounted) return;

      setState(() {
        _mensajes.add(_Msg(respuesta, false));

        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _mensajes.add(
          _Msg(
            'Lo siento, no pude comunicarme con el servidor de Altea. '
            'Por favor, inténtalo nuevamente.',
            false,
          ),
        );

        _cargando = false;
      });

      debugPrint('Error Ollama: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                itemCount: _mensajes.length + (_cargando ? 1 : 0),
                itemBuilder: (context, i) {
                  // Indicador de carga
                  if (_cargando && i == _mensajes.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const SizedBox(
                          width: 35,
                          height: 20,
                          child: Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

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
                      child: Text(
                        m.texto,
                        style: TextStyle(
                          color: m.esUsuario ? Colors.white : AppColors.ink,
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
