#!/usr/bin/env bash
set -e

echo "🧹 Limpando build artifacts..."
flutter clean

echo "📦 Reinstalando dependências..."
flutter pub get

echo "✅ Limpeza completa!"
