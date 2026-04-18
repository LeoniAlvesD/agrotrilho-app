import 'package:flutter/material.dart';

/// Section widget that lists supported voice commands with examples.
class VoiceCommandHelp extends StatelessWidget {
  const VoiceCommandHelp({super.key});

  static const _commands = [
    _VoiceCommandItem(
      icon: Icons.add_circle_outline,
      command: '"Novo lote"',
      description: 'Cria um novo lote de animais',
    ),
    _VoiceCommandItem(
      icon: Icons.list_alt,
      command: '"Ver lotes"',
      description: 'Abre a lista de lotes',
    ),
    _VoiceCommandItem(
      icon: Icons.trending_up,
      command: '"Valorizar"',
      description: 'Acessa ações rápidas',
    ),
    _VoiceCommandItem(
      icon: Icons.pets,
      command: '"Cadastrar animal"',
      description: 'Vai para o cadastro de animal',
    ),
    _VoiceCommandItem(
      icon: Icons.qr_code_scanner,
      command: '"Rastreabilidade"',
      description: 'Abre a tela de rastreamento',
    ),
    _VoiceCommandItem(
      icon: Icons.bar_chart,
      command: '"Relatório SISBOV"',
      description: 'Abre a tela de relatórios',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.mic, color: colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comandos de Voz',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Fale um destes comandos',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(_commands.map((item) => _CommandRow(item: item))),
        ],
      ),
    );
  }
}

class _CommandRow extends StatelessWidget {
  final _VoiceCommandItem item;
  const _CommandRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(item.icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.command,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  item.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceCommandItem {
  final IconData icon;
  final String command;
  final String description;
  const _VoiceCommandItem({
    required this.icon,
    required this.command,
    required this.description,
  });
}
