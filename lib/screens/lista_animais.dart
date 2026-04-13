import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../models/animal.dart';
import '../widgets/animal_card.dart';
import 'cadastro_animal.dart';
import 'detalhe_animal.dart';
import 'scanner_qrcode.dart';

class ListaAnimais extends StatefulWidget {
  const ListaAnimais({super.key});

  @override
  State<ListaAnimais> createState() => _ListaAnimaisState();
}

class _ListaAnimaisState extends State<ListaAnimais> {
  final List<Animal> animais = [];

  void _adicionarAnimal(Animal animal) {
    setState(() {
      animais.add(animal);
    });
  }

  void _abrirCadastro() async {
    final novoAnimal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(builder: (_) => const CadastroAnimal()),
    );

    if (novoAnimal != null) {
      _adicionarAnimal(novoAnimal);
    }
  }

  void _abrirDetalhe(Animal animal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalheAnimal(animal: animal)),
    );
  }

  Animal? _buscarAnimalPorId(String id) {
    for (final animal in animais) {
      if (animal.id == id) return animal;
    }
    return null;
  }

  Animal? _buscarAnimalPorNfc(String tagId) {
    for (final animal in animais) {
      if (animal.nfcTagId == tagId) return animal;
    }
    return null;
  }

  Future<void> _escanearQrCode() async {
    final scannedId = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScannerQrcode()),
    );

    if (scannedId == null || !mounted) return;

    final animal = _buscarAnimalPorId(scannedId);
    if (animal != null) {
      _abrirDetalhe(animal);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Animal não encontrado para este QR Code.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _lerNfc() async {
    final isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('NFC não disponível neste dispositivo.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.nfc, color: Color(0xFF2E7D32)),
            SizedBox(width: 8),
            Text('Leitura NFC'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF2E7D32)),
            SizedBox(height: 16),
            Text('Aproxime a tag NFC do dispositivo...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              NfcManager.instance.stopSession();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final nfcData = tag.data;
        String? tagId;

        if (nfcData.containsKey('nfca')) {
          tagId = (nfcData['nfca']['identifier'] as List?)
              ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
              .join(':');
        } else if (nfcData.containsKey('nfcb')) {
          tagId = (nfcData['nfcb']['identifier'] as List?)
              ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
              .join(':');
        } else if (nfcData.containsKey('nfcf')) {
          tagId = (nfcData['nfcf']['identifier'] as List?)
              ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
              .join(':');
        } else if (nfcData.containsKey('nfcv')) {
          tagId = (nfcData['nfcv']['identifier'] as List?)
              ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
              .join(':');
        }

        NfcManager.instance.stopSession();

        if (!mounted) return;
        Navigator.pop(context); // Close dialog

        if (tagId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível ler a tag NFC.'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        final animal = _buscarAnimalPorNfc(tagId);
        if (animal != null) {
          _abrirDetalhe(animal);
        } else {
          _mostrarDialogAssociarNfc(tagId);
        }
      },
      onError: (error) async {
        NfcManager.instance.stopSession();
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro NFC: ${error.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  void _mostrarDialogAssociarNfc(String tagId) {
    if (animais.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Cadastre um animal antes de associar uma tag NFC.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Associar Tag NFC'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tag: $tagId'),
            const SizedBox(height: 12),
            const Text('Selecione o animal para associar:'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ...animais.where((a) => a.nfcTagId == null).map(
            (animal) => TextButton(
              onPressed: () {
                setState(() {
                  animal.nfcTagId = tagId;
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Tag NFC associada a ${animal.nome} com sucesso!'),
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                );
              },
              child: Text(animal.nome),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.agriculture, size: 28),
            SizedBox(width: 8),
            Text('Agrotrilho'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Escanear QR Code',
            onPressed: _escanearQrCode,
          ),
          IconButton(
            icon: const Icon(Icons.nfc),
            tooltip: 'Ler NFC',
            onPressed: _lerNfc,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Novo Animal'),
      ),
      body: animais.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum animal cadastrado',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque em "Novo Animal" para começar',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF2E7D32).withAlpha(15),
                  child: Text(
                    '${animais.length} ${animais.length == 1 ? 'animal cadastrado' : 'animais cadastrados'}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: animais.length,
                    itemBuilder: (context, index) {
                      return AnimalCard(
                        animal: animais[index],
                        onTap: () => _abrirDetalhe(animais[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}