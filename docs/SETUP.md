# Setup Guide

## Requisitos

- **Flutter SDK** ≥ 3.2.0 — [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- **Dart SDK** ≥ 3.2.0 (incluído no Flutter)
- **Android Studio** ou **VS Code** com extensões Flutter/Dart

### Android

- Android SDK ≥ API 21 (Android 5.0)
- Java 17+
- Configurar `ANDROID_HOME` e `JAVA_HOME`

### iOS

- macOS com Xcode ≥ 14
- CocoaPods: `sudo gem install cocoapods`
- Conta Apple Developer (para dispositivo físico)

### Web

- Nenhum requisito extra além do Flutter SDK

## Instalação

```bash
# 1. Clonar o repositório
git clone https://github.com/LeoniAlvesD/agrotrilho-app.git
cd agrotrilho-app

# 2. Instalar dependências
flutter pub get

# 3. Verificar setup
flutter doctor
```

## Troubleshooting

### JSObject errors ao compilar para web

Certifique-se de que `pubspec.yaml` contém:

```yaml
dependencies:
  web: ^0.5.0
```

Em seguida limpe e reconstrua:

```bash
flutter clean
flutter pub get
```

### `flutter doctor` reporta problemas

Siga as instruções indicadas por `flutter doctor -v` para cada plataforma.

### Problemas com CocoaPods (iOS)

```bash
cd ios
pod install --repo-update
cd ..
flutter run -d ios
```

### Dependências Android desatualizadas

```bash
cd android
./gradlew dependencies
cd ..
```
