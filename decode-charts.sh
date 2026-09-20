#!/usr/bin/env bash
set -euo pipefail

# HQ chart sources staged on Netlify (860x420 JPEGs + matching b64.txt)
NETLIFY_BASE="https://spark-line-0goa.netlify.app"

fetch_hq() {
  local f="$1"
  # Prefer direct JPG (already HQ bytes)
  if curl -fsSL -o "$f" "${NETLIFY_BASE}/${f}"; then
    ls -la "$f"
    return 0
  fi
  # Fallback: b64.txt from Netlify
  if curl -fsSL -o "${f}.b64.txt" "${NETLIFY_BASE}/${f}.b64.txt"; then
    base64 -d < "${f}.b64.txt" > "$f"
    ls -la "$f"
    return 0
  fi
  # Legacy local payloads
  if [[ -f "${f}.b64.txt" ]]; then
    base64 -d < "${f}.b64.txt" > "$f"
  elif ls ${f}.b64.part* >/dev/null 2>&1; then
    cat $(ls ${f}.b64.part* | sort) > "${f}.b64.txt"
    base64 -d < "${f}.b64.txt" > "$f"
  elif ls ${f}.zlib.hex.part* >/dev/null 2>&1 || [[ -f "${f}.zlib.hex.txt" ]]; then
    if ls ${f}.zlib.hex.part* >/dev/null 2>&1; then
      cat $(ls ${f}.zlib.hex.part* | sort) > "${f}.zlib.hex.txt"
    fi
    python3 - "$f" <<'PY'
import sys, zlib
from pathlib import Path
f = sys.argv[1]
hx = "".join(Path(f"{f}.zlib.hex.txt").read_text().split())
Path(f).write_bytes(zlib.decompress(bytes.fromhex(hx)))
PY
  else
    cat $(ls ${f}.b64.w* | sort) > "${f}.b64.txt"
    base64 -d < "${f}.b64.txt" > "$f"
  fi
  ls -la "$f"
}

for f in chart-irvine-2026-09-19.jpg chart-tustin-2026-09-19.jpg; do
  fetch_hq "$f"
done

git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
rm -f chart-*.jpg.b64.txt chart-*.jpg.b64.w* chart-*.jpg.b64.part* \
      chart-*.jpg.zlib.hex.txt chart-*.jpg.zlib.hex.part*
git add -A
git status
git commit -m "Replace OC HOMES charts with HQ 860x420 JPEGs"
git push
