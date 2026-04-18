import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/sanitary_event.dart';
import '../../services/animal_service.dart';
import '../../services/sanitary_service.dart';
import '../../utils/constants.dart';
import '../../widgets/sanitary_event_card.dart';

/// Tela de relatório sanitário com filtros por período e tipo.
///
/// Permite exportar os dados como CSV para copiar/compartilhar.
class SanitaryReportScreen extends StatefulWidget {
  const SanitaryReportScreen({super.key});

  @override
  State<SanitaryReportScreen> createState() => _SanitaryReportScreenState();
}

class _SanitaryReportScreenState extends State<SanitaryReportScreen> {
  DateTime? _inicio;
  DateTime? _fim;
  TipoEventoSanitario? _tipoFiltro;

  Future<void> _selecionarInicio() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _inicio ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: _fim ?? DateTime.now(),
      helpText: 'Data inicial do período',
    );
    if (picked != null) setState(() => _inicio = picked);
  }

  Future<void> _selecionarFim() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fim ?? DateTime.now(),
      firstDate: _inicio ?? DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Data final do período',
    );
    if (picked != null) setState(() => _fim = picked);
  }

  void _limparFiltros() {
    setState(() {
      _inicio = null;
      _fim = null;
      _tipoFiltro = null;
    });
  }

  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  void _exportarCsv(BuildContext context, SanitaryService sanitaryService,
      AnimalService animalService) {
    final nomeAnimais = {
      for (final a in animalService.animais) a.id: a.nome,
    };
    final csv = sanitaryService.gerarCsv(
      inicio: _inicio,
      fim: _fim,
      tipo: _tipoFiltro,
      nomeAnimais: nomeAnimais,
    );

    Clipboard.setData(ClipboardData(text: csv));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('CSV copiado para a área de transferência!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório Sanitário'),
        actions: [
          if (_inicio != null || _fim != null || _tipoFiltro != null)
            TextButton.icon(
              onPressed: _limparFiltros,
              icon: const Icon(Icons.filter_alt_off, color: Colors.white),
              label: const Text('Limpar',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Consumer2<SanitaryService, AnimalService>(
        builder: (context, sanitaryService, animalService, _) {
          final nomeAnimais = {
            for (final a in animalService.animais) a.id: a.nome,
          };
          final eventos = sanitaryService.filtrar(
            inicio: _inicio,
            fim: _fim,
            tipo: _tipoFiltro,
          );

          return Column(
            children: [
              // Filtros
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.outlineVariant,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filtros',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _DateChip(
                            label: _inicio != null
                                ? 'De: ${_formatarData(_inicio!)}'
                                : 'Data inicial',
                            icon: Icons.calendar_today,
                            onTap: _selecionarInicio,
                            selected: _inicio != null,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _DateChip(
                            label: _fim != null
                                ? 'Até: ${_formatarData(_fim!)}'
                                : 'Data final',
                            icon: Icons.calendar_month,
                            onTap: _selecionarFim,
                            selected: _fim != null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    // Filtro por tipo
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('Todos'),
                            selected: _tipoFiltro == null,
                            onSelected: (_) =>
                                setState(() => _tipoFiltro = null),
                            avatar: const Icon(Icons.list, size: 16),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          ...TipoEventoSanitario.values.map((tipo) {
                            final selected = _tipoFiltro == tipo;
                            final color =
                                SanitaryEventCard.colorForTipo(tipo);
                            return Padding(
                              padding:
                                  EdgeInsets.only(right: AppSpacing.sm),
                              child: FilterChip(
                                avatar: Icon(
                                  SanitaryEventCard.iconForTipo(tipo),
                                  size: 16,
                                  color: selected ? Colors.white : color,
                                ),
                                label: Text(tipo.label),
                                selected: selected,
                                onSelected: (_) => setState(() =>
                                    _tipoFiltro = selected ? null : tipo),
                                selectedColor: color,
                                labelStyle: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : colorScheme.onSurface,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Resumo + botão exportar
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${eventos.length} ${eventos.length == 1 ? 'evento encontrado' : 'eventos encontrados'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    if (eventos.isNotEmpty)
                      FilledButton.tonalIcon(
                        onPressed: () => _exportarCsv(
                            context, sanitaryService, animalService),
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Exportar CSV'),
                      ),
                  ],
                ),
              ),

              const Divider(height: 1),

              if (eventos.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: colorScheme.onSurfaceVariant.withAlpha(80),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Text(
                          'Nenhum evento encontrado',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Ajuste os filtros para ampliar a busca.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant
                                .withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      top: AppSpacing.sm,
                      bottom: AppSpacing.xxl,
                    ),
                    itemCount: eventos.length,
                    itemBuilder: (context, index) {
                      final event = eventos[index];
                      final nomeAnimal =
                          nomeAnimais[event.animalId] ?? event.animalId;
                      return _ReportEventTile(
                        event: event,
                        nomeAnimal: nomeAnimal,
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

class _DateChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const _DateChip({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withAlpha(20)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant),
            SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportEventTile extends StatelessWidget {
  final SanitaryEvent event;
  final String nomeAnimal;

  const _ReportEventTile({
    required this.event,
    required this.nomeAnimal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = SanitaryEventCard.colorForTipo(event.tipo);
    final icon = SanitaryEventCard.iconForTipo(event.tipo);
    final data =
        '${event.data.day.toString().padLeft(2, '0')}/${event.data.month.toString().padLeft(2, '0')}/${event.data.year}';

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: AppSpacing.xs, horizontal: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nomeAnimal,
                            style: theme.textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          data,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm, vertical: 1),
                          decoration: BoxDecoration(
                            color: color.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            event.tipo.label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      event.descricao,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (event.documento.isNotEmpty) ...[
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        'GTA/Doc: ${event.documento}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
