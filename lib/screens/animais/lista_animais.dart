import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/animal.dart';
import '../../services/animal_service.dart';
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
          backgroundColor: Theme.of(context).colorScheme.error,
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: Theme.of(context).colorScheme.onError,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Novo Animal'),
      ),
      body: Consumer<AnimalService>(
        builder: (context, service, _) {
          final animais = service.buscar(_filtro);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
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
                        Icon(
                          Icons.pets,
                          size: 80,
                          color: colorScheme.onSurfaceVariant.withAlpha(80),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _filtro.isEmpty
                              ? 'Nenhum animal cadastrado'
                              : 'Nenhum animal encontrado',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (_filtro.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Toque em "Novo Animal" para começar',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant
                                  .withAlpha(180),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              else ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: colorScheme.primary.withAlpha(15),
                  child: Text(
                    '${animais.length} ${animais.length == 1 ? 'animal cadastrado' : 'animais cadastrados'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: animais.length,
                    itemBuilder: (context, index) {
                      final animal = animais[index];
                      return Dismissible(
                        key: Key(animal.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.delete,
                            color: colorScheme.onError,
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