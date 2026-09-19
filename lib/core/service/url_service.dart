import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlService {
  /// Abre una URL en una aplicación externa, normalmente el navegador.
  static Future<bool> abrirUrl(String link) async {
    final Uri url = Uri.parse(link);

    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error al abrir URL: $e');
      return false;
    }
  }

  /// Abre una búsqueda en Google Maps.
  static Future<bool> abrirGoogleMaps(String busqueda) async {
    final Uri url = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': busqueda,
    });

    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error al abrir Google Maps: $e');
      return false;
    }
  }

  /// Abre una búsqueda de Google.
  static Future<bool> buscarEnGoogle(String busqueda) async {
    final Uri url = Uri.https('www.google.com', '/search', {'q': busqueda});

    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error al buscar en Google: $e');
      return false;
    }
  }
}
