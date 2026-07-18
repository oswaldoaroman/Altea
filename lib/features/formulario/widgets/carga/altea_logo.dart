import 'package:flutter/material.dart';

class AlteaLogo extends StatelessWidget {
  const AlteaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/altea_logo.png',
      width: 250,
      height: 200,
    );
  }
}