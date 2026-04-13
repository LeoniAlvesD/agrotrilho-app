#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Formatting Agrotrilho ==="

# Format Dart code
echo ""
echo "--- Formatting Dart ---"
dart format "$ROOT_DIR/lib" "$ROOT_DIR/test"
echo "Dart formatting complete."

# Format C++ code
echo ""
echo "--- Formatting C++ ---"
if command -v clang-format &> /dev/null; then
    find "$ROOT_DIR/native" \( -name '*.cpp' -o -name '*.h' \) \
        -exec clang-format -i {} +
    echo "C++ formatting complete."
else
    echo "clang-format not found, skipping C++ formatting."
fi

echo ""
echo "=== Formatting finished ==="
