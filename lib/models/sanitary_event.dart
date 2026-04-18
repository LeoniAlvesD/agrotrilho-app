import 'dart:convert';
import 'package:uuid/uuid.dart';

/// Tipos de evento sanitário alinhados ao PNIB/SISBOV.
enum TipoEventoSanitario {
  vacinacao,
  exameDiagnostico,
  tratamento,
  movimentacao,
  ocorrencia,
}

extension TipoEventoSanitarioLabel on TipoEventoSanitario {
  String get label {
    switch (this) {
      case TipoEventoSanitario.vacinacao:
        return 'Vacinação';
      case TipoEventoSanitario.exameDiagnostico:
        return 'Exame Diagnóstico';
      case TipoEventoSanitario.tratamento:
        return 'Tratamento';
      case TipoEventoSanitario.movimentacao:
        return 'Movimentação';
      case TipoEventoSanitario.ocorrencia:
        return 'Ocorrência';
    }
  }
}

/// Registro de um evento sanitário individual por animal,
/// conforme exigido pelo PNIB/SISBOV para rastreabilidade individual.
class SanitaryEvent {
  static const _uuid = Uuid();

  final String id;
  final String animalId;
  final TipoEventoSanitario tipo;
  final DateTime data;
  final String descricao;

  /// Médico veterinário ou responsável técnico pelo evento.
  final String responsavelTecnico;

  final String observacoes;

  /// Número do documento sanitário (ex.: GTA, GGTA, certificado).
  final String documento;

  /// Resultado do exame diagnóstico, quando aplicável.
  final String resultado;

  SanitaryEvent({
    String? id,
    required this.animalId,
    required this.tipo,
    required this.data,
    required this.descricao,
    this.responsavelTecnico = '',
    this.observacoes = '',
    this.documento = '',
    this.resultado = '',
  }) : id = id ?? _uuid.v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'animalId': animalId,
      'tipo': tipo.name,
      'data': data.toIso8601String(),
      'descricao': descricao,
      'responsavelTecnico': responsavelTecnico,
      'observacoes': observacoes,
      'documento': documento,
      'resultado': resultado,
    };
  }

  factory SanitaryEvent.fromMap(Map<String, dynamic> map) {
    return SanitaryEvent(
      id: map['id'] as String,
      animalId: map['animalId'] as String,
      tipo: TipoEventoSanitario.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => TipoEventoSanitario.ocorrencia,
      ),
      data: DateTime.parse(map['data'] as String),
      descricao: map['descricao'] as String? ?? '',
      responsavelTecnico: map['responsavelTecnico'] as String? ?? '',
      observacoes: map['observacoes'] as String? ?? '',
      documento: map['documento'] as String? ?? '',
      resultado: map['resultado'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory SanitaryEvent.fromJson(Map<String, dynamic> json) =>
      SanitaryEvent.fromMap(json);

  static String encodeList(List<SanitaryEvent> events) =>
      json.encode(events.map((e) => e.toJson()).toList());

  static List<SanitaryEvent> decodeList(String source) {
    final List<dynamic> list = json.decode(source) as List<dynamic>;
    return list
        .map((e) => SanitaryEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
