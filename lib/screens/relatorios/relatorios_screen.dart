import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/animal_service.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/stat_widget.dart';

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Relatórios do Rebanho',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Estatísticas e análise dos animais cadastrados',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              StatsCard(
                title: 'Resumo Geral',
                children: [
                  _buildSummaryRow(
                    'Total de Animais',
                    '$total',
                    Icons.pets,
                  ),
                  _buildSummaryRow(
                    'Peso Total',
                    '${pesoTotal.toStringAsFixed(1)} kg',
                    Icons.monitor_weight,
                  ),
                  _buildSummaryRow(
                    'Peso Médio',
                    '${pesoMedio.toStringAsFixed(1)} kg',
                    Icons.scale,
                  ),
                  _buildSummaryRow(
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
                          color: AppColors.primary,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                StatsCard(
                  title: 'Distribuição por Idade',
                  children: animais.map((a) {
                    final maxIdade = animais
                        .map((x) => x.idade)
                        .reduce((a, b) => a > b ? a : b);
                    return StatWidget(
                      label: a.nome,
                      value:
                          '${a.idade} ${a.idade == 1 ? 'mês' : 'meses'}',
                      fraction:
                          maxIdade > 0 ? a.idade / maxIdade : 0,
                      color: Colors.blue,
                    );
                  }).toList(),
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
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum dado para exibir',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cadastre animais para ver relatórios',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
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

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
