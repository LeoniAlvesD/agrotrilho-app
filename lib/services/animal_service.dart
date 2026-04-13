import 'package:flutter/foundation.dart';
import '../models/animal.dart';
import '../utils/constants.dart';

/// Service de gerenciamento de animais com ChangeNotifier para Provider
/// Preparado para futura integração com API REST
class AnimalService extends ChangeNotifier {
  final List<Animal> _animais = [];

  /// Retorna lista imutável de animais
  List<Animal> get animais => List.unmodifiable(_animais);

  /// Retorna o total de animais cadastrados
  int get total => _animais.length;

  /// Construtor que inicializa com dados de exemplo
  AnimalService() {
    _carregarDadosExemplo();
  }

  /// Carrega 3 animais pré-cadastrados para demonstração
  void _carregarDadosExemplo() {
    _animais.addAll([
      Animal.criar(
        nome: 'Bessie',
        idade: 36,
        peso: 450.5,
        observacoes: 'Vaca leiteira, boa produção diária',
        status: AnimalStatus.ativo,
      ),
      Animal.criar(
        nome: 'Touro Rex',
        idade: 48,
        peso: 550.0,
        observacoes: 'Reprodutor principal do rebanho',
        status: AnimalStatus.ativo,
      ),
      Animal.criar(
        nome: 'Mimi',
        idade: 12,
        peso: 200.0,
        observacoes: 'Filhote saudável, em crescimento',
        status: AnimalStatus.ativo,
      ),
    ]);
  }

  /// Adiciona um novo animal à lista
  void adicionar(Animal animal) {
    _animais.add(animal);
    notifyListeners();
  }

  /// Atualiza um animal existente pelo ID
  void atualizar(Animal animalAtualizado) {
    final index = _animais.indexWhere((a) => a.id == animalAtualizado.id);
    if (index != -1) {
      _animais[index] = animalAtualizado;
      notifyListeners();
    }
  }

  /// Remove um animal pelo ID
  void remover(String id) {
    _animais.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  /// Busca um animal pelo ID
  /// Retorna null se não encontrado
  Animal? buscarPorId(String id) {
    try {
      return _animais.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Busca um animal pela tag NFC
  /// Retorna null se não encontrado
  Animal? buscarPorNfcTag(String nfcTagId) {
    try {
      return _animais.firstWhere((a) => a.nfcTagId == nfcTagId);
    } catch (_) {
      return null;
    }
  }

  /// Filtra animais pelo nome (busca parcial, case-insensitive)
  List<Animal> filtrarPorNome(String query) {
    if (query.isEmpty) return animais;
    return _animais
        .where((a) => a.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Associa uma tag NFC a um animal
  void associarNfcTag(String animalId, String nfcTagId) {
    final animal = buscarPorId(animalId);
    if (animal != null) {
      final atualizado = animal.copyWith(nfcTagId: nfcTagId);
      atualizar(atualizado);
    }
  }
}
