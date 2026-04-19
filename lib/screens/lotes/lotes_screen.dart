import 'package:flutter/material.dart';
import '../../models/lote.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/lote_card.dart';

/// Displays the list of lots with status indicators and action buttons.
class LotesScreen extends StatefulWidget {
  const LotesScreen({super.key});

  @override
  State<LotesScreen> createState() => _LotesScreenState();
}

class _LotesScreenState extends State<LotesScreen> {
  // Demo data – replace with a real LoteService/provider when available.
  final List<Lote> _lotes = [
    Lote(
      nome: 'Lote Primavera',
      quantidadeAnimais: 42,
      pesoMedio: 380,
      status: LoteStatus.ativo,
      observacoes: 'Pronto para rastreamento SISBOV',
    ),
    Lote(
      nome: 'Lote Verão',
      quantidadeAnimais: 18,
      pesoMedio: 290,
      status: LoteStatus.transferido,
      observacoes: 'Transferido para a Fazenda Sul',
    ),
    Lote(
      nome: 'Lote Inverno',
      quantidadeAnimais: 65,
      pesoMedio: 410,
      status: LoteStatus.ativo,
    ),
    Lote(
      nome: 'Lote Exportação',
      quantidadeAnimais: 30,
      pesoMedio: 450,
      status: LoteStatus.vendido,
      observacoes: 'Vendido para frigorífico parceiro',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Lotes'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),

            // ── Header ──────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF7B1FA2).withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF7B1FA2).withAlpha(60)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B1FA2).withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.layers,
                        color: Color(0xFF7B1FA2), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meus Lotes',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF7B1FA2),
                        ),
                      ),
                      Text(
                        '${_lotes.length} lotes cadastrados',
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

            // ── Lot cards ────────────────────────────────────────────────
            ..._lotes.map(
              (lote) => LoteCard(
                lote: lote,
                onVerDetalhes: () => _showDetails(context, lote),
                onGerenciar: () => _showManage(context, lote),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _novoLote(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo Lote'),
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showDetails(BuildContext context, Lote lote) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _LoteDetailSheet(lote: lote),
    );
  }

  void _showManage(BuildContext context, Lote lote) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gerenciando: ${lote.nome}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _novoLote(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Novo lote em breve!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ── Bottom sheet with lot details ────────────────────────────────────────────

class _LoteDetailSheet extends StatelessWidget {
  final Lote lote;
  const _LoteDetailSheet({required this.lote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            lote.nome,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _DetailRow(
              icon: Icons.pets,
              label: 'Animais',
              value: '${lote.quantidadeAnimais}'),
          _DetailRow(
              icon: Icons.monitor_weight,
              label: 'Peso médio',
              value: '${lote.pesoMedio.toStringAsFixed(0)} kg'),
          _DetailRow(
              icon: Icons.circle,
              label: 'Status',
              value: lote.status.label),
          _DetailRow(
              icon: Icons.calendar_today,
              label: 'Criado em',
              value:
                  '${lote.dataCriacao.day}/${lote.dataCriacao.month}/${lote.dataCriacao.year}'),
          if (lote.observacoes.isNotEmpty)
            _DetailRow(
                icon: Icons.notes,
                label: 'Observações',
                value: lote.observacoes),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 10),
          Text('$label: ',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
