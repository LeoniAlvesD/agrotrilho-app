# 🚜 Agrotrilho

**Rastreabilidade animal para pequenos e médios produtores rurais.**

Sistema de gerenciamento e monitoramento de rebanho com identificação por QR Code e NFC, desenvolvido em Flutter.

## ✨ Funcionalidades do MVP

- **Cadastro de animais** — Nome, idade, peso e observações
- **Listagem de animais** — Lista dinâmica com informações resumidas
- **Detalhes do animal** — Todas as informações + QR Code gerado automaticamente
- **QR Code** — Geração automática por animal e leitura via câmera
- **NFC** — Leitura de tags NFC e associação com animais

## 📱 Tecnologia

- **Flutter** (Dart) — Framework mobile multiplataforma
- **Material 3** — Design system com tema verde agro
- **qr_flutter** — Geração de QR Codes
- **mobile_scanner** — Leitura de QR Code via câmera
- **nfc_manager** — Leitura de tags NFC/RFID

## 🏗️ Estrutura do Projeto

```
lib/
├── main.dart                    # App entry point + tema Material 3
├── models/
│   └── animal.dart              # Model Animal (id, nome, idade, peso, observações, nfcTagId)
├── screens/
│   ├── lista_animais.dart       # Dashboard: lista, QR scanner, NFC
│   ├── cadastro_animal.dart     # Formulário de cadastro com validação
│   ├── detalhe_animal.dart      # Detalhes + QR Code do animal
│   └── scanner_qrcode.dart      # Scanner de QR Code via câmera
└── widgets/
    └── animal_card.dart         # Card reutilizável de animal
```

## 🚀 Como Rodar

```bash
# Instalar dependências
flutter pub get

# Rodar no dispositivo/emulador
flutter run

# Rodar testes
flutter test
```

## 📦 Dependências

| Pacote | Uso |
|--------|-----|
| `qr_flutter` | Geração de QR Code |
| `mobile_scanner` | Leitura de QR Code via câmera |
| `nfc_manager` | Leitura de tags NFC |
| `uuid` | Geração de IDs únicos |

## 🎨 Design

- **Cor principal:** Verde agro (`#2E7D32`)
- **UI:** Material 3 com botões grandes e interface intuitiva
- **Ícones:** Material Icons

## 📝 Objetivo

Facilitar o controle de rebanho para pequenos produtores rurais de Goiás, com identificação rápida via QR Code e NFC, preparado para futuras integrações com backend, sincronização offline e conformidade PNIB.
