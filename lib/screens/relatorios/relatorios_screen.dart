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
            : animais.map((a) => a.peso).reduce((a, b) => a > b ? a : b);

        return SingleChildScrollView(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.sm),
              Semantics(
                header: true,
                child: Text(
                  AppStrings.relatoriosTitulo,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.relatoriosSubtitulo,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              StatsCard(
                title: AppStrings.resumoGeral,
                children: [
                  _buildSummaryRow(
                    context,
                    AppStrings.totalAnimais,
                    '$total',
                    Icons.pets,
                  ),
                  _buildSummaryRow(
                    context,
                    AppStrings.pesoTotal,
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
                    AppStrings.idadeMedia,
                    '${idadeMedia.toStringAsFixed(1)} meses',
                    Icons.calendar_today,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              if (animais.isNotEmpty) ...[
                StatsCard(
                  title: AppStrings.distribuicaoPeso,
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
                SizedBox(height: AppSpacing.lg),
                StatsCard(
                  title: AppStrings.distribuicaoIdade,
                  children: _buildIdadeStats(animais),
                ),
              ],
              if (animais.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xxxl),
                    child: Column(
                      children: [
                        Icon(
                          Icons.bar_chart,
                          size: 80,
                          color: colorScheme.onSurfaceVariant.withAlpha(80),
                          semanticLabel: AppStrings.nenhumDado,
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Text(
                          AppStrings.nenhumDado,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          AppStrings.cadastreAnimais,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                colorScheme.onSurfaceVariant.withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildIdadeStats(List<Animal> animais) {
    final maxIdade =
        animais.map((a) => a.idade).reduce((a, b) => a > b ? a : b);
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

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 22,
              semanticLabel: label),
          SizedBox(width: AppSpacing.md),
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
