#!/usr/bin/env bash
set -e

echo "Formatando Dart..."
dart format lib test

echo "✅ Formatação completa!"
