# Configuração do Ambiente — Agrotrilho

## Pré-requisitos

| Ferramenta | Versão mínima |
|-----------|--------------|
| Flutter   | 3.x          |
| Dart      | 3.x          |
| CMake     | 3.16+        |
| Compilador C++ | C++17 (gcc 9+, clang 10+, MSVC 2019+) |
| Git       | 2.x          |

## Instalação

### macOS

```bash
# Flutter
brew install --cask flutter

# CMake e compilador
brew install cmake
xcode-select --install
```

### Linux (Ubuntu/Debian)

```bash
# Flutter — siga https://docs.flutter.dev/get-started/install/linux
sudo snap install flutter --classic

# CMake e compilador
sudo apt update
sudo apt install cmake build-essential clang-format
```

### Windows

1. Instale o [Flutter SDK](https://docs.flutter.dev/get-started/install/windows).
2. Instale o [CMake](https://cmake.org/download/).
3. Instale o [Visual Studio](https://visualstudio.microsoft.com/) com o workload **Desktop development with C++**.

## Primeiros passos

```bash
# Clone o repositório
git clone https://github.com/LeoniAlvesD/agrotrilho-app.git
cd agrotrilho-app

# Instale as dependências Flutter
flutter pub get

# Compile o código nativo
cmake -S native -B native/build -DCMAKE_BUILD_TYPE=Release
cmake --build native/build

# Execute o app (modo debug)
flutter run
```

## Scripts auxiliares

| Script | Descrição |
|--------|-----------|
| `tools/build.sh` | Compila código nativo e o app Flutter |
| `tools/format.sh` | Formata código Dart e C++ |
| `tools/clean.sh` | Remove artefatos de build |

## Executando os testes

```bash
flutter test
```

## Problemas comuns

### `flutter: command not found`
Verifique se o Flutter está no `PATH`. Adicione ao `~/.bashrc` ou `~/.zshrc`:
```bash
export PATH="$PATH:/caminho/para/flutter/bin"
```

### Erro de compilação C++
Certifique-se de ter um compilador C++17 instalado e que o CMake encontra o compilador:
```bash
cmake -S native -B native/build
```
