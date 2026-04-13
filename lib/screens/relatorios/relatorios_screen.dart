import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/animal.dart';
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
              const SizedBox(height: AppSpacing.sm),
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),
              StatsCard(
                title: 'Resumo Geral',
                icon: Icons.analytics_outlined,
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
              const SizedBox(height: AppSpacing.lg),
              if (animais.isNotEmpty) ...[
                StatsCard(
                  title: 'Distribuição por Peso',
                  icon: Icons.monitor_weight_outlined,
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
                const SizedBox(height: AppSpacing.lg),
                StatsCard(
                  title: 'Distribuição por Idade',
                  icon: Icons.calendar_month_outlined,
                  children: _buildIdadeStats(animais),
                ),
              ],
              if (animais.isEmpty) _buildEmptyState(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.info.withAlpha(20),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.bar_chart_rounded,
            color: AppColors.info,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Relatórios do Rebanho',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Estatísticas e análise dos animais',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.info.withAlpha(15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.bar_chart,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Nenhum dado para exibir',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Cadastre animais para ver relatórios',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
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
            color: AppColors.info,
          ),
        )
        .toList();
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
