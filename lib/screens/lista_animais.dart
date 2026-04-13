import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';
import '../widgets/animal_card.dart';
import '../utils/constants.dart';
import 'cadastro_animal.dart';
import 'scanner_qrcode.dart';

/// Tela principal - Lista de animais com busca e filtro
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

  /// Abre a tela de cadastro de novo animal
  void _abrirCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CadastroAnimal()),
    );
  }

  /// Abre o scanner de QR Code
  void _abrirScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerQRCode()),
    );
  }

  /// Confirma e remove um animal
  void _confirmarRemocao(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppMessages.remover),
        content: Text('${AppMessages.confirmarDelete}\n\n"${animal.nome}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppMessages.cancelar),
          ),
          TextButton(
            onPressed: () {
              context.read<AnimalService>().remover(animal.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppMessages.deletado),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text(AppMessages.remover),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppMessages.appTitle),
        actions: [
          // Botão do scanner QR Code
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: AppMessages.scannerTitulo,
            onPressed: _abrirScanner,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Novo Animal'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
      ),
      body: Consumer<AnimalService>(
        builder: (context, service, _) {
          final animaisFiltrados = service.filtrarPorNome(_filtro);

          return Column(
            children: [
              // Campo de busca
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: TextField(
                  controller: _buscaController,
                  decoration: InputDecoration(
                    hintText: AppMessages.buscarAnimal,
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                    suffixIcon: _filtro.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _buscaController.clear();
                              setState(() => _filtro = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.backgroundGreen,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() => _filtro = value),
                ),
              ),
              // Contador de animais
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pets, size: 18, color: AppColors.primaryGreen),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Text(
                      '${animaisFiltrados.length} ${animaisFiltrados.length == 1 ? 'animal' : 'animais'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              // Lista de animais
              Expanded(
                child: animaisFiltrados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pets,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: AppDimensions.paddingMedium),
                            Text(
                              _filtro.isNotEmpty
                                  ? 'Nenhum animal encontrado para "$_filtro"'
                                  : AppMessages.nenhumAnimal,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: animaisFiltrados.length,
                        padding: const EdgeInsets.only(
                          bottom: 80, // espaço para o FAB
                        ),
                        itemBuilder: (context, index) {
                          final animal = animaisFiltrados[index];
                          return Dismissible(
                            key: Key(animal.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(
                                right: AppDimensions.paddingLarge,
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: AppDimensions.paddingSmall,
                                horizontal: AppDimensions.paddingMedium,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadius,
                                ),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: AppColors.white,
                                size: 32,
                              ),
                            ),
                            confirmDismiss: (_) async {
                              _confirmarRemocao(context, animal);
                              return false;
                            },
                            child: AnimalCard(animal: animal),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}