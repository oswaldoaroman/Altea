import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/app_card.dart';
import '../widgets/responsive_body.dart';

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
  final _controller = TextEditingController();
  final List<_Msg> _mensajes = [
    _Msg('Hola Isela, soy Altea. ¿Cómo te sientes hoy?', false),
    _Msg('He sentido dolor en el pecho recientemente.', true),
    _Msg('Lamento escuchar eso. ¿El dolor es constante o va y viene? Te recomiendo contactar a tu doctor si persiste.', false),
  ];

  void _enviar() {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _mensajes.add(_Msg(_controller.text.trim(), true)));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopTitle(title: 'Chat con Altea', subtitle: 'Asistente de salud'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: _mensajes.length,
              itemBuilder: (context, i) {
                final m = _mensajes[i];
                return Align(
                  alignment: m.esUsuario ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 260),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: m.esUsuario ? AppColors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: m.esUsuario
                          ? null
                          : [BoxShadow(color: AppColors.ink.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
                    ),
                    child: Text(
                      m.texto,
                      style: TextStyle(color: m.esUsuario ? Colors.white : AppColors.ink, fontSize: 13, fontWeight: FontWeight.w500),
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
                    onSubmitted: (_) => _enviar(),
                    decoration: InputDecoration(
                      hintText: 'Escribe tu pregunta...',
                      filled: true,
                      fillColor: AppColors.sky,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.blue,
                  child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18), onPressed: _enviar),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
