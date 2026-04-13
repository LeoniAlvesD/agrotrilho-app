import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';
import '../widgets/qrcode_widget.dart';
import '../utils/constants.dart';
import 'cadastro_animal.dart';

/// Tela de detalhes do animal com QR Code e informações completas
class DetalheAnimal extends StatelessWidget {
  final String animalId;

  const DetalheAnimal({super.key, required this.animalId});

  /// Confirma e remove o animal
  void _confirmarRemocao(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppMessages.remover),
        content: Text('${AppMessages.confirmarDelete}\n\n"${animal.nome}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppMessages.cancelar),
          ),
          TextButton(
            onPressed: () {
              context.read<AnimalService>().remover(animal.id);
              Navigator.pop(ctx); // fecha o dialog
              Navigator.pop(context); // volta para a lista
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppMessages.deletado),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text(AppMessages.remover),
          ),
        ],
      ),
    );
  }

  /// Abre a tela de edição
  void _editarAnimal(BuildContext context, Animal animal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroAnimal(animal: animal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimalService>(
      builder: (context, service, _) {
        final animal = service.buscarPorId(animalId);

        if (animal == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(AppMessages.detalhes)),
            body: const Center(
              child: Text(AppMessages.animalNaoEncontrado),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(animal.nome),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: AppMessages.editar,
                onPressed: () => _editarAnimal(context, animal),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: AppMessages.remover,
                onPressed: () => _confirmarRemocao(context, animal),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ícone principal
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryGreen,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 56,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                // Nome do animal
                Text(
                  animal.nome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium,
                    vertical: AppDimensions.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: animal.status == AnimalStatus.ativo
                        ? AppColors.lightGreen.withValues(alpha: 0.2)
                        : AppColors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    animal.status,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: animal.status == AnimalStatus.ativo
                          ? AppColors.primaryGreen
                          : AppColors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),
                // Informações do animal
                _buildInfoCard(context, animal),
                const SizedBox(height: AppDimensions.paddingMedium),
                // QR Code
                _buildQRCodeSection(animal),
                const SizedBox(height: AppDimensions.paddingMedium),
                // NFC Tag
                _buildNFCSection(animal),
                const SizedBox(height: AppDimensions.paddingLarge),
                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editarAnimal(context, animal),
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                          side: const BorderSide(color: AppColors.primaryGreen),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmarRemocao(context, animal),
                        icon: const Icon(Icons.delete),
                        label: const Text('Remover'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red,
                          side: const BorderSide(color: AppColors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Card com informações detalhadas do animal
  Widget _buildInfoCard(BuildContext context, Animal animal) {
    return Card(
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Idade', animal.idadeFormatada),
            _buildInfoRow(Icons.monitor_weight, 'Peso', animal.pesoFormatado),
            _buildInfoRow(Icons.event, 'Cadastro', animal.dataCadastroFormatada),
            if (animal.observacoes.isNotEmpty)
              _buildInfoRow(Icons.notes, 'Observações', animal.observacoes),
          ],
        ),
      ),
    );
  }

  /// Linha de informação individual
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreen),
          const SizedBox(width: AppDimensions.paddingSmall),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  /// Seção do QR Code
  Widget _buildQRCodeSection(Animal animal) {
    return Card(
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            const Text(
              'QR Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            QRCodeWidget(data: animal.qrCodeData),
          ],
        ),
      ),
    );
  }

  /// Seção de informações NFC
  Widget _buildNFCSection(Animal animal) {
    return Card(
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tag NFC',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            const Divider(),
            Row(
              children: [
                Icon(
                  Icons.nfc,
                  size: 24,
                  color: animal.nfcTagId != null
                      ? AppColors.primaryGreen
                      : AppColors.grey,
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Expanded(
                  child: Text(
                    animal.nfcTagId != null
                        ? 'Tag: ${animal.nfcTagId}'
                        : 'Nenhuma tag NFC associada',
                    style: TextStyle(
                      fontSize: 14,
                      color: animal.nfcTagId != null
                          ? Colors.grey[800]
                          : AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
