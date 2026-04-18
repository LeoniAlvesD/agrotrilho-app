import 'package:flutter/material.dart';
import '../models/sanitary_event.dart';
import '../utils/constants.dart';

/// Card de linha do tempo para exibir um evento sanitário.
class SanitaryEventCard extends StatelessWidget {
  final SanitaryEvent event;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SanitaryEventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onDelete,
  });

  static IconData iconForTipo(TipoEventoSanitario tipo) {
    switch (tipo) {
      case TipoEventoSanitario.vacinacao:
        return Icons.vaccines;
      case TipoEventoSanitario.exameDiagnostico:
        return Icons.biotech;
      case TipoEventoSanitario.tratamento:
        return Icons.healing;
      case TipoEventoSanitario.movimentacao:
        return Icons.swap_horiz;
      case TipoEventoSanitario.ocorrencia:
        return Icons.report_problem;
    }
  }

  static Color colorForTipo(TipoEventoSanitario tipo) {
    switch (tipo) {
      case TipoEventoSanitario.vacinacao:
        return Colors.green;
      case TipoEventoSanitario.exameDiagnostico:
        return Colors.blue;
      case TipoEventoSanitario.tratamento:
        return Colors.orange;
      case TipoEventoSanitario.movimentacao:
        return Colors.purple;
      case TipoEventoSanitario.ocorrencia:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = colorForTipo(event.tipo);
    final icon = iconForTipo(event.tipo);
    final label = event.tipo.label;
    final data =
        '${event.data.day.toString().padLeft(2, '0')}/${event.data.month.toString().padLeft(2, '0')}/${event.data.year}';

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
        horizontal: AppSpacing.md,
      ),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              label,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            data,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        event.descricao,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (event.responsavelTecnico.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(Icons.person_outline,
                                size: 14,
                                color: colorScheme.onSurfaceVariant),
                            SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                event.responsavelTecnico,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (event.documento.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(Icons.description_outlined,
                                size: 14,
                                color: colorScheme.onSurfaceVariant),
                            SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                'GTA/Doc: ${event.documento}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (event.resultado.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(Icons.science_outlined,
                                size: 14,
                                color: colorScheme.onSurfaceVariant),
                            SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                'Resultado: ${event.resultado}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (onDelete != null) ...[
                  SizedBox(width: AppSpacing.xs),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: colorScheme.error,
                    ),
                    tooltip: 'Remover evento',
                    onPressed: onDelete,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
