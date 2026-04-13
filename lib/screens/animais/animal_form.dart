import 'package:flutter/material.dart';
import '../../models/animal.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Animal' : 'Cadastrar Animal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  isEdicao
                      ? 'Editar dados do animal'
                      : 'Preencha os dados do animal',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dados Principais',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Animal',
                          prefixIcon: Icon(Icons.label_outline),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: Validators.validarNome,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: idadeController,
                              decoration: const InputDecoration(
                                labelText: 'Idade (meses)',
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              keyboardType: TextInputType.number,
                              validator: Validators.validarIdade,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextFormField(
                              controller: pesoController,
                              decoration: const InputDecoration(
                                labelText: 'Peso (kg)',
                                prefixIcon: Icon(Icons.monitor_weight),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: Validators.validarPeso,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Observações',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: observacoesController,
                        decoration: const InputDecoration(
                          labelText: 'Observações',
                          prefixIcon: Icon(Icons.notes),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ElevatedButton.icon(
                onPressed: salvar,
                icon: Icon(isEdicao ? Icons.check : Icons.save_outlined),
                label:
                    Text(isEdicao ? 'Atualizar Animal' : 'Salvar Animal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}