import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/animal.dart';
import '../../services/animal_service.dart';
import '../../utils/constants.dart';
import '../../widgets/animal_card.dart';
import 'animal_form.dart';
import 'animal_detail.dart';

class ListaAnimais extends StatefulWidget {
  const ListaAnimais({super.key});

  @override
  State<ListaAnimais> createState() => _ListaAnimaisState();
}

class _ListaAnimaisState extends State<ListaAnimais> {
  final TextEditingController _buscaController = TextEditingController();
  String _filtro = '';

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  void _abrirCadastro() async {
    final novoAnimal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(builder: (_) => const AnimalForm()),
    );

    if (novoAnimal != null && mounted) {
      context.read<AnimalService>().adicionar(novoAnimal);
    }
  }

  void _abrirDetalhe(Animal animal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AnimalDetail(animal: animal)),
    );
  }

  void _removerAnimal(String id) {
    final service = context.read<AnimalService>();
    final animal = service.buscarPorId(id);
    service.remover(id);

    if (animal != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${animal.nome} removido.'),
          backgroundColor: Colors.red[700],
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: Colors.white,
            onPressed: () {
              service.adicionar(animal);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Novo Animal'),
      ),
      body: Consumer<AnimalService>(
        builder: (context, service, _) {
          final animais = service.buscar(_filtro);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.xs,
                ),
                child: TextField(
                  controller: _buscaController,
                  decoration: InputDecoration(
                    hintText: 'Buscar animal por nome...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _filtro.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _buscaController.clear();
                              setState(() {
                                _filtro = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filtro = value;
                    });
                  },
                ),
              ),
              if (animais.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            _filtro.isEmpty
                                ? Icons.pets
                                : Icons.search_off,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          _filtro.isEmpty
                              ? 'Nenhum animal cadastrado'
                              : 'Nenhum animal encontrado',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (_filtro.isEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          const Text(
                            'Toque em "Novo Animal" para começar',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(12),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primary.withAlpha(30),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${animais.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        animais.length == 1
                            ? 'animal cadastrado'
                            : 'animais cadastrados',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.sm,
                      bottom: 80,
                    ),
                    itemCount: animais.length,
                    itemBuilder: (context, index) {
                      final animal = animais[index];
                      return Dismissible(
                        key: Key(animal.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding:
                              const EdgeInsets.only(right: AppSpacing.xl),
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                'Excluir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (_) => _removerAnimal(animal.id),
                        child: AnimalCard(
                          animal: animal,
                          onTap: () => _abrirDetalhe(animal),
                        ),
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