import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../screens/detalhe_animal.dart';
import '../utils/constants.dart';

/// Card reutilizável para exibir informações resumidas de um animal
class AnimalCard extends StatelessWidget {
  final Animal animal;

  const AnimalCard({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingSmall,
        horizontal: AppDimensions.paddingMedium,
      ),
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalheAnimal(animalId: animal.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Row(
            children: [
              // Ícone do animal
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.backgroundGreen,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: const Icon(
                  Icons.pets,
                  color: AppColors.primaryGreen,
                  size: AppDimensions.iconSize,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              // Informações do animal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.nome,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${animal.idadeFormatada} • ${animal.pesoFormatado}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSmall,
                  vertical: 4,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: animal.status == AnimalStatus.ativo
                        ? AppColors.primaryGreen
                        : AppColors.grey,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              const Icon(
                Icons.chevron_right,
                color: AppColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}