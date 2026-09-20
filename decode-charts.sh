#!/usr/bin/env bash
set -euo pipefail
for f in chart-irvine-2026-09-19.jpg chart-tustin-2026-09-19.jpg; do
  base64 -d < "${f}.b64.txt" > "$f"
  ls -la "$f"
done
