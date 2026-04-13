# Multi-Platform Migration Strategy

## Fase 1: Mobile (ATUAL) ✅

- **Android**: 100% funcional
- **iOS**: 100% funcional
- **Web**: desabilitado temporariamente (sem conflitos JSObject)

### Por que web foi desabilitado?

O pacote `web: 0.3.0` (dependência transitiva de alguns plugins) usa `JSObject`
como supertipo, o que é incompatível com certas versões do Dart/Flutter SDK.
Isso causava centenas de erros `The type 'JSObject' can't be used as supertype`
ao compilar para web.

A decisão foi compilar **apenas para mobile** até que as versões dos pacotes
sejam compatíveis com o SDK.

---

## Fase 2: Web (PRÓXIMA)

### Como re-habilitar web

1. **Recriar diretório web:**
   ```bash
   flutter create --platforms=web .
   ```

2. **Verificar compatibilidade de pacotes:**
   ```bash
   flutter pub outdated
   ```
   Certifique-se de que `mobile_scanner` e outros plugins suportam web sem
   conflitos de `JSObject`.

3. **Usar conditional imports para NFC:**
   ```dart
   // NFC não está disponível em web – use conditional imports
   import 'nfc_mobile.dart' if (dart.library.html) 'nfc_web_stub.dart';
   ```

4. **Testar ambos os targets:**
   ```bash
   flutter run                # Android
   flutter run -d chrome      # Web
   flutter test               # Unit tests
   ```

5. **Verificar que não há `dart:io` em código compartilhado:**
   ```bash
   grep -r "dart:io" lib/
   ```
   Se encontrar, use conditional imports ou `package:flutter/foundation.dart`.

### Padrão de Conditional Import

```dart
// ❌ NUNCA faça isso em código compartilhado:
import 'dart:io';

// ✅ Use o PlatformHelper existente (já seguro):
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;

// ✅ Ou use conditional imports para código platform-specific:
import 'mobile_impl.dart'
    if (dart.library.html) 'web_impl.dart';
```

---

## Estrutura de Serviços Platform-Safe

```
services/
├── qrcode_service.dart          # Genérico (funciona em web e mobile)
├── animal_service.dart          # Genérico (funciona em web e mobile)
├── qr_platform_service.dart     # Platform-aware QR scanning
├── nfc_platform_service.dart    # NFC mobile-only (safe no-op em web)
└── platform/
    └── MIGRATION_NOTES.md       # Este arquivo
```

## Checklist para Re-habilitação Web

- [ ] Atualizar Flutter SDK para versão compatível
- [ ] Verificar que `mobile_scanner` suporta web sem JSObject errors
- [ ] Recriar `web/` directory com `flutter create --platforms=web .`
- [ ] Adicionar web-specific service stubs (se necessário)
- [ ] Testar `flutter run -d chrome` sem erros
- [ ] Testar `flutter analyze` sem warnings
- [ ] Atualizar README com instruções web
