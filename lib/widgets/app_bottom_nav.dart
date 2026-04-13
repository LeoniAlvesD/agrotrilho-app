import 'package:flutter/material.dart';
import '../utils/constants.dart';

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
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.primary.withAlpha(30),
      animationDuration: const Duration(milliseconds: 300),
      elevation: 3,
      shadowColor: Colors.black26,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 68,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.pets_outlined),
          selectedIcon: Icon(Icons.pets, color: AppColors.primary),
          label: 'Animais',
        ),
        NavigationDestination(
          icon: Icon(Icons.qr_code_scanner_outlined),
          selectedIcon:
              Icon(Icons.qr_code_scanner, color: AppColors.primary),
          label: 'Scanner',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart, color: AppColors.primary),
          label: 'Relatórios',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings, color: AppColors.primary),
          label: 'Config',
        ),
      ],
    );
  }
}
