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
    _DrawerItem(icon: Icons.dashboard, label: 'Home'),
    _DrawerItem(icon: Icons.pets, label: 'Animais'),
    _DrawerItem(icon: Icons.qr_code_scanner, label: 'Scanner'),
    _DrawerItem(icon: Icons.bar_chart, label: 'Relatórios'),
    _DrawerItem(icon: Icons.settings, label: 'Configurações'),
  ];

  @override
  Widget build(BuildContext context) {
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
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isSelected ? AppColors.primary : Colors.grey[700],
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.grey[800],
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: AppColors.primary.withAlpha(20),
                  onTap: () {
                    onItemSelected(index);
                    if (Scaffold.of(context).isDrawerOpen) {
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: AppStrings.appName,
                applicationVersion: AppStrings.appVersion,
                applicationIcon: const Icon(
                  Icons.agriculture,
                  size: 48,
                  color: AppColors.primary,
                ),
                children: [
                  const Text(AppStrings.appDescription),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.agriculture,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            AppStrings.appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
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
