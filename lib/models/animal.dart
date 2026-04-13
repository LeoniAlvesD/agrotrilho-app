import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

/// Model que representa um animal no sistema Agrotrilho
class Animal {
  final String id;
  final String nome;
  final int idade; // em meses
  final double peso; // em kg
  final String observacoes;
  final String status;
  final DateTime dataCadastro;
  final String qrCodeData;
  String? nfcTagId;

  Animal._({
    required this.id,
    required this.nome,
    required this.idade,
    required this.peso,
    this.observacoes = '',
    this.status = 'Ativo',
    required this.dataCadastro,
    required this.qrCodeData,
    this.nfcTagId,
  });

  /// Construtor principal que garante consistência entre ID e QR Code
  factory Animal({
    String? id,
    required String nome,
    required int idade,
    required double peso,
    String observacoes = '',
    String status = 'Ativo',
    DateTime? dataCadastro,
    String? qrCodeData,
    String? nfcTagId,
  }) {
    final resolvedId = id ?? const Uuid().v4();
    return Animal._(
      id: resolvedId,
      nome: nome,
      idade: idade,
      peso: peso,
      observacoes: observacoes,
      status: status,
      dataCadastro: dataCadastro ?? DateTime.now(),
      qrCodeData: qrCodeData ?? '${AppMessages.qrCodePrefix}$resolvedId',
      nfcTagId: nfcTagId,
    );
  }

  /// Factory constructor para criar novos animais (alias conveniente)
  factory Animal.criar({
    required String nome,
    required int idade,
    required double peso,
    String observacoes = '',
    String status = 'Ativo',
    String? nfcTagId,
  }) {
    return Animal(
      nome: nome,
      idade: idade,
      peso: peso,
      observacoes: observacoes,
      status: status,
      nfcTagId: nfcTagId,
    );
  }

  /// Retorna a idade formatada (ex: "36 meses" ou "3 anos")
  String get idadeFormatada {
    if (idade >= 12) {
      final anos = idade ~/ 12;
      final meses = idade % 12;
      if (meses == 0) return '$anos ${anos == 1 ? 'ano' : 'anos'}';
      return '$anos ${anos == 1 ? 'ano' : 'anos'} e $meses ${meses == 1 ? 'mês' : 'meses'}';
    }
    return '$idade ${idade == 1 ? 'mês' : 'meses'}';
  }

  /// Retorna o peso formatado (ex: "450.5 kg" ou "200 kg")
  String get pesoFormatado {
    if (peso == peso.truncateToDouble()) {
      return '${peso.toInt()} kg';
    }
    return '${peso.toStringAsFixed(1)} kg';
  }

  /// Retorna a data de cadastro formatada (ex: "13/04/2026")
  String get dataCadastroFormatada =>
      DateFormat('dd/MM/yyyy').format(dataCadastro);

  /// Cria uma cópia do animal com campos atualizados
  Animal copyWith({
    String? nome,
    int? idade,
    double? peso,
    String? observacoes,
    String? status,
    String? nfcTagId,
  }) {
    return Animal._(
      id: id,
      nome: nome ?? this.nome,
      idade: idade ?? this.idade,
      peso: peso ?? this.peso,
      observacoes: observacoes ?? this.observacoes,
      status: status ?? this.status,
      dataCadastro: dataCadastro,
      qrCodeData: qrCodeData,
      nfcTagId: nfcTagId ?? this.nfcTagId,
    );
  }

  /// Converte para Map (preparado para futura integração com API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'peso': peso,
      'observacoes': observacoes,
      'status': status,
      'dataCadastro': dataCadastro.toIso8601String(),
      'qrCodeData': qrCodeData,
      'nfcTagId': nfcTagId,
    };
  }

  /// Cria Animal a partir de Map (preparado para futura integração com API)
  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      id: map['id'],
      nome: map['nome'],
      idade: map['idade'],
      peso: map['peso'].toDouble(),
      observacoes: map['observacoes'] ?? '',
      status: map['status'] ?? AnimalStatus.ativo,
      dataCadastro: DateTime.parse(map['dataCadastro']),
      qrCodeData: map['qrCodeData'],
      nfcTagId: map['nfcTagId'],
    );
  }
}