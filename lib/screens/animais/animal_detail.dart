import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/animal.dart';
import '../../services/animal_service.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

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
                  backgroundColor: colorScheme.error,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(animal.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: () => _editarAnimal(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Excluir',
            onPressed: () => _deletarAnimal(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: ResponsiveHelper.getPadding(context),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.sm),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(AppSpacing.xl),
                  ),
                  child: Icon(
                    Icons.pets,
                    color: colorScheme.primary,
                    size: 48,
                    semanticLabel: animal.nome,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Text(
                  animal.nome,
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(height: AppSpacing.xxl),
                _buildInfoCard(context),
                SizedBox(height: AppSpacing.lg),
                if (animal.observacoes.isNotEmpty) ...[
                  _buildObservacoesCard(context),
                  SizedBox(height: AppSpacing.lg),
                ],
                QrDisplayWidget(data: animal.id),
                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informações', style: theme.textTheme.titleMedium),
            const Divider(),
            _buildInfoRow(
              context,
              Icons.monitor_weight,
              'Peso',
              '${animal.peso} kg',
            ),
            SizedBox(height: AppSpacing.md),
            _buildInfoRow(
              context,
              Icons.calendar_today,
              'Idade',
              '${animal.idade} ${animal.idade == 1 ? 'mês' : 'meses'}',
            ),
            SizedBox(height: AppSpacing.md),
            _buildInfoRow(
              context,
              Icons.fingerprint,
              'ID',
              animal.id.substring(0, 8).toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: '$label: $value',
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 22),
          SizedBox(width: AppSpacing.md),
          Text(
            '$label: ',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservacoesCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notes, color: colorScheme.primary),
                SizedBox(width: AppSpacing.sm),
                Text('Observações', style: theme.textTheme.titleMedium),
              ],
            ),
            const Divider(),
            Text(
              animal.observacoes,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
