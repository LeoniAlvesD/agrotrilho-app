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
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Configurações',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildProfileCard(),
          const SizedBox(height: AppSpacing.lg),
          _buildSettingsSection(context),
          const SizedBox(height: AppSpacing.lg),
          _buildAboutSection(context),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.producerName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.producerEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
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
          const Divider(height: 1, indent: 56),
          _buildSettingsTile(
            icon: Icons.palette_outlined,
            title: 'Tema',
            subtitle: 'Claro / Escuro (em breve)',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1, indent: 56),
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
                applicationIcon: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
                children: [
                  const Text(AppStrings.appDescription),
                ],
              );
            },
          ),
          const Divider(height: 1, indent: 56),
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
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: 20,
      ),
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
