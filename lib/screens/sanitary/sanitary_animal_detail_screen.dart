import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/animal.dart';
import '../../models/sanitary_event.dart';
import '../../services/sanitary_service.dart';
import '../../utils/constants.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/sanitary_event_card.dart';
import 'sanitary_event_form_screen.dart';

/// Tela de histórico sanitário de um animal específico.
///
/// Exibe a linha do tempo de eventos sanitários ordenada do mais recente
/// ao mais antigo, conforme exigido pelo PNIB/SISBOV para rastreabilidade
/// individual.
class SanitaryAnimalDetailScreen extends StatelessWidget {
  final Animal animal;

  const SanitaryAnimalDetailScreen({super.key, required this.animal});

  void _adicionarEvento(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SanitaryEventFormScreen(
          animalId: animal.id,
          animalNome: animal.nome,
        ),
      ),
    );
  }

  void _editarEvento(BuildContext context, SanitaryEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SanitaryEventFormScreen(
          animalId: animal.id,
          animalNome: animal.nome,
          event: event,
        ),
      ),
    );
  }

  void _confirmarRemocao(BuildContext context, SanitaryEvent event) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remover evento'),
        content: Text(
          'Deseja remover o evento "${event.descricao}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<SanitaryService>().remover(event.id);
              Navigator.pop(dialogContext);
            },
            style:
                TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: const Text('Remover'),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(animal.nome),
            Text(
              'Histórico Sanitário',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _adicionarEvento(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo Evento'),
        tooltip: 'Registrar evento sanitário',
      ),
      body: Consumer<SanitaryService>(
        builder: (context, service, _) {
          final eventos = service.porAnimal(animal.id);

          if (eventos.isEmpty) {
            return Center(
              child: Padding(
                padding: ResponsiveHelper.getPadding(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.health_and_safety_outlined,
                      size: 80,
                      color: colorScheme.onSurfaceVariant.withAlpha(80),
                      semanticLabel: 'Sem eventos sanitários',
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Text(
                      'Nenhum evento sanitário registrado',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Toque em "Novo Evento" para iniciar o\nhistórico sanitário de ${animal.nome}.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Banner informativo
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                color: colorScheme.primary.withAlpha(15),
                child: Row(
                  children: [
                    Icon(Icons.timeline,
                        color: colorScheme.primary, size: 18),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      '${eventos.length} ${eventos.length == 1 ? 'evento registrado' : 'eventos registrados'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    top: AppSpacing.sm,
                    bottom: 80,
                  ),
                  itemCount: eventos.length,
                  itemBuilder: (context, index) {
                    final event = eventos[index];
                    return SanitaryEventCard(
                      event: event,
                      onTap: () => _editarEvento(context, event),
                      onDelete: () => _confirmarRemocao(context, event),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
