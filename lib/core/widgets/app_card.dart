import 'package:flutter/material.dart';
import '../theme/colors.dart';


class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(18)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.ink.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: child,
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const RoundIconButton({super.key, required this.icon, this.color = AppColors.ink, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(9), child: Icon(icon, size: 18, color: color)),
      ),
    );
  }
}

// Encabezado 
class TopTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final VoidCallback? onAvatarTap;
  const TopTitle({super.key, required this.title, this.subtitle, this.onBack, this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              onBack != null
                  ? RoundIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack)
                  : const SizedBox(width: 34, height: 34),
              RoundIconButton(icon: Icons.favorite_rounded, color: AppColors.blue, onTap: onAvatarTap),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.ink)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: const TextStyle(fontSize: 13, color: AppColors.slate, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}


class PillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed; 
  const PillButton({
    super.key,
    required this.label,
    this.icon,
    this.color = AppColors.blue,
    this.textColor = Colors.white,
    this.onPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed, 
        icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
      ),
    );
  }
}