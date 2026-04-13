#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Cleaning Agrotrilho ==="

# Clean native build
echo "--- Cleaning native build ---"
rm -rf "$ROOT_DIR/native/build"
echo "Native build cleaned."

# Clean Flutter build
echo ""
echo "--- Cleaning Flutter build ---"
cd "$ROOT_DIR"
flutter clean
echo "Flutter build cleaned."

echo ""
echo "=== Clean finished ==="
