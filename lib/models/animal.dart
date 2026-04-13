import 'package:uuid/uuid.dart';

class Animal {
  static const _uuid = Uuid();

  final String id;
  final String nome;
  final int idade;
  final double peso;
  final String observacoes;
  String? nfcTagId;

  Animal({
    String? id,
    required this.nome,
    required this.idade,
    required this.peso,
    this.observacoes = '',
    this.nfcTagId,
  }) : id = id ?? _uuid.v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'peso': peso,
      'observacoes': observacoes,
      'nfcTagId': nfcTagId,
    };
  }

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      id: map['id'] as String,
      nome: map['nome'] as String,
      idade: map['idade'] as int,
      peso: (map['peso'] as num).toDouble(),
      observacoes: map['observacoes'] as String? ?? '',
      nfcTagId: map['nfcTagId'] as String?,
    );
  }
}