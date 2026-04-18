import 'package:flutter/material.dart';

/// Maps the 5 mobile bottom-nav destinations to their screen indices in
/// [RootScreen._buildBody]. Screens not listed here are accessible from the
/// side drawer (Animais, Relatórios, Sanitário).
const _kNavToScreen = [
  0, // Home
  1, // Lotes
  2, // Voz
  3, // Ações
  7, // Configurações
];

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Convert screen index → nav bar visual index.
    final navIndex = _kNavToScreen.indexOf(currentIndex).clamp(0, 4);

    return NavigationBar(
      selectedIndex: navIndex,
      onDestinationSelected: (i) => onTap(_kNavToScreen[i]),
      animationDuration: const Duration(milliseconds: 300),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: colorScheme.primary),
          label: 'Home',
          tooltip: 'Ir para Home',
        ),
        NavigationDestination(
          icon: const Icon(Icons.layers_outlined),
          selectedIcon: Icon(Icons.layers, color: colorScheme.primary),
          label: 'Lotes',
          tooltip: 'Ver lotes',
        ),
        NavigationDestination(
          icon: const Icon(Icons.mic_none),
          selectedIcon: Icon(Icons.mic, color: colorScheme.primary),
          label: 'Voz',
          tooltip: 'Comando de voz',
        ),
        NavigationDestination(
          icon: const Icon(Icons.bolt_outlined),
          selectedIcon: Icon(Icons.bolt, color: colorScheme.primary),
          label: 'Ações',
          tooltip: 'Ações rápidas',
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings, color: colorScheme.primary),
          label: 'Config',
          tooltip: 'Configurações',
        ),
      ],
    );
  }
}
