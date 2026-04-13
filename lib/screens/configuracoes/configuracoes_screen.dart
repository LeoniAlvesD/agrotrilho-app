import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: ResponsiveHelper.getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.sm),
          Semantics(
            header: true,
            child: Text('Configurações', style: theme.textTheme.headlineSmall),
          ),
          SizedBox(height: AppSpacing.xl),
          _buildProfileCard(context),
          SizedBox(height: AppSpacing.lg),
          _buildSettingsSection(context),
          SizedBox(height: AppSpacing.lg),
          _buildAboutSection(context),
          SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(AppSpacing.lg),
              ),
              child: Icon(
                Icons.person,
                color: colorScheme.primary,
                size: 36,
                semanticLabel: 'Foto do perfil',
              ),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.producerName,
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.producerEmail,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: colorScheme.onSurfaceVariant,
                semanticLabel: 'Editar perfil'),
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
            context,
            icon: Icons.notifications_outlined,
            title: 'Notificações',
            subtitle: 'Gerenciar alertas e lembretes',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            context,
            icon: Icons.palette_outlined,
            title: 'Tema',
            subtitle: 'Claro / Escuro (em breve)',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            context,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'Sobre o App',
            subtitle: AppStrings.appDescription,
            onTap: () {
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
          const Divider(height: 1),
          _buildSettingsTile(
            context,
            icon: Icons.verified_outlined,
            title: 'Versão',
            subtitle: AppStrings.appVersion,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
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
