# 🚜 AgroTrilho

**Rastreabilidade animal para pequenos produtores rurais.**

Sistema de gerenciamento e monitoramento de rebanho com identificação por QR Code e NFC, desenvolvido em Flutter — funciona em **Web**, **Android** e **iOS**.

## ✨ Funcionalidades

- **Cadastro de animais** — Nome, idade, peso e observações
- **Listagem de animais** — Lista dinâmica com busca
- **Detalhes do animal** — Informações completas + QR Code gerado automaticamente
- **QR Code** — Geração automática por animal; leitura via câmera (mobile) ou simulador (web)
- **NFC** — Leitura de tags NFC associadas a animais (mobile only)
- **Dashboard** — Resumo do rebanho com estatísticas
- **Relatórios** — Distribuição por peso e idade
- **Navegação responsiva** — Bottom Nav (mobile) / Navigation Rail (tablet) / Drawer (desktop)

## 📱 Plataformas Suportadas

| Plataforma | Status | Comando              |
|------------|--------|----------------------|
| Android    | ✅     | `flutter run`        |
| iOS        | ✅     | `flutter run -d ios` |
| Web        | ✅     | `flutter run -d chrome` |

> **Web + JSObject fix**: o pacote `web: ^0.5.0` é fixado em `pubspec.yaml`
> para garantir compatibilidade com Dart 3+ e evitar o erro
> *"The type 'JSObject' can't be used as supertype"*.

## 🚀 Quick Start

```bash
# 1. Instalar dependências
flutter pub get

# 2. Web (Chrome)
flutter run -d chrome

# 3. Android
flutter run

# 4. iOS (macOS necessário)
flutter run -d ios

# 5. Testes
flutter test
```

## 📦 Tech Stack

| Pacote              | Uso                           |
|---------------------|-------------------------------|
| `flutter`           | Framework multiplataforma     |
| `web: ^0.5.0`       | JS interop compatível com Dart 3+ |
| `qr_flutter`        | Geração de QR Code            |
| `mobile_scanner`    | Leitura de QR Code via câmera |
| `provider`          | State management              |
| `shared_preferences`| Persistência local            |
| `uuid`              | Geração de IDs únicos         |
| `intl`              | Formatação de datas/números   |

## 🏗️ Arquitetura

```
lib/
├── main.dart
├── models/          # Data models
├── services/        # Lógica de negócio + I/O
├── screens/         # Telas (UI)
├── widgets/         # Widgets reutilizáveis
├── theme/           # Material 3 theme
└── utils/           # Helpers e constantes
```

Detalhes em [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## 📚 Documentação

| Documento | Descrição |
|-----------|-----------|
| [`docs/SETUP.md`](docs/SETUP.md) | Configuração do ambiente |
| [`docs/BUILD.md`](docs/BUILD.md) | Como buildar por plataforma |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Estrutura e padrões |
| [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) | Deploy nas lojas |

## 🎨 Design

- **Cor principal:** Verde agro (`#2E7D32`)
- **UI:** Material 3
- **Responsividade:** Mobile / Tablet / Desktop

## 🤝 Contribuindo

1. Fork o repositório
2. Crie uma branch: `git checkout -b feature/minha-feature`
3. Commit: `git commit -m 'feat: adiciona X'`
4. Push: `git push origin feature/minha-feature`
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob licença MIT.
