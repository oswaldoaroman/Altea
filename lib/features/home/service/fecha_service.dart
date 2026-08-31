class FechaService {
  String obtenerFechaActual() {
    final ahora = DateTime.now();

    const dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];

    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    return '${dias[ahora.weekday - 1]} ${ahora.day} de ${meses[ahora.month - 1]}';
  }
}
