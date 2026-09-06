import 'dart:convert';

import 'package:http/http.dart' as http;

class OllamaService {
  // Android Emulator
  static const String _baseUrl = 'http://127.0.0.1:8000';

  // Si utilizas un dispositivo físico, cambia 10.0.2.2
  // por la IP de tu PC en la red local.
  //
  // Ejemplo:
  // static const String _baseUrl = 'http://192.168.1.100:8000';

  static Future<String> preguntar(String prompt) async {
    final url = Uri.parse('$_baseUrl/ollama/ask');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt, 'stream': false}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['result'] as String;
    }

    try {
      final data = jsonDecode(response.body);

      throw Exception(data['detail'] ?? 'Error al comunicarse con Altea.');
    } catch (_) {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }
}
