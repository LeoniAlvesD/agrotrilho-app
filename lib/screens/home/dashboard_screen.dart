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
              const SizedBox(height: 8),
              Text(
                'Olá, ${AppStrings.producerName}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Resumo do seu rebanho',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
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
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _abrirCadastro(context, service),
                  icon: const Icon(Icons.add),
                  label: const Text('Cadastrar Novo Animal'),
                ),
              ),
              const SizedBox(height: 24),
              if (animais.isNotEmpty) _buildRecentAnimals(context, animais),
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

  Widget _buildRecentAnimals(BuildContext context, List<Animal> animais) {
    final recent = animais.length > 3 ? animais.sublist(0, 3) : animais;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Animais Recentes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.pets,
                    color: AppColors.primary,
                    size: 24,
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
