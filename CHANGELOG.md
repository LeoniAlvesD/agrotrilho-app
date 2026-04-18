# Changelog

All notable changes to AgroTrilho are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [1.0.0] - 2026-04-18

### Added

- MVP completo com CRUD de animais (cadastrar, listar, editar, remover)
- QR Code: geração automática por animal e leitura via câmera (mobile)
- NFC: suporte a leitura de tags NFC em Android e iOS
- Menu de navegação responsivo (Bottom Nav / Rail / Drawer)
- Dashboard com estatísticas do rebanho
- Relatórios: distribuição por peso e idade
- Responsividade completa (web / mobile / tablet)
- Persistência local com `shared_preferences`
- Platform detection seguro (sem `dart:io` em código compartilhado)
- CI/CD workflows (`.github/workflows/ci.yml` e `build.yml`)
- Documentação profissional (`docs/`)
- Build scripts (`tools/`)

### Fixed

- JSObject build error ao compilar para web
  — corrigido adicionando `web: ^0.5.0` ao `pubspec.yaml`
- Incompatibilidades de dependências com Dart 3+

### Technical

- Dart SDK ≥ 3.2.0
- Flutter stable channel
- `web: ^0.5.0` (fix JSObject incompatibility)
- `provider: ^6.1.0`, `intl: ^0.20.0`, `uuid: ^4.5.0`
- `flutter_lints: ^3.0.0`
- Estrutura profissional de projeto
