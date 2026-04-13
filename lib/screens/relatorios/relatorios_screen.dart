import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/animal.dart';
import '../../services/animal_service.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/stat_widget.dart';

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AnimalService>(
      builder: (context, service, _) {
        final animais = service.animais;
        final total = animais.length;
        final pesoTotal = animais.fold<double>(0, (s, a) => s + a.peso);
        final idadeMedia = total > 0
            ? animais.fold<int>(0, (s, a) => s + a.idade) / total
            : 0.0;
        final pesoMedio = total > 0 ? pesoTotal / total : 0.0;

        final maxPeso = animais.isEmpty
            ? 1.0
            : animais
                .map((a) => a.peso)
                .reduce((a, b) => a > b ? a : b);

        return SingleChildScrollView(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Relatórios do Rebanho',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Estatísticas e análise dos animais cadastrados',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              StatsCard(
                title: 'Resumo Geral',
                children: [
                  _buildSummaryRow(
                    context,
                    'Total de Animais',
                    '$total',
                    Icons.pets,
                  ),
                  _buildSummaryRow(
                    context,
                    'Peso Total',
                    '${pesoTotal.toStringAsFixed(1)} kg',
                    Icons.monitor_weight,
                  ),
                  _buildSummaryRow(
                    context,
                    'Peso Médio',
                    '${pesoMedio.toStringAsFixed(1)} kg',
                    Icons.scale,
                  ),
                  _buildSummaryRow(
                    context,
                    'Idade Média',
                    '${idadeMedia.toStringAsFixed(1)} meses',
                    Icons.calendar_today,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (animais.isNotEmpty) ...[
                StatsCard(
                  title: 'Distribuição por Peso',
                  children: animais
                      .map(
                        (a) => StatWidget(
                          label: a.nome,
                          value: '${a.peso} kg',
                          fraction: a.peso / maxPeso,
                          color: colorScheme.primary,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                StatsCard(
                  title: 'Distribuição por Idade',
                  children: _buildIdadeStats(animais),
                ),
              ],
              if (animais.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.bar_chart,
                          size: 80,
                          color: colorScheme.onSurfaceVariant.withAlpha(80),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum dado para exibir',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cadastre animais para ver relatórios',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                colorScheme.onSurfaceVariant.withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildIdadeStats(List<Animal> animais) {
    final maxIdade = animais
        .map((a) => a.idade)
        .reduce((a, b) => a > b ? a : b);
    return animais
        .map(
          (a) => StatWidget(
            label: a.nome,
            value: '${a.idade} ${a.idade == 1 ? 'mês' : 'meses'}',
            fraction: maxIdade > 0 ? a.idade / maxIdade : 0,
            color: Colors.blue,
          ),
        )
        .toList();
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
