import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';
import '../utils/constants.dart';
import '../widgets/qr_display_widget.dart';
import 'cadastro_animal.dart';

class DetalheAnimal extends StatelessWidget {
  final Animal animal;

  const DetalheAnimal({super.key, required this.animal});

  void _editarAnimal(BuildContext context) async {
    final atualizado = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroAnimal(animal: animal),
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
              context.read<AnimalService>().remover(animal.id);
              Navigator.pop(dialogContext);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${animal.nome} removido.'),
                  backgroundColor: Colors.red[700],
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.pets,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              animal.nome,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(),
            const SizedBox(height: 16),
            if (animal.observacoes.isNotEmpty) ...[
              _buildObservacoesCard(),
              const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildInfoRow(
              Icons.monitor_weight,
              'Peso',
              '${animal.peso} kg',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              'Idade',
              '${animal.idade} ${animal.idade == 1 ? 'mês' : 'meses'}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.fingerprint,
              'ID',
              animal.id.substring(0, 8).toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildObservacoesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notes, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Observações',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              animal.observacoes,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
