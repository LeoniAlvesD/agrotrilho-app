import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';
import '../utils/constants.dart';

/// Tela de cadastro e edição de animal
class CadastroAnimal extends StatefulWidget {
  /// Se fornecido, a tela entra em modo de edição
  final Animal? animal;

  const CadastroAnimal({super.key, this.animal});

  @override
  State<CadastroAnimal> createState() => _CadastroAnimalState();
}

class _CadastroAnimalState extends State<CadastroAnimal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _idadeController;
  late final TextEditingController _pesoController;
  late final TextEditingController _observacoesController;
  late String _status;

  /// Verifica se estamos editando um animal existente
  bool get _editando => widget.animal != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.animal?.nome ?? '');
    _idadeController = TextEditingController(
      text: widget.animal?.idade.toString() ?? '',
    );
    _pesoController = TextEditingController(
      text: widget.animal?.peso.toString() ?? '',
    );
    _observacoesController = TextEditingController(
      text: widget.animal?.observacoes ?? '',
    );
    _status = widget.animal?.status ?? AnimalStatus.ativo;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  /// Salva ou atualiza o animal
  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final service = context.read<AnimalService>();

    if (_editando) {
      // Atualiza animal existente
      final atualizado = widget.animal!.copyWith(
        nome: _nomeController.text.trim(),
        idade: int.parse(_idadeController.text),
        peso: double.parse(_pesoController.text),
        observacoes: _observacoesController.text.trim(),
        status: _status,
      );
      service.atualizar(atualizado);
    } else {
      // Cria novo animal
      final novoAnimal = Animal.criar(
        nome: _nomeController.text.trim(),
        idade: int.parse(_idadeController.text),
        peso: double.parse(_pesoController.text),
        observacoes: _observacoesController.text.trim(),
        status: _status,
      );
      service.adicionar(novoAnimal);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppMessages.salvo),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? AppMessages.editar : AppMessages.cadastrar),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ícone decorativo
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Icon(
                  _editando ? Icons.edit : Icons.add_circle_outline,
                  size: 64,
                  color: AppColors.primaryGreen,
                ),
              ),
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: _inputDecoration(
                  label: 'Nome do Animal',
                  icon: Icons.pets,
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppMessages.campoObrigatorio;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              // Campo Idade
              TextFormField(
                controller: _idadeController,
                decoration: _inputDecoration(
                  label: 'Idade (meses)',
                  icon: Icons.calendar_today,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppMessages.campoObrigatorio;
                  }
                  final idade = int.tryParse(value);
                  if (idade == null || idade <= 0) {
                    return AppMessages.idadeInvalida;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              // Campo Peso
              TextFormField(
                controller: _pesoController,
                decoration: _inputDecoration(
                  label: 'Peso (kg)',
                  icon: Icons.monitor_weight,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppMessages.campoObrigatorio;
                  }
                  final peso = double.tryParse(value);
                  if (peso == null || peso <= 0) {
                    return AppMessages.pesoInvalido;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              // Campo Observações
              TextFormField(
                controller: _observacoesController,
                decoration: _inputDecoration(
                  label: 'Observações',
                  icon: Icons.notes,
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              // Status dropdown
              DropdownButtonFormField<String>(
                value: _status,
                decoration: _inputDecoration(
                  label: 'Status',
                  icon: Icons.flag,
                ),
                items: AnimalStatus.todos
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Botão Salvar
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save),
                  label: Text(
                    _editando ? 'Atualizar Animal' : 'Cadastrar Animal',
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Decoração padrão para campos de formulário
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primaryGreen),
      filled: true,
      fillColor: AppColors.backgroundGreen,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: const BorderSide(color: AppColors.red),
      ),
    );
  }
}