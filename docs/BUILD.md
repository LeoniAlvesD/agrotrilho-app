# Build Guide

## Web

```bash
flutter build web
# Saída: build/web/
```

## Android

### APK (debug)

```bash
flutter build apk --debug
# Saída: build/app/outputs/flutter-apk/app-debug.apk
```

### APK (release)

```bash
flutter build apk --release
# Saída: build/app/outputs/flutter-apk/app-release.apk
```

### App Bundle (AAB) — recomendado para Play Store

```bash
flutter build appbundle
# Saída: build/app/outputs/bundle/release/app-release.aab
```

## iOS

```bash
flutter build ios
# Abrir Runner.xcworkspace no Xcode para arquivar e exportar IPA
```

> Requer macOS com Xcode instalado.

## Signing & Certificates

### Android

Crie `android/key.properties`:

```properties
storePassword=<senha>
keyPassword=<senha>
keyAlias=<alias>
storeFile=<caminho-para-keystore>
```

E referencie no `android/app/build.gradle`.

### iOS

Configure o **Signing & Capabilities** no Xcode com seu Apple Developer Team.

## Build Automático (CI)

O workflow `.github/workflows/build.yml` executa o build de APK em cada push
para `main`. O artefato fica disponível na aba **Actions** do repositório.
