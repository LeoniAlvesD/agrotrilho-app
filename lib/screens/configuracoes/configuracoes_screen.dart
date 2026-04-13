import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Configurações',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileCard(),
          const SizedBox(height: 16),
          _buildSettingsSection(context),
          const SizedBox(height: 16),
          _buildAboutSection(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.producerName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    AppStrings.producerEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notificações',
            subtitle: 'Gerenciar alertas e lembretes',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.palette_outlined,
            title: 'Tema',
            subtitle: 'Claro / Escuro (em breve)',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Idioma',
            subtitle: 'Português (Brasil)',
            onTap: () => _showComingSoon(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'Sobre o App',
            subtitle: AppStrings.appDescription,
            onTap: () {
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
          const Divider(height: 1),
          _buildSettingsTile(
            icon: Icons.verified_outlined,
            title: 'Versão',
            subtitle: AppStrings.appVersion,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade em breve!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
