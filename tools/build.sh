#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Building Agrotrilho ==="

# Build native C++ library
echo ""
echo "--- Building native library ---"
cmake -S "$ROOT_DIR/native" -B "$ROOT_DIR/native/build" -DCMAKE_BUILD_TYPE=Release
cmake --build "$ROOT_DIR/native/build"
echo "Native build complete."

# Build Flutter app
echo ""
echo "--- Building Flutter app ---"
cd "$ROOT_DIR"
flutter pub get
flutter build apk --debug
echo "Flutter build complete."

echo ""
echo "=== Build finished ==="
