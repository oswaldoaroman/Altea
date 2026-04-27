import 'package:flutter/material.dart';
import '../../topics/colors.dart';

class PageDots extends StatelessWidget {
  final int total;
  final int active;

  const PageDots({super.key, this.total = 5, this.active = 1});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) => Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: i == active ? AppColors.dark : const Color(0xFFD9D9D9),
          shape: BoxShape.circle,
        ),
      )),
    );
  }
}
