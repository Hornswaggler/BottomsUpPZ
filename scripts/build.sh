#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="$ROOT_DIR/dist"
items=(
    "Contents"
    "images"
    "LICENSE"
    "preview.png"
    "README.md"
    "workshop.txt"
)

mkdir -p -- "$OUTPUT_DIR"
find "$OUTPUT_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +

for item in "${items[@]}"; do
    cp -R -- "$ROOT_DIR/$item" "$OUTPUT_DIR/"
done
