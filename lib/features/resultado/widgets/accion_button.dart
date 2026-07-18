import 'package:flutter/material.dart';

class AccionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;

  const AccionButton({
    super.key,
    required this.label,
    required this.icon,
    this.bgColor = const Color(0xFFE1F0F7),
    this.textColor = Colors.black,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor, size: 18),
        label: Text(label, style: TextStyle(color: textColor, fontSize: 15)),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
