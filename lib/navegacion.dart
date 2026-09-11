import 'package:flutter/material.dart';
import 'widgets_reutilizables/bottom_nav.dart';
import 'features/home/home_screen.dart';
import 'features/form/eval_screen.dart';
import 'features/services/informes_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/perfil/profile_screen.dart';


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
        final esAncho = constraints.maxWidth >= 700;

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
