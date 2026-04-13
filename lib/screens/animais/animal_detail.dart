import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/animal.dart';
import '../../services/animal_service.dart';
import '../../utils/constants.dart';
import '../../widgets/qr_display_widget.dart';
import 'animal_form.dart';

class AnimalDetail extends StatelessWidget {
  final Animal animal;

  const AnimalDetail({super.key, required this.animal});

  void _editarAnimal(BuildContext context) async {
    final atualizado = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (_) => AnimalForm(animal: animal),
      ),
    );

    if (atualizado != null && context.mounted) {
      context.read<AnimalService>().atualizar(atualizado);
      Navigator.pop(context);
    }
  }

  void _deletarAnimal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir "${animal.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final messenger = ScaffoldMessenger.of(context);
              context.read<AnimalService>().remover(animal.id);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
              messenger.showSnackBar(
                SnackBar(
                  content: Text('${animal.nome} removido.'),
                  backgroundColor: Colors.red[700],
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animal.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => _editarAnimal(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir',
            onPressed: () => _deletarAnimal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Hero(
              tag: 'animal-icon-${animal.id}',
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.pets,
                  color: AppColors.primary,
                  size: 44,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              animal.nome,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ID: ${animal.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildInfoCard(),
            const SizedBox(height: AppSpacing.lg),
            if (animal.observacoes.isNotEmpty) ...[
              _buildObservacoesCard(),
              const SizedBox(height: AppSpacing.lg),
            ],
            QrDisplayWidget(data: animal.id),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
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
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Text(
                    'Informações',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Divider(height: 1),
            ),
            _buildInfoRow(
              Icons.monitor_weight,
              'Peso',
              '${animal.peso} kg',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildInfoRow(
              Icons.calendar_today,
              'Idade',
              '${animal.idade} ${animal.idade == 1 ? 'mês' : 'meses'}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildObservacoesCard() {
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
                    Icons.notes,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Text(
                    'Observações',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Divider(height: 1),
            ),
            Text(
              animal.observacoes,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
