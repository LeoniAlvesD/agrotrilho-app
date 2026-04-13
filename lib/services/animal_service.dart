import 'package:flutter/foundation.dart';
import '../models/animal.dart';

class AnimalService extends ChangeNotifier {
  final List<Animal> _animais = [];

  AnimalService() {
    _carregarDadosExemplo();
  }

  List<Animal> get animais => List.unmodifiable(_animais);

  List<Animal> buscar(String query) {
    if (query.isEmpty) return animais;
    final q = query.toLowerCase();
    return _animais
        .where((a) => a.nome.toLowerCase().contains(q))
        .toList();
  }

  Animal? buscarPorId(String id) {
    for (final animal in _animais) {
      if (animal.id == id) return animal;
    }
    return null;
  }

  void adicionar(Animal animal) {
    _animais.add(animal);
    notifyListeners();
  }

  void atualizar(Animal atualizado) {
    final index = _animais.indexWhere((a) => a.id == atualizado.id);
    if (index != -1) {
      _animais[index] = atualizado;
      notifyListeners();
    }
  }

  void remover(String id) {
    _animais.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void _carregarDadosExemplo() {
    _animais.addAll([
      Animal(
        nome: 'Mimosa',
        idade: 24,
        peso: 350.5,
        observacoes: 'Vaca leiteira, boa produção.',
      ),
      Animal(
        nome: 'Estrela',
        idade: 36,
        peso: 420.0,
        observacoes: 'Animal saudável, vacinação em dia.',
      ),
      Animal(
        nome: 'Trovão',
        idade: 18,
        peso: 280.0,
        observacoes: 'Novilho em crescimento.',
      ),
    ]);
  }
}
