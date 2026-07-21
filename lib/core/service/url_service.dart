import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static Future<bool> abrirUrl(String link) async {
    final Uri url = Uri.parse(link);

    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error al abrir URL: $e');
      return false;
    }
  }
}
