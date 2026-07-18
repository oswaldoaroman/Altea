import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, Colors.white],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopRow(),
            const SizedBox(height: 16),
            const Text(
              'Historial Médico:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.calendar_month,
              title: 'Última Revisión:',
              subtitle: '18 de marzo , 2026',
              badge: 'Completada',
              badgeColor: AppColors.green,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.monitor_heart_outlined,
              title: 'Condiciones Activas:',
              subtitle: 'Hipertensión Controlada',
              badge: 'Monitoreo',
              badgeColor: AppColors.yellow,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.warning_amber_rounded,
              title: 'Alertas:',
              subtitle: 'Por el momento su salud se encuentra bien',
              badge: 'Avisado',
              badgeColor: AppColors.red,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SoftButton(
                    icon: Icons.folder_open,
                    label: 'Ver expediente completo',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SoftButton(
                    icon: Icons.local_hospital_outlined,
                    label: 'Llamar Doctor EMERGENCIA',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dark,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'ESTIMAR RIESGO A 10 AÑOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 16, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Isela',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Altea',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0078B3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        Column(
          children: const [
            Text(
              'Riesgo estimado',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),
            RiskGauge(percent: 0.08, label: 'Bajo', value: '8%'),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.dark),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11,
                    color: badgeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoftButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SoftButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE1F0F7), Color(0xFFFDFEFF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.dark),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class RiskGauge extends StatelessWidget {
  final double percent;
  final String label;
  final String value;

  const RiskGauge({
    super.key,
    required this.percent,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: CustomPaint(
        painter: _GaugePainter(percent: percent),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Color(0xFF759F7A)),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percent;
  const _GaugePainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    paint.color = Colors.grey.shade200;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi * 0.75,
      pi * 1.5,
      false,
      paint,
    );

    paint.color = AppColors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi * 0.75,
      pi * 1.5 * percent,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
