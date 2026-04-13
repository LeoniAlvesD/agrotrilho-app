import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/animal_service.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/responsive_grid.dart';
import '../animais/animal_form.dart';
import '../../models/animal.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<AnimalService>(
      builder: (context, service, _) {
        final animais = service.animais;
        final totalAnimais = animais.length;
        final pesoTotal = animais.fold<double>(
          0,
          (sum, a) => sum + a.peso,
        );
        final idadeMedia = totalAnimais > 0
            ? (animais.fold<int>(0, (sum, a) => sum + a.idade) / totalAnimais)
                .toStringAsFixed(1)
            : '0';

        return SingleChildScrollView(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.sm),
              Semantics(
                header: true,
                child: Text(
                  '${AppStrings.greeting}, ${AppStrings.producerName}!',
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.dashboardSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              ResponsiveGrid(
                children: [
                  DashboardCard(
                    icon: Icons.pets,
                    title: AppStrings.totalAnimais,
                    value: '$totalAnimais',
                    color: colorScheme.primary,
                    semanticLabel:
                        '${AppStrings.totalAnimais}: $totalAnimais',
                  ),
                  DashboardCard(
                    icon: Icons.monitor_weight,
                    title: AppStrings.pesoTotal,
                    value: pesoTotal.toStringAsFixed(1),
                    color: AppColors.accent,
                    semanticLabel:
                        '${AppStrings.pesoTotal}: ${pesoTotal.toStringAsFixed(1)}',
                  ),
                  DashboardCard(
                    icon: Icons.calendar_today,
                    title: AppStrings.idadeMedia,
                    value: idadeMedia,
                    color: AppColors.info,
                    semanticLabel:
                        '${AppStrings.idadeMedia}: $idadeMedia',
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _abrirCadastro(context, service),
                  icon: const Icon(Icons.add),
                  label: Text(AppStrings.cadastrarAnimal),
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              if (animais.isNotEmpty)
                _buildRecentAnimals(context, animais)
              else
                _buildEmptyState(context),
            ],
          ),
        );
      },
    );
  }

  void _abrirCadastro(BuildContext context, AnimalService service) async {
    final novoAnimal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(builder: (_) => const AnimalForm()),
    );

    if (novoAnimal != null && context.mounted) {
      service.adicionar(novoAnimal);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          children: [
            Icon(
              Icons.pets,
              size: 80,
              color: colorScheme.onSurfaceVariant.withAlpha(80),
              semanticLabel: AppStrings.nenhumAnimal,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.nenhumAnimal,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.toqueNovo,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAnimals(BuildContext context, List<Animal> animais) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final recent = animais.length > 3 ? animais.sublist(0, 3) : animais;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history,
                    color: colorScheme.primary,
                    semanticLabel: AppStrings.animaisRecentes),
                SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.animaisRecentes,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const Divider(),
            ...recent.map(
              (animal) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.pets,
                    color: colorScheme.primary,
                    size: 24,
                    semanticLabel: animal.nome,
                  ),
                ),
                title: Text(animal.nome),
                subtitle: Text(
                  '${animal.peso} kg • ${animal.idade} ${animal.idade == 1 ? 'mês' : 'meses'}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
