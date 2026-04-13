# 🚜 Agrotrilho

**Rastreabilidade animal para pequenos e médios produtores rurais.**

Sistema de gerenciamento e monitoramento de rebanho com identificação por QR Code e NFC, desenvolvido em Flutter.

## ✨ Funcionalidades do MVP

- **Cadastro de animais** — Nome, idade, peso e observações
- **Listagem de animais** — Lista dinâmica com informações resumidas
- **Detalhes do animal** — Todas as informações + QR Code gerado automaticamente
- **QR Code** — Geração automática por animal e leitura via câmera
- **NFC** — Leitura de tags NFC e associação com animais (mobile only)
- **Dashboard** — Resumo do rebanho com estatísticas
- **Relatórios** — Distribuição por peso e idade
- **Navegação responsiva** — Drawer, Bottom Nav e Navigation Rail

## 📱 Plataformas Suportadas

### ✅ Android & iOS (PRIMARY TARGETS)

```bash
flutter run                 # Android (default)
flutter run -d ios         # iOS
```

### ⏸️ Web (Desabilitado temporariamente)

Web foi desabilitado temporariamente para resolver conflitos de `JSObject` causados
por incompatibilidade entre versões do Dart SDK e o pacote `web`.

Veja: [`lib/services/platform/MIGRATION_NOTES.md`](lib/services/platform/MIGRATION_NOTES.md) para o plano de re-habilitação.

## 📱 Tecnologia

- **Flutter** (Dart) — Framework mobile multiplataforma
- **Material 3** — Design system com tema verde agro
- **qr_flutter** — Geração de QR Codes
- **mobile_scanner** — Leitura de QR Code via câmera
- **provider** — State management
- **shared_preferences** — Persistência local

## 🏗️ Estrutura do Projeto

```
lib/
├── main.dart                           # App entry point
├── models/
│   ├── animal.dart                     # Model Animal
│   └── platform_config.dart            # Platform capabilities model
├── services/
│   ├── animal_service.dart             # CRUD + persistência
│   ├── qrcode_service.dart             # Geração/validação QR
│   ├── qr_platform_service.dart        # QR platform-aware
│   ├── nfc_platform_service.dart       # NFC mobile-only (safe no-op)
│   └── platform/
│       └── MIGRATION_NOTES.md          # Como re-habilitar web
├── screens/
│   ├── root_screen.dart                # Navegação central
│   ├── home/
│   │   └── dashboard_screen.dart       # Dashboard com resumo
│   ├── animais/
│   │   ├── lista_animais.dart          # Lista de animais
│   │   ├── animal_form.dart            # Formulário de cadastro
│   │   └── animal_detail.dart          # Detalhes + QR Code
│   ├── scanner/
│   │   ├── qr_scanner_screen.dart      # Scanner QR Code
│   │   └── nfc_reader_screen.dart      # Leitor NFC (mobile-only)
│   ├── relatorios/
│   │   └── relatorios_screen.dart      # Relatórios e estatísticas
│   └── configuracoes/
│       └── configuracoes_screen.dart   # Configurações
├── theme/
│   └── app_theme.dart                  # Material 3 theme
├── widgets/
│   ├── animal_card.dart                # Card reutilizável de animal
│   ├── app_bottom_nav.dart             # Bottom navigation (mobile)
│   ├── app_drawer.dart                 # Navigation drawer
│   ├── dashboard_card.dart             # Card de dashboard
│   ├── platform_indicator.dart         # Badge de plataforma
│   ├── qr_display_widget.dart          # Widget de exibição QR
│   ├── responsive_grid.dart            # Grid responsivo
│   ├── responsive_layout.dart          # Layout responsivo
│   ├── stat_widget.dart                # Widget de estatística
│   ├── stats_card.dart                 # Card de estatísticas
│   └── web_qr_simulator.dart           # Simulador QR (web)
└── utils/
    ├── constants.dart                  # Cores, strings, spacing
    ├── platform_config.dart            # Runtime platform config
    ├── platform_detection.dart         # Safe platform detection
    ├── platform_helper.dart            # Platform capabilities helper
    ├── responsive_helper.dart          # Responsive breakpoints
    └── validators.dart                 # Form validators
```

## 🚀 Como Rodar

```bash
# Instalar dependências
flutter pub get

# Rodar no Android (default)
flutter run

# Rodar no iOS
flutter run -d ios

# Rodar testes
flutter test
```

## 📦 Dependências

| Pacote | Uso |
|--------|-----|
| `qr_flutter` | Geração de QR Code |
| `mobile_scanner` | Leitura de QR Code via câmera |
| `uuid` | Geração de IDs únicos |
| `intl` | Formatação de datas e números |
| `provider` | State management |
| `shared_preferences` | Persistência local |

## 🎨 Design

- **Cor principal:** Verde agro (`#2E7D32`)
- **UI:** Material 3 com botões grandes e interface intuitiva
- **Ícones:** Material Icons
- **Responsividade:** Mobile (Bottom Nav) / Tablet (Drawer) / Desktop (Drawer fixo)

## 📐 Arquitetura Multi-Platform

O app usa **platform detection seguro** via `kIsWeb` e `defaultTargetPlatform`
(sem `dart:io` em código compartilhado):

- **NFC**: disponível apenas em Android/iOS (safe no-op em outras plataformas)
- **QR Scanner**: câmera real em mobile, simulador em web (quando habilitado)
- **Platform Detection**: `PlatformHelper` e `PlatformDetection` utilities

## 📝 Objetivo

Facilitar o controle de rebanho para pequenos produtores rurais de Goiás, com identificação rápida via QR Code e NFC, preparado para futuras integrações com backend, sincronização offline e conformidade PNIB.
