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
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isSelected = index == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppColors.primary.withAlpha(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      onItemSelected(index);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'v${AppStrings.appVersion}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.xl,
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.agriculture,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            AppStrings.appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.appDescription,
            style: TextStyle(
              color: Colors.white.withAlpha(200),
              fontSize: 12,
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
