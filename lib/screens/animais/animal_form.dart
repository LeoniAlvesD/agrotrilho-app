import 'package:flutter/material.dart';
import '../../models/animal.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../utils/responsive_helper.dart';

class AnimalForm extends StatefulWidget {
  final Animal? animal;

  const AnimalForm({super.key, this.animal});

  @override
  State<AnimalForm> createState() => _AnimalFormState();
}

class _AnimalFormState extends State<AnimalForm> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final pesoController = TextEditingController();
  final observacoesController = TextEditingController();

  bool get isEdicao => widget.animal != null;

  @override
  void initState() {
    super.initState();
    if (widget.animal != null) {
      nomeController.text = widget.animal!.nome;
      idadeController.text = widget.animal!.idade.toString();
      pesoController.text = widget.animal!.peso.toString();
      observacoesController.text = widget.animal!.observacoes;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    idadeController.dispose();
    pesoController.dispose();
    observacoesController.dispose();
    super.dispose();
  }

  void salvar() {
    if (!_formKey.currentState!.validate()) return;

    final animal = Animal(
      id: widget.animal?.id,
      nome: nomeController.text.trim(),
      idade: int.tryParse(idadeController.text) ?? 0,
      peso: double.tryParse(pesoController.text) ?? 0.0,
      observacoes: observacoesController.text.trim(),
    );

    Navigator.pop(context, animal);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Animal' : 'Cadastrar Animal'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: ResponsiveHelper.getPadding(context),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: AppSpacing.sm),
                  Icon(
                    Icons.pets,
                    size: 64,
                    color: colorScheme.primary,
                    semanticLabel: isEdicao ? 'Editar Animal' : 'Novo Animal',
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Animal',
                      prefixIcon: Icon(Icons.label),
                    ),
                    validator: Validators.validarNome,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: idadeController,
                    decoration: const InputDecoration(
                      labelText: 'Idade (meses)',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.validarIdade,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: pesoController,
                    decoration: const InputDecoration(
                      labelText: 'Peso (kg)',
                      prefixIcon: Icon(Icons.monitor_weight),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: Validators.validarPeso,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: observacoesController,
                    decoration: const InputDecoration(
                      labelText: 'Observações',
                      prefixIcon: Icon(Icons.notes),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: AppSpacing.xxxl),
                  ElevatedButton.icon(
                    onPressed: salvar,
                    icon: Icon(isEdicao ? Icons.check : Icons.save),
                    label: Text(
                        isEdicao ? 'Atualizar Animal' : 'Salvar Animal'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}