import 'package:flutter/material.dart';

import 'package:altea/core/theme/colors.dart';
import 'package:altea/core/widgets/bottom_nav.dart';

import 'package:altea/features/home/screens/home_screen.dart';
import 'package:altea/features/form/screens/eval_screen.dart';
import 'package:altea/features/information/screens/informes_screen.dart';
import 'package:altea/features/chat_bot/screens/chat_screen.dart';
import 'package:altea/features/profiles/screens/profile_screen.dart';

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
      home: const RootShell(),
    );
  }
}

/// Contenedor raíz de la aplicación.
/// Mantiene la navegación principal y permite cambiar
/// entre NavigationRail y BottomNavigationBar dependiendo
/// del ancho disponible.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  void _go(int i) {
    setState(() {
      _index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final esAncho = constraints.maxWidth >= 700;

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                // PANEL LATERAL
                if (esAncho)
                  NavigationRail(
                    selectedIndex: _index,
                    onDestinationSelected: _go,
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.white,
                    destinations: navItems
                        .map(
                          (n) => NavigationRailDestination(
                            icon: Icon(n.icon),
                            label: Text(n.label),
                          ),
                        )
                        .toList(),
                  ),

                // CONTENIDO
                Expanded(
                  child: IndexedStack(
                    index: _index,
                    children: [
                      HomeScreen(onNavigate: _go),
                      const EvalScreen(),
                      const InformesScreen(),
                      const ChatScreen(),
                      const ProfileScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // NAVEGACIÓN INFERIOR EN CELULAR
          bottomNavigationBar: esAncho
              ? null
              : AlteaBottomNav(index: _index, onTap: _go),
        );
      },
    );
  }
}
