import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/large_action_card.dart';

/// Quick-actions screen with large, colourful cards.
class AcoesScreen extends StatelessWidget {
  const AcoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: ResponsiveHelper.getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),

          // ── Header banner ────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF57C00).withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFF57C00).withAlpha(60)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF57C00).withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bolt,
                      color: Color(0xFFF57C00), size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ações Rápidas',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFF57C00),
                      ),
                    ),
                    Text(
                      'O que você quer fazer agora?',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ── Cards grid ───────────────────────────────────────────────
          _ActionGrid(),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = _buildActions(context);
    final cols = ResponsiveHelper.isMobile(context) ? 2 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (_, i) => actions[i],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      LargeActionCard(
        icon: Icons.add_circle_outline,
        label: 'Novo Lote',
        subtitle: 'Criar um lote de animais',
        color: const Color(0xFF7B1FA2),
        onTap: () => _snack(context, 'Novo Lote'),
      ),
      LargeActionCard(
        icon: Icons.pets,
        label: 'Cadastrar Animal',
        subtitle: 'Adicionar um animal ao rebanho',
        color: const Color(0xFF2E7D32),
        onTap: () => _snack(context, 'Cadastrar Animal'),
      ),
      LargeActionCard(
        icon: Icons.qr_code_scanner,
        label: 'Escanear QR',
        subtitle: 'Ler QR Code ou brinco digital',
        color: const Color(0xFF1565C0),
        onTap: () => _snack(context, 'Scanner'),
      ),
      LargeActionCard(
        icon: Icons.trending_up,
        label: 'Valorizar',
        subtitle: 'Ver cotações e mercado',
        color: const Color(0xFFAD1457),
        onTap: () => _snack(context, 'Valorizar'),
      ),
      LargeActionCard(
        icon: Icons.health_and_safety,
        label: 'Saúde Animal',
        subtitle: 'Registrar vacinação e eventos',
        color: const Color(0xFF00838F),
        onTap: () => _snack(context, 'Saúde Animal'),
      ),
      LargeActionCard(
        icon: Icons.bar_chart,
        label: 'Relatório SISBOV',
        subtitle: 'Gerar relatório oficial',
        color: const Color(0xFFF57C00),
        onTap: () => _snack(context, 'Relatório SISBOV'),
      ),
    ];
  }

  void _snack(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abrindo: $label'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
