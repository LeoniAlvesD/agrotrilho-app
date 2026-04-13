import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

class CadastroAnimal extends StatefulWidget {
  final Animal? animal;

  const CadastroAnimal({super.key, this.animal});

  @override
  State<CadastroAnimal> createState() => _CadastroAnimalState();
}

class _CadastroAnimalState extends State<CadastroAnimal> {
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.pets,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Animal',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: Validators.validarNome,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade (meses)',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validarIdade,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: pesoController,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: Validators.validarPeso,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: observacoesController,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: salvar,
                icon: Icon(isEdicao ? Icons.check : Icons.save),
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