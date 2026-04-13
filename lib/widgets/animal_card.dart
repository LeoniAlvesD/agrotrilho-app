import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../utils/constants.dart';

class AnimalCard extends StatefulWidget {
  final Animal animal;
  final VoidCallback? onTap;

  const AnimalCard({super.key, required this.animal, this.onTap});

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: AppSpacing.xs, horizontal: AppSpacing.md),
      child: Semantics(
        label:
            '${widget.animal.nome}, ${widget.animal.peso} kg, ${widget.animal.idade} ${widget.animal.idade == 1 ? 'mês' : 'meses'}',
        button: widget.onTap != null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: _pressed ? 0.98 : 1.0,
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.onTap,
              onHighlightChanged: (v) => setState(() => _pressed = v),
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
                            widget.animal.nome,
                            style: theme.textTheme.titleMedium,
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            '${widget.animal.peso} kg  •  ${widget.animal.idade} ${widget.animal.idade == 1 ? 'mês' : 'meses'}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}