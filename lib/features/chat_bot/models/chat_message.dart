/// Representa un mensaje de la UI del chat.
///
/// Diferente de `WsMessage`: `ChatMessage` es lo que se pinta en la
/// pantalla. Puede ser del usuario, de Altea, o un error local.
class ChatMessage {
  final ChatMessageRole role;
  final String texto;
  final DateTime timestamp;

  ChatMessage({required this.role, required this.texto, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  // ==========================================================
  // FACTORIES
  // ==========================================================

  factory ChatMessage.user(String texto) =>
      ChatMessage(role: ChatMessageRole.user, texto: texto);

  factory ChatMessage.assistant(String texto) =>
      ChatMessage(role: ChatMessageRole.assistant, texto: texto);

  factory ChatMessage.error(String texto) =>
      ChatMessage(role: ChatMessageRole.error, texto: texto);

  // ==========================================================
  // HELPERS
  // ==========================================================

  bool get esUsuario => role == ChatMessageRole.user;
  bool get esAsistente => role == ChatMessageRole.assistant;
  bool get esError => role == ChatMessageRole.error;
  bool get estaVacio => texto.isEmpty;

  /// Crea una copia con el texto modificado.
  ChatMessage copyWith({String? texto}) {
    return ChatMessage(
      role: role,
      texto: texto ?? this.texto,
      timestamp: timestamp,
    );
  }

  @override
  String toString() => 'ChatMessage(role: $role, texto: $texto)';
}

enum ChatMessageRole { user, assistant, error }
