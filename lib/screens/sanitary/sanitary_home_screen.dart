import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/animal.dart';
import '../../services/animal_service.dart';
import '../../services/sanitary_service.dart';
import '../../utils/constants.dart';
import '../../widgets/sanitary_event_card.dart';
import 'sanitary_animal_detail_screen.dart';
import 'sanitary_report_screen.dart';

/// Tela principal do módulo de Controle Sanitário.
///
/// Lista todos os animais cadastrados com o respectivo contador de eventos
/// sanitários registrados. Alinhado às exigências do PNIB/SISBOV de
/// rastreabilidade individual por animal.
class SanitaryHomeScreen extends StatefulWidget {
  const SanitaryHomeScreen({super.key});

  @override
  State<SanitaryHomeScreen> createState() => _SanitaryHomeScreenState();
}

class _SanitaryHomeScreenState extends State<SanitaryHomeScreen> {
  final TextEditingController _buscaController = TextEditingController();
  String _filtro = '';

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  void _abrirHistorico(BuildContext context, Animal animal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SanitaryAnimalDetailScreen(animal: animal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SanitaryReportScreen(),
            ),
          );
        },
        icon: const Icon(Icons.bar_chart),
        label: const Text('Relatório'),
        tooltip: 'Abrir relatório sanitário',
      ),
      body: Consumer2<AnimalService, SanitaryService>(
        builder: (context, animalService, sanitaryService, _) {
          final animais = animalService.buscar(_filtro);

          return Column(
            children: [
            // Cabeçalho PNIB
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withAlpha(200),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.health_and_safety,
                          color: Colors.white, size: 28),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Controle Sanitário – PNIB/SISBOV',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Rastreabilidade individual conforme o Plano Nacional de Identificação Individual de Bovinos e Búfalos.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),

            // Busca
            Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs),
              child: TextField(
                controller: _buscaController,
                decoration: InputDecoration(
                  hintText: 'Buscar animal por nome...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _filtro.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'Limpar busca',
                          onPressed: () {
                            _buscaController.clear();
                            setState(() => _filtro = '');
                          },
                        )
                      : null,
                ),
                onChanged: (v) => setState(() => _filtro = v),
              ),
            ),

            if (animais.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets,
                        size: 80,
                        color: colorScheme.onSurfaceVariant.withAlpha(80),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        _filtro.isEmpty
                            ? 'Nenhum animal cadastrado'
                            : 'Nenhum animal encontrado',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (_filtro.isEmpty) ...[
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Cadastre animais na seção "Animais" para\ngerenciar o controle sanitário.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                colorScheme.onSurfaceVariant.withAlpha(180),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else ...[
              // Contagem
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.lg),
                color: colorScheme.primary.withAlpha(15),
                child: Text(
                  '${animais.length} ${animais.length == 1 ? 'animal' : 'animais'} — toque para ver o histórico',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  itemCount: animais.length,
                  itemBuilder: (context, index) {
                    final animal = animais[index];
                    final count =
                        sanitaryService.contarPorAnimal(animal.id);
                    return _AnimalSanitaryTile(
                      animal: animal,
                      eventCount: count,
                      onTap: () => _abrirHistorico(context, animal),
                    );
                  },
                ),
              ),
            ],
          ],
          );
        },
      ),
    );
  }
}

class _AnimalSanitaryTile extends StatelessWidget {
  final Animal animal;
  final int eventCount;
  final VoidCallback onTap;

  const _AnimalSanitaryTile({
    required this.animal,
    required this.eventCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: AppSpacing.xs, horizontal: AppSpacing.md),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.pets,
                    color: colorScheme.primary,
                    size: 32,
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        animal.nome,
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        '${animal.peso} kg  •  ${animal.idade} ${animal.idade == 1 ? 'mês' : 'meses'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge de eventos sanitários
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: eventCount > 0
                            ? Colors.green.withAlpha(30)
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: eventCount > 0
                              ? Colors.green.withAlpha(100)
                              : colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.health_and_safety,
                            size: 14,
                            color: eventCount > 0
                                ? Colors.green
                                : colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            '$eventCount',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: eventCount > 0
                                  ? Colors.green
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'eventos',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
