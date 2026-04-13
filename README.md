# 🐄 Agrotrilho

Sistema de monitoramento e rastreamento de rebanho para pequenos produtores rurais.

## 📱 Funcionalidades

- **Cadastro de Animais**: Nome, idade, peso, observações e status
- **Listagem Dinâmica**: Busca por nome, filtro em tempo real
- **Detalhes Completos**: Informações, QR Code e tag NFC
- **QR Code**: Geração automática e leitura via câmera
- **NFC**: Estrutura pronta para associar tags NFC
- **Swipe para Remover**: Deslize para deletar da lista

## 🏗️ Estrutura do Projeto

```
lib/
├── main.dart                    # Configuração principal + tema Material 3
├── models/
│   └── animal.dart              # Model do animal com serialização
├── services/
│   ├── animal_service.dart      # Service com ChangeNotifier (Provider)
│   └── qrcode_service.dart      # Service de QR Code
├── screens/
│   ├── lista_animais.dart       # Tela principal com busca
│   ├── cadastro_animal.dart     # Cadastro/edição de animal
│   ├── detalhe_animal.dart      # Detalhes + QR Code + NFC
│   └── scanner_qrcode.dart      # Scanner QR Code via câmera
├── widgets/
│   ├── animal_card.dart         # Card reutilizável do animal
│   └── qrcode_widget.dart       # Widget de exibição QR Code
└── utils/
    └── constants.dart           # Cores, dimensões, mensagens
```

## 🛠️ Tecnologias

- **Flutter** (Dart) com Material 3
- **Provider** para gerenciamento de estado
- **mobile_scanner** para leitura de QR Code
- **qr_flutter** para geração de QR Code
- **nfc_manager** para suporte a NFC
- **uuid** para IDs únicos
- **intl** para formatação de datas

## 🚀 Como Rodar

```bash
# Instalar dependências
flutter pub get

# Rodar o app
flutter run

# Rodar testes
flutter test
```

## 🎨 Design

- Tema Verde Agro (#2E7D32, #66BB6A, #1B5E20)
- Interface simples e intuitiva
- Botões grandes e ícones claros
- Cards com gradientes suaves

## 📊 Dados de Exemplo

O app vem com 3 animais pré-cadastrados:
1. **Bessie** - Vaca leiteira, 36 meses, 450.5 kg
2. **Touro Rex** - Reprodutor, 48 meses, 550 kg
3. **Mimi** - Filhote, 12 meses, 200 kg

## 📦 Dependências

| Pacote | Versão | Uso |
|--------|--------|-----|
| provider | ^6.0.0 | Gerenciamento de estado |
| mobile_scanner | ^4.1.0 | Scanner QR Code |
| qr_flutter | ^4.1.0 | Geração de QR Code |
| nfc_manager | ^3.8.0+1 | Suporte a NFC |
| uuid | ^4.0.0 | IDs únicos |
| intl | ^0.19.0 | Formatação de datas |

## 📌 Objetivo

Facilitar o controle de rebanho para pequenos produtores rurais com uma solução moderna, acessível e preparada para futura integração com APIs.
