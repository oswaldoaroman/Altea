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

  static Future<void> abrirGoogleMaps(String busqueda) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(busqueda)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('No se pudo abrir Google Maps');
    }
  }
}
