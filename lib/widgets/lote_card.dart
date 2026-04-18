import 'package:flutter/material.dart';
import '../models/lote.dart';

/// Card displaying a single [Lote] with status, info and action buttons.
class LoteCard extends StatelessWidget {
  final Lote lote;
  final VoidCallback? onVerDetalhes;
  final VoidCallback? onGerenciar;

  const LoteCard({
    super.key,
    required this.lote,
    this.onVerDetalhes,
    this.onGerenciar,
  });

  Color _statusColor(LoteStatus status) {
    switch (status) {
      case LoteStatus.ativo:
        return const Color(0xFF2E7D32);
      case LoteStatus.vendido:
        return const Color(0xFF1976D2);
      case LoteStatus.abatido:
        return const Color(0xFFD32F2F);
      case LoteStatus.transferido:
        return const Color(0xFFF57C00);
    }
  }

  IconData _statusIcon(LoteStatus status) {
    switch (status) {
      case LoteStatus.ativo:
        return Icons.check_circle;
      case LoteStatus.vendido:
        return Icons.sell;
      case LoteStatus.abatido:
        return Icons.remove_circle;
      case LoteStatus.transferido:
        return Icons.swap_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(lote.status);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(80),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    lote.nome,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withAlpha(80)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon(lote.status), size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        lote.status.label,
                        style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.pets,
                  label: '${lote.quantidadeAnimais} animais',
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.monitor_weight,
                  label: '${lote.pesoMedio.toStringAsFixed(0)} kg/cabeça',
                ),
              ],
            ),
            if (lote.observacoes.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                lote.observacoes,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onVerDetalhes,
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('Ver detalhes',
                        style: TextStyle(fontSize: 14)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onGerenciar,
                    icon: const Icon(Icons.settings, size: 18),
                    label: const Text('Gerenciar',
                        style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size.zero,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
