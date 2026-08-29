import 'package:flutter/material.dart';
import '../theme/colors.dart';

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}

const navItems = [
  NavItem(Icons.home_rounded, 'Inicio'),
  NavItem(Icons.assignment_rounded, 'Evaluar'),
  NavItem(Icons.description_rounded, 'Informes'),
  NavItem(Icons.chat_bubble_rounded, 'Chat'),
  NavItem(Icons.person_rounded, 'Perfil'),
];


class AlteaBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const AlteaBottomNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [BoxShadow(color: AppColors.ink.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: List.generate(navItems.length, (i) {
            final active = i == index;
            return Expanded(
              flex: active ? 2 : 1,
              child: GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? AppColors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(navItems[i].icon, size: 18, color: active ? Colors.white : AppColors.slate),
                      if (active) ...[
                        const SizedBox(width: 6),
                        Text(navItems[i].label,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11)),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
