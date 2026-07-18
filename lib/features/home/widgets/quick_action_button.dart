import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final double opacity;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Colors.white],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 2,
          ),
          title: Text(
            label,
            style: const TextStyle(color: AppColors.textDark, fontSize: 15),
          ),
          trailing: Icon(icon, color: AppColors.textDark),
          onTap: onTap,
        ),
      ),
    );
  }
}
