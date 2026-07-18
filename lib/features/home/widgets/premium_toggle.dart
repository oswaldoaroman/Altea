import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class PremiumToggle extends StatefulWidget {
  const PremiumToggle({super.key});

  @override
  State<PremiumToggle> createState() => _PremiumToggleState();
}

class _PremiumToggleState extends State<PremiumToggle> {
  bool _isPremium = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDFF5FF), Colors.white],
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Cambiar a premium',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Switch(
            value: _isPremium,
            onChanged: (v) => setState(() => _isPremium = v),
            activeColor: AppColors.dark,
            inactiveThumbColor: AppColors.dark,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
