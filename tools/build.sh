#!/usr/bin/env bash
set -e

echo "🧹 Limpando..."
flutter clean

echo "📦 Atualizando dependências..."
flutter pub get

echo "📊 Analisando código..."
flutter analyze --no-fatal-infos

echo "🧪 Rodando testes..."
flutter test

echo "📱 Buildando APK (Android)..."
flutter build apk --release

echo "✅ Build completo!"
