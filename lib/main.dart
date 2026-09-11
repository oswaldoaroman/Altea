import 'package:altea/loging/Screens/welcome_screen.dart';//aca empieza todo bro
import 'package:flutter/material.dart';
import 'core/theme/colors.dart';

void main() => runApp(const AlteaApp());

class AlteaApp extends StatelessWidget {
  const AlteaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Altea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.sky,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
      ),
      home: const WelcomeScreen(),
    );
  }
}
