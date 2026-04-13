import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);
  static const Color accent = Color(0xFFFFA726);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

class AppStrings {
  static const String appName = 'Agrotrilho';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Rastreabilidade animal para pequenos e médios produtores rurais.';
  static const String producerName = 'Produtor Rural';
  static const String producerEmail = 'produtor@agrotrilho.com';

  // Dashboard
  static const String greeting = 'Olá';
  static const String dashboardSubtitle = 'Resumo do seu rebanho';
  static const String totalAnimais = 'Total de Animais';
  static const String pesoTotal = 'Peso Total (kg)';
  static const String idadeMedia = 'Idade Média (meses)';
  static const String cadastrarAnimal = 'Cadastrar Novo Animal';
  static const String animaisRecentes = 'Animais Recentes';

  // Empty states
  static const String nenhumAnimal = 'Nenhum animal cadastrado';
  static const String nenhumAnimalEncontrado = 'Nenhum animal encontrado';
  static const String nenhumDado = 'Nenhum dado para exibir';
  static const String cadastreAnimais = 'Cadastre animais para ver relatórios';
  static const String toqueNovo = 'Toque em "Novo Animal" para começar';

  // Relatórios
  static const String relatoriosTitulo = 'Relatórios do Rebanho';
  static const String relatoriosSubtitulo =
      'Estatísticas e análise dos animais cadastrados';
  static const String resumoGeral = 'Resumo Geral';
  static const String distribuicaoPeso = 'Distribuição por Peso';
  static const String distribuicaoIdade = 'Distribuição por Idade';
}
