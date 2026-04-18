import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/sanitary_event.dart';
import '../../services/sanitary_service.dart';
import '../../utils/constants.dart';
import '../../widgets/sanitary_event_card.dart';

/// Formulário para adicionar ou editar um evento sanitário.
class SanitaryEventFormScreen extends StatefulWidget {
  final String animalId;
  final String animalNome;
  final SanitaryEvent? event;

  const SanitaryEventFormScreen({
    super.key,
    required this.animalId,
    required this.animalNome,
    this.event,
  });

  @override
  State<SanitaryEventFormScreen> createState() =>
      _SanitaryEventFormScreenState();
}

class _SanitaryEventFormScreenState extends State<SanitaryEventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TipoEventoSanitario _tipo;
  late DateTime _data;
  late TextEditingController _descricaoController;
  late TextEditingController _responsavelController;
  late TextEditingController _documentoController;
  late TextEditingController _resultadoController;
  late TextEditingController _observacoesController;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _tipo = e?.tipo ?? TipoEventoSanitario.vacinacao;
    _data = e?.data ?? DateTime.now();
    _descricaoController =
        TextEditingController(text: e?.descricao ?? '');
    _responsavelController =
        TextEditingController(text: e?.responsavelTecnico ?? '');
    _documentoController =
        TextEditingController(text: e?.documento ?? '');
    _resultadoController =
        TextEditingController(text: e?.resultado ?? '');
    _observacoesController =
        TextEditingController(text: e?.observacoes ?? '');
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _responsavelController.dispose();
    _documentoController.dispose();
    _resultadoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Selecionar data do evento',
    );
    if (picked != null) {
      setState(() => _data = picked);
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final service = context.read<SanitaryService>();

    if (_isEditing) {
      service.atualizar(
        SanitaryEvent(
          id: widget.event!.id,
          animalId: widget.animalId,
          tipo: _tipo,
          data: _data,
          descricao: _descricaoController.text.trim(),
          responsavelTecnico: _responsavelController.text.trim(),
          documento: _documentoController.text.trim(),
          resultado: _resultadoController.text.trim(),
          observacoes: _observacoesController.text.trim(),
        ),
      );
    } else {
      service.adicionar(
        SanitaryEvent(
          animalId: widget.animalId,
          tipo: _tipo,
          data: _data,
          descricao: _descricaoController.text.trim(),
          responsavelTecnico: _responsavelController.text.trim(),
          documento: _documentoController.text.trim(),
          resultado: _resultadoController.text.trim(),
          observacoes: _observacoesController.text.trim(),
        ),
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dataFormatada =
        '${_data.day.toString().padLeft(2, '0')}/${_data.month.toString().padLeft(2, '0')}/${_data.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Evento' : 'Novo Evento Sanitário'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animal identificado
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.pets,
                            color: colorScheme.onPrimaryContainer, size: 20),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          'Animal: ${widget.animalNome}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Tipo de evento
                  Text('Tipo de Evento *',
                      style: theme.textTheme.labelLarge),
                  SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: TipoEventoSanitario.values.map((tipo) {
                      final selected = _tipo == tipo;
                      final color = SanitaryEventCard.colorForTipo(tipo);
                      return ChoiceChip(
                        avatar: Icon(
                          SanitaryEventCard.iconForTipo(tipo),
                          size: 18,
                          color: selected ? Colors.white : color,
                        ),
                        label: Text(tipo.label),
                        selected: selected,
                        onSelected: (_) => setState(() => _tipo = tipo),
                        selectedColor: color,
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : colorScheme.onSurface,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Data
                  Text('Data do Evento *',
                      style: theme.textTheme.labelLarge),
                  SizedBox(height: AppSpacing.sm),
                  InkWell(
                    onTap: _selecionarData,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: colorScheme.primary, size: 20),
                          SizedBox(width: AppSpacing.md),
                          Text(
                            dataFormatada,
                            style: theme.textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          Icon(Icons.edit_calendar_outlined,
                              color: colorScheme.onSurfaceVariant, size: 18),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Descrição
                  TextFormField(
                    controller: _descricaoController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição *',
                      hintText:
                          'Ex.: Vacinação contra febre aftosa – 1ª dose',
                      prefixIcon: Icon(Icons.notes),
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Informe a descrição do evento'
                            : null,
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Responsável técnico
                  TextFormField(
                    controller: _responsavelController,
                    decoration: const InputDecoration(
                      labelText: 'Responsável Técnico',
                      hintText: 'Nome do veterinário ou responsável',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Documento / GTA
                  TextFormField(
                    controller: _documentoController,
                    decoration: const InputDecoration(
                      labelText: 'Documento (GTA / Nº)',
                      hintText: 'Ex.: GTA 12345/2024',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Resultado (visível principalmente para exames)
                  if (_tipo == TipoEventoSanitario.exameDiagnostico) ...[
                    TextFormField(
                      controller: _resultadoController,
                      decoration: const InputDecoration(
                        labelText: 'Resultado do Exame',
                        hintText: 'Ex.: Negativo para brucelose',
                        prefixIcon: Icon(Icons.science_outlined),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(height: AppSpacing.md),
                  ],

                  // Observações
                  TextFormField(
                    controller: _observacoesController,
                    decoration: const InputDecoration(
                      labelText: 'Observações',
                      hintText: 'Informações adicionais relevantes',
                      prefixIcon: Icon(Icons.chat_bubble_outline),
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(height: AppSpacing.xxl),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _salvar,
                      icon: Icon(_isEditing ? Icons.save : Icons.add),
                      label: Text(
                          _isEditing ? 'Salvar Alterações' : 'Registrar Evento'),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
