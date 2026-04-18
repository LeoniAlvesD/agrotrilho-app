# Architecture Guide

## Estrutura de Pastas

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models (puro Dart)
│   ├── animal.dart
│   └── platform_config.dart
├── services/                    # Lógica de negócio e I/O
│   ├── animal_service.dart      # CRUD + persistência (ChangeNotifier)
│   ├── qrcode_service.dart      # Geração/validação de QR Code
│   ├── qr_platform_service.dart # QR platform-aware
│   └── nfc_platform_service.dart
├── screens/                     # Telas (UI)
│   ├── root_screen.dart         # Shell de navegação
│   ├── home/
│   ├── animais/
│   ├── scanner/
│   ├── relatorios/
│   └── configuracoes/
├── widgets/                     # Widgets reutilizáveis
├── theme/                       # Configuração do tema Material 3
└── utils/                       # Utilitários e helpers
    ├── constants.dart
    ├── platform_helper.dart
    ├── platform_config.dart
    ├── platform_detection.dart
    ├── responsive_helper.dart
    └── validators.dart
```

## Padrões de Código

- **Effective Dart** — seguimos as convenções oficiais
- **const constructors** — onde possível para performance
- **final** — variáveis imutáveis declaradas como `final`
- **Sem `dart:io` em código compartilhado** — usa `kIsWeb` e
  `defaultTargetPlatform` para detecção de plataforma

## State Management

Usamos **Provider** (ChangeNotifier pattern):

- `AnimalService` extends `ChangeNotifier`
- Provido via `ChangeNotifierProvider` no `main.dart`
- Screens consomem via `context.watch<AnimalService>()` /
  `context.read<AnimalService>()`

## Camadas

```
Screen (UI)
    └── Service (negócio + I/O)
            └── Model (dados puros)
```

## Responsividade

`ResponsiveHelper` define breakpoints:

| Dispositivo | Largura    | Navegação       |
|-------------|-----------|-----------------|
| Mobile      | < 600 px  | Bottom Nav      |
| Tablet      | 600–1200  | Navigation Rail |
| Desktop     | > 1200 px | Drawer fixo     |

## Platform Detection

Todos os checks de plataforma passam por `PlatformHelper` (usa `kIsWeb` e
`defaultTargetPlatform`) — nunca importa `dart:io` em código compartilhado.
