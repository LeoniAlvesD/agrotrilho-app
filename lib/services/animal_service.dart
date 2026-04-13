import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/animal.dart';

class AnimalService extends ChangeNotifier {
  static const _storageKey = 'agrotrilho_animais';

  final List<Animal> _animais = [];
  bool _loaded = false;

  AnimalService() {
    _carregarDados();
  }

  List<Animal> get animais => List.unmodifiable(_animais);

  /// Whether the initial load from storage has completed.
  bool get loaded => _loaded;

  List<Animal> buscar(String query) {
    if (query.isEmpty) return animais;
    final q = query.toLowerCase();
    return _animais.where((a) => a.nome.toLowerCase().contains(q)).toList();
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
    _salvar();
  }

  void atualizar(Animal atualizado) {
    final index = _animais.indexWhere((a) => a.id == atualizado.id);
    if (index != -1) {
      _animais[index] = atualizado;
      notifyListeners();
      _salvar();
    }
  }

  void remover(String id) {
    _animais.removeWhere((a) => a.id == id);
    notifyListeners();
    _salvar();
  }

  // ── Persistence ──────────────────────────────────────────

  Future<void> _carregarDados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        _animais.addAll(Animal.decodeList(raw));
      } else {
        _carregarDadosExemplo();
        await _salvar();
      }
    } catch (_) {
      if (_animais.isEmpty) _carregarDadosExemplo();
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _salvar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, Animal.encodeList(_animais));
    } catch (_) {
      // Silently ignore write errors – data stays in memory.
    }
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
