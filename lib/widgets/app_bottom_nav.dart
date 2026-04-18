import 'package:flutter/material.dart';

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

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      animationDuration: const Duration(milliseconds: 300),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard, color: colorScheme.primary),
          label: 'Home',
          tooltip: 'Ir para Home',
        ),
        NavigationDestination(
          icon: const Icon(Icons.pets_outlined),
          selectedIcon: Icon(Icons.pets, color: colorScheme.primary),
          label: 'Animais',
          tooltip: 'Ver animais',
        ),
        NavigationDestination(
          icon: const Icon(Icons.qr_code_scanner_outlined),
          selectedIcon:
              Icon(Icons.qr_code_scanner, color: colorScheme.primary),
          label: 'Scanner',
          tooltip: 'Abrir scanner QR',
        ),
        NavigationDestination(
          icon: const Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart, color: colorScheme.primary),
          label: 'Relatórios',
          tooltip: 'Ver relatórios',
        ),
        NavigationDestination(
          icon: const Icon(Icons.health_and_safety_outlined),
          selectedIcon:
              Icon(Icons.health_and_safety, color: colorScheme.primary),
          label: 'Sanitário',
          tooltip: 'Controle sanitário',
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
