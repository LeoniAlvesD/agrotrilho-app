# Agrotrilho 🚜

Sistema de monitoramento e rastreamento de rebanho para pequenos e médios produtores rurais.

## Funcionalidades

- 📋 Cadastro de animais (nome, idade, peso, raça)
- 📍 Rastreamento por GPS
- 🗺️ Cálculo de distância percorrida (fórmula de Haversine)
- 🔔 Geofencing — alerta quando o animal sai de uma área
- 📊 Histórico de movimentação

## Stack Tecnológico

| Camada | Tecnologia |
|--------|-----------|
| App (UI) | Flutter / Dart |
| Código nativo | C++17 |
| Build nativo | CMake 3.16+ |
| CI/CD | GitHub Actions |

## Estrutura do Projeto

```
agrotrilho-app/
├── lib/                   # Código Dart (Flutter)
│   ├── main.dart
│   ├── models/            # Modelos de dados
│   ├── screens/           # Telas do app
│   ├── widgets/           # Widgets reutilizáveis
│   └── utils/             # Utilitários e constantes
├── test/                  # Testes Flutter
├── native/                # Código C++ nativo
│   ├── include/agrotrilho/
│   ├── src/
│   └── CMakeLists.txt
├── tools/                 # Scripts de build e formatação
├── docs/                  # Documentação adicional
├── android/               # Configuração Android
├── ios/                   # Configuração iOS
├── linux/                 # Configuração Linux
├── macos/                 # Configuração macOS
├── web/                   # Configuração Web
├── windows/               # Configuração Windows
└── .github/workflows/     # CI/CD
```

## Pré-requisitos

- [Flutter](https://flutter.dev/) 3.x
- [Dart](https://dart.dev/) 3.x
- [CMake](https://cmake.org/) 3.16+
- Compilador C++17 (gcc 9+, clang 10+, ou MSVC 2019+)

## Início Rápido

```bash
# Clone o repositório
git clone https://github.com/LeoniAlvesD/agrotrilho-app.git
cd agrotrilho-app

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

### Build do código nativo

```bash
cmake -S native -B native/build -DCMAKE_BUILD_TYPE=Release
cmake --build native/build
```

### Scripts auxiliares

```bash
./tools/build.sh    # Build completo (nativo + Flutter)
./tools/format.sh   # Formatar Dart e C++
./tools/clean.sh    # Limpar artefatos de build
```

## Testes

```bash
flutter test
```

## Contribuindo

1. Crie um fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/minha-feature`)
3. Faça commit das alterações (`git commit -m 'feat: minha feature'`)
4. Envie para a branch (`git push origin feature/minha-feature`)
5. Abra um Pull Request

## Documentação

Consulte [docs/SETUP.md](docs/SETUP.md) para instruções detalhadas de configuração do ambiente.

## Licença

Este projeto é de uso privado.
