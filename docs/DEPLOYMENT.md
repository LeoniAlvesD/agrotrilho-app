# Deployment Guide

## Android — Google Play Store

1. Gere o **App Bundle** (AAB):

   ```bash
   flutter build appbundle --release
   ```

2. Acesse o [Google Play Console](https://play.google.com/console).
3. Crie ou selecione o app.
4. Vá em **Production > Create new release**.
5. Faça upload do `app-release.aab`.
6. Preencha as informações de release e envie para revisão.

## iOS — Apple App Store

1. Build de produção:

   ```bash
   flutter build ios --release
   ```

2. Abra `ios/Runner.xcworkspace` no Xcode.
3. Selecione **Any iOS Device** como destino.
4. **Product > Archive**.
5. No **Organizer**, clique em **Distribute App** e siga o assistente para
   enviar ao App Store Connect.

## Web

1. Build:

   ```bash
   flutter build web --release
   ```

2. A pasta `build/web/` contém os arquivos estáticos.
3. Hospede em qualquer CDN/servidor (Firebase Hosting, Netlify, Vercel, etc.):

   ```bash
   # Exemplo com Firebase Hosting
   firebase deploy --only hosting
   ```

## Versionamento

Atualize o campo `version` em `pubspec.yaml` antes de cada release:

```yaml
version: 1.2.0+5   # <semver>+<build-number>
```

Documente as mudanças em `CHANGELOG.md` seguindo o padrão
[Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).
