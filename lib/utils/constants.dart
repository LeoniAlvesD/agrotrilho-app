import 'package:flutter/material.dart';

/// Cores principais do tema Agrotrilho
class AppColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF66BB6A);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color backgroundGreen = Color(0xFFF1F8E9);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF9E9E9E);
  static const Color red = Color(0xFFD32F2F);
  static const Color cardShadow = Color(0x1A000000);
}

/// Dimensões padrão utilizadas no app
class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
  static const double iconSize = 28.0;
  static const double cardElevation = 2.0;
  static const double qrCodeSize = 200.0;
}

/// Mensagens e textos do app
class AppMessages {
  static const String appName = 'Agrotrilho';
  static const String appTitle = 'Agrotrilho 🐄';
  static const String nenhumAnimal = 'Nenhum animal cadastrado';
  static const String cadastrar = 'Cadastrar Animal';
  static const String editar = 'Editar Animal';
  static const String detalhes = 'Detalhes do Animal';
  static const String salvo = 'Animal salvo com sucesso!';
  static const String deletado = 'Animal removido com sucesso!';
  static const String confirmarDelete = 'Deseja realmente remover este animal?';
  static const String cancelar = 'Cancelar';
  static const String confirmar = 'Confirmar';
  static const String remover = 'Remover';
  static const String buscarAnimal = 'Buscar animal por nome...';
  static const String campoObrigatorio = 'Campo obrigatório';
  static const String idadeInvalida = 'Informe uma idade válida';
  static const String pesoInvalido = 'Informe um peso válido';
  static const String scannerTitulo = 'Scanner QR Code';
  static const String qrInvalido = 'QR Code inválido';
  static const String animalNaoEncontrado = 'Animal não encontrado';
  static const String nfcNaoDisponivel = 'NFC não disponível neste dispositivo';
  static const String nfcTagAssociada = 'Tag NFC associada com sucesso!';

  // Formato do QR Code
  static const String qrCodePrefix = 'agrotrilho://animal/';
}

/// Status possíveis do animal
class AnimalStatus {
  static const String ativo = 'Ativo';
  static const String inativo = 'Inativo';
  static const String vendido = 'Vendido';

  static List<String> todos = [ativo, inativo, vendido];
}
