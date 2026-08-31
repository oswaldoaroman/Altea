import 'dart:math';

import 'package:altea/features/home/models/consejo.dart';
import 'package:altea/features/home/data/consejos.dart';

class ConsejoService {
  Consejo obtenerConsejo() {
    final random = Random();

    return consejos[random.nextInt(consejos.length)];
  }
}
