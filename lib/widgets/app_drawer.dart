import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const _items = <_DrawerItem>[
    _DrawerItem(icon: Icons.home, label: 'Home'),
    _DrawerItem(icon: Icons.layers, label: 'Lotes'),
    _DrawerItem(icon: Icons.mic, label: 'Voz'),
    _DrawerItem(icon: Icons.bolt, label: 'Ações Rápidas'),
    _DrawerItem(icon: Icons.pets, label: 'Animais'),
    _DrawerItem(icon: Icons.bar_chart, label: 'Relatórios'),
    _DrawerItem(icon: Icons.health_and_safety, label: 'Controle Sanitário'),
    _DrawerItem(icon: Icons.settings, label: 'Configurações'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isSelected = index == selectedIndex;
                return Semantics(
                  selected: isSelected,
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: colorScheme.primary.withAlpha(20),
                    onTap: () {
                      onItemSelected(index);
                      if (Scaffold.of(context).isDrawerOpen) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: colorScheme.onSurfaceVariant,
            ),
            title: const Text('Sobre'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: AppStrings.appName,
                applicationVersion: AppStrings.appVersion,
                applicationIcon: Icon(
                  Icons.agriculture,
                  size: 48,
                  color: colorScheme.primary,
                ),
                children: [
                  const Text(AppStrings.appDescription),
                ],
              );
            },
          ),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DrawerHeader(
      decoration: BoxDecoration(color: colorScheme.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(AppSpacing.lg),
            ),
            child: const Icon(
              Icons.agriculture,
              color: Colors.white,
              size: 36,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          const Text(
            AppStrings.appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.producerName,
            style: TextStyle(
              color: Colors.white.withAlpha(200),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;

  const _DrawerItem({required this.icon, required this.label});
}
