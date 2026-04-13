import 'dart:convert';
import 'package:uuid/uuid.dart';

class Animal {
  static const _uuid = Uuid();

  final String id;
  final String nome;
  final int idade;
  final double peso;
  final String observacoes;

  Animal({
    String? id,
    required this.nome,
    required this.idade,
    required this.peso,
    this.observacoes = '',
  }) : id = id ?? _uuid.v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'peso': peso,
      'observacoes': observacoes,
    };
  }

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      id: map['id'] as String,
      nome: map['nome'] as String,
      idade: map['idade'] as int,
      peso: (map['peso'] as num).toDouble(),
      observacoes: map['observacoes'] as String? ?? '',
    );
  }

  /// Alias for [toMap] – used by persistence layer.
  Map<String, dynamic> toJson() => toMap();

  /// Alias for [fromMap] – used by persistence layer.
  factory Animal.fromJson(Map<String, dynamic> json) => Animal.fromMap(json);

  /// Convenience: encode a list of animals as a JSON string.
  static String encodeList(List<Animal> animais) =>
      json.encode(animais.map((a) => a.toJson()).toList());

  /// Convenience: decode a JSON string into a list of animals.
  static List<Animal> decodeList(String source) {
    final List<dynamic> list = json.decode(source) as List<dynamic>;
    return list
        .map((e) => Animal.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}