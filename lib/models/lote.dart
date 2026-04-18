import 'dart:convert';
import 'package:uuid/uuid.dart';

enum LoteStatus { ativo, vendido, abatido, transferido }

extension LoteStatusLabel on LoteStatus {
  String get label {
    switch (this) {
      case LoteStatus.ativo:
        return 'Ativo';
      case LoteStatus.vendido:
        return 'Vendido';
      case LoteStatus.abatido:
        return 'Abatido';
      case LoteStatus.transferido:
        return 'Transferido';
    }
  }
}

class Lote {
  static const _uuid = Uuid();

  final String id;
  final String nome;
  final int quantidadeAnimais;
  final double pesoMedio;
  final LoteStatus status;
  final DateTime dataCriacao;
  final String observacoes;

  Lote({
    String? id,
    required this.nome,
    required this.quantidadeAnimais,
    required this.pesoMedio,
    this.status = LoteStatus.ativo,
    DateTime? dataCriacao,
    this.observacoes = '',
  })  : id = id ?? _uuid.v4(),
        dataCriacao = dataCriacao ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quantidadeAnimais': quantidadeAnimais,
      'pesoMedio': pesoMedio,
      'status': status.index,
      'dataCriacao': dataCriacao.toIso8601String(),
      'observacoes': observacoes,
    };
  }

  factory Lote.fromMap(Map<String, dynamic> map) {
    return Lote(
      id: map['id'] as String,
      nome: map['nome'] as String,
      quantidadeAnimais: map['quantidadeAnimais'] as int,
      pesoMedio: (map['pesoMedio'] as num).toDouble(),
      status: LoteStatus.values[map['status'] as int],
      dataCriacao: DateTime.parse(map['dataCriacao'] as String),
      observacoes: map['observacoes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory Lote.fromJson(Map<String, dynamic> json) => Lote.fromMap(json);

  static String encodeList(List<Lote> lotes) =>
      json.encode(lotes.map((l) => l.toJson()).toList());

  static List<Lote> decodeList(String source) {
    final List<dynamic> list = json.decode(source) as List<dynamic>;
    return list.map((e) => Lote.fromJson(e as Map<String, dynamic>)).toList();
  }
}
