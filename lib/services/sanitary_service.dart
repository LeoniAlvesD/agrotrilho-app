import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sanitary_event.dart';

/// Serviço responsável pela gestão dos eventos sanitários dos animais.
///
/// Persiste os dados localmente via [SharedPreferences], seguindo o mesmo
/// padrão do [AnimalService].
class SanitaryService extends ChangeNotifier {
  static const _storageKey = 'agrotrilho_sanitary_events';

  final List<SanitaryEvent> _events = [];
  bool _loaded = false;

  SanitaryService() {
    _carregarDados();
  }

  List<SanitaryEvent> get events => List.unmodifiable(_events);

  /// Indica se o carregamento inicial dos dados foi concluído.
  bool get loaded => _loaded;

  /// Retorna todos os eventos de um animal, ordenados do mais recente ao mais antigo.
  List<SanitaryEvent> porAnimal(String animalId) {
    return _events
        .where((e) => e.animalId == animalId)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }

  /// Retorna o total de eventos registrados para um animal.
  int contarPorAnimal(String animalId) =>
      _events.where((e) => e.animalId == animalId).length;

  /// Filtra eventos por período, tipo e/ou animal.
  List<SanitaryEvent> filtrar({
    DateTime? inicio,
    DateTime? fim,
    TipoEventoSanitario? tipo,
    String? animalId,
  }) {
    return _events.where((e) {
      if (animalId != null && e.animalId != animalId) return false;
      if (tipo != null && e.tipo != tipo) return false;
      if (inicio != null && e.data.isBefore(inicio)) return false;
      // Compare against start of next day to include events on the `fim` date.
      if (fim != null &&
          e.data.isAfter(fim.add(const Duration(days: 1)))) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }

  void adicionar(SanitaryEvent event) {
    _events.add(event);
    notifyListeners();
    _salvar();
  }

  void atualizar(SanitaryEvent atualizado) {
    final index = _events.indexWhere((e) => e.id == atualizado.id);
    if (index != -1) {
      _events[index] = atualizado;
      notifyListeners();
      _salvar();
    }
  }

  void remover(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
    _salvar();
  }

  /// Remove todos os eventos sanitários associados a um animal.
  void removerPorAnimal(String animalId) {
    _events.removeWhere((e) => e.animalId == animalId);
    notifyListeners();
    _salvar();
  }

  // ── Relatório CSV ───────────────────────────────────────────────────────

  /// Gera uma string CSV com os eventos filtrados.
  ///
  /// [nomeAnimais] é um mapa opcional de animalId → nome do animal para
  /// enriquecer o relatório.
  String gerarCsv({
    DateTime? inicio,
    DateTime? fim,
    TipoEventoSanitario? tipo,
    String? animalId,
    Map<String, String>? nomeAnimais,
  }) {
    final eventos =
        filtrar(inicio: inicio, fim: fim, tipo: tipo, animalId: animalId);
    final buffer = StringBuffer();
    buffer.writeln(
      'ID,Animal,Tipo,Data,Descrição,Responsável Técnico,Documento (GTA),Resultado,Observações',
    );
    for (final e in eventos) {
      final nome = nomeAnimais?[e.animalId] ?? e.animalId;
      final data =
          '${e.data.day.toString().padLeft(2, '0')}/${e.data.month.toString().padLeft(2, '0')}/${e.data.year}';
      buffer.writeln([
        _escapeCsv(e.id),
        _escapeCsv(nome),
        _escapeCsv(e.tipo.label),
        _escapeCsv(data),
        _escapeCsv(e.descricao),
        _escapeCsv(e.responsavelTecnico),
        _escapeCsv(e.documento),
        _escapeCsv(e.resultado),
        _escapeCsv(e.observacoes),
      ].join(','));
    }
    return buffer.toString();
  }

  String _escapeCsv(String s) => '"${s.replaceAll('"', '""')}"';

  // ── Persistência ─────────────────────────────────────────────────────────

  Future<void> _carregarDados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        _events.addAll(SanitaryEvent.decodeList(raw));
      }
    } catch (_) {
      // Ignora erros de leitura; dados permanecem em memória.
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _salvar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, SanitaryEvent.encodeList(_events));
    } catch (_) {
      // Silently ignore write errors – data stays in memory.
    }
  }
}
