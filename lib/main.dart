import 'package:flutter/material.dart';
import 'core/theme/colors.dart';
import 'widgets_reutilizables/bottom_nav.dart';
import 'features/home/home_screen.dart';
import 'features/form/eval_screen.dart';
import 'features/services/informes_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/perfil/profile_screen.dart';

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

/// Contenedor raíz: cambia entre nav inferior (celular) y NavigationRail
/// (tablet / plegable abierto) según el ancho disponible.
class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    EvalScreen(),
    InformesScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final esAncho = constraints.maxWidth >= 700; // tablet o plegable abierto

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                if (esAncho)
                  NavigationRail(
                    selectedIndex: _index,
                    onDestinationSelected: _go,
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: Colors.white,
                    destinations: navItems
                        .map((n) => NavigationRailDestination(icon: Icon(n.icon), label: Text(n.label)))
                        .toList(),
                  ),
                Expanded(child: _screens[_index]),
              ],
            ),
          ),
          bottomNavigationBar: esAncho ? null : AlteaBottomNav(index: _index, onTap: _go),
        );
      },
    );
  }
}
