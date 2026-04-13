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
              const SizedBox(height: AppSpacing.sm),
              _buildGreetingSection(),
              const SizedBox(height: AppSpacing.xl),
              ResponsiveGrid(
                children: [
                  DashboardCard(
                    icon: Icons.pets,
                    title: 'Total de Animais',
                    value: '$totalAnimais',
                    color: AppColors.primary,
                  ),
                  DashboardCard(
                    icon: Icons.monitor_weight,
                    title: 'Peso Total (kg)',
                    value: pesoTotal.toStringAsFixed(1),
                    color: AppColors.accent,
                  ),
                  DashboardCard(
                    icon: Icons.calendar_today,
                    title: 'Idade Média (meses)',
                    value: idadeMedia,
                    color: AppColors.info,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _abrirCadastro(context, service),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Cadastrar Novo Animal'),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (animais.isNotEmpty)
                _buildRecentAnimals(context, animais)
              else
                _buildEmptyState(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.waving_hand,
                color: AppColors.accent,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, ${AppStrings.producerName}!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Resumo do seu rebanho',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                color: AppColors.primary.withAlpha(15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.pets,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Nenhum animal cadastrado',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Comece cadastrando seu primeiro animal',
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

  void _abrirCadastro(BuildContext context, AnimalService service) async {
    final novoAnimal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(builder: (_) => const AnimalForm()),
    );

    if (novoAnimal != null && context.mounted) {
      service.adicionar(novoAnimal);
    }
  }

  Widget _buildRecentAnimals(BuildContext context, List<Animal> animais) {
    final recent = animais.length > 3 ? animais.sublist(0, 3) : animais;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Text(
                    'Animais Recentes',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${recent.length} de ${animais.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Divider(height: 1),
            ),
            ...recent.map(
              (animal) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.pets,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    animal.nome,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${animal.peso} kg • ${animal.idade} ${animal.idade == 1 ? 'mês' : 'meses'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
