import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static Future<void> abrirUrl(String link) async {
    final Uri url = Uri.parse(link);

    try {
      bool abierto = await launchUrl(url, mode: LaunchMode.externalApplication);

      if (!abierto) {
        print('No se pudo abrir la URL');
      }
    } catch (e) {
      print('Error al abrir URL: $e');
    }
  }
}
