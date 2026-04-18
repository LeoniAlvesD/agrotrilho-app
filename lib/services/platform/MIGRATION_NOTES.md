# Multi-Platform Notes

## Status ✅

| Plataforma | Status           |
|------------|-----------------|
| Android    | ✅ Funcional     |
| iOS        | ✅ Funcional     |
| Web        | ✅ Funcional     |

## JSObject Fix (resolvido)

O erro `The type 'JSObject' can't be used as supertype` era causado por
incompatibilidade entre o Dart SDK 3+ e o pacote `web: 0.3.0` (dependência
transitiva de alguns plugins).

**Solução aplicada:** `web: ^0.5.0` foi adicionado diretamente ao
`pubspec.yaml` para forçar a resolução para a versão compatível com Dart 3+.

```yaml
# pubspec.yaml
dependencies:
  web: ^0.5.0  # Fix JSObject incompatibility with Dart 3+
```

## Platform-Safe Code

Todo o código compartilhado usa `kIsWeb` e `defaultTargetPlatform`
(de `package:flutter/foundation.dart`) — nunca importa `dart:io` diretamente.

```dart
// ✅ Seguro para todos os targets:
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;

// ❌ Nunca em código compartilhado:
import 'dart:io';
```

## NFC

NFC não está disponível em web. O `NfcPlatformService` retorna `false` /
no-op automaticamente quando `PlatformHelper.isWeb` é verdadeiro.

## QR Scanner

- **Mobile**: usa câmera real via `MobileScanner`
- **Web**: exibe simulador via `WebQrSimulator`

