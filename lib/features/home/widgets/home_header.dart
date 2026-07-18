import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.dark,
            child: ClipOval(
              child: SizedBox(
                width: 44,
                height: 44,
                // Cambiamos SvgPicture.asset por Image.asset
                child: Image.asset('assets/altea_logo.png', fit: BoxFit.cover),
              ),
            ),
          ),
          Text(
            '¡Hola Isela!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
