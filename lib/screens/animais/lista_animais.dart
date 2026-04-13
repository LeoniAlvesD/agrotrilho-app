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
                        Icon(Icons.pets, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          _filtro.isEmpty
                              ? 'Nenhum animal cadastrado'
                              : 'Nenhum animal encontrado',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (_filtro.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Toque em "Novo Animal" para começar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
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
                  padding: const EdgeInsets.all(16),
                  color: AppColors.primary.withAlpha(15),
                  child: Text(
                    '${animais.length} ${animais.length == 1 ? 'animal cadastrado' : 'animais cadastrados'}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
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
                            vertical: 6,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
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