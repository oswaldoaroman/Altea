import 'package:flutter/material.dart';
import '../topics/colors.dart';

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Aumenta vitaminas', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                SizedBox(height: 6),
                Text('consume mas vitaminas del grupo B', style: TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }
}
