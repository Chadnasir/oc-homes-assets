#!/usr/bin/env bash
set -euo pipefail

decode_one() {
  local f="$1"
  if [[ -f "${f}.zlib.hex.txt" ]]; then
    python3 - "$f" <<'PY'
import sys, zlib
from pathlib import Path
f = sys.argv[1]
hx = "".join(Path(f"{f}.zlib.hex.txt").read_text().split())
Path(f).write_bytes(zlib.decompress(bytes.fromhex(hx)))
PY
  elif ls ${f}.zlib.hex.part* >/dev/null 2>&1; then
    cat $(ls ${f}.zlib.hex.part* | sort) > "${f}.zlib.hex.txt"
    python3 - "$f" <<'PY'
import sys, zlib
from pathlib import Path
f = sys.argv[1]
hx = "".join(Path(f"{f}.zlib.hex.txt").read_text().split())
Path(f).write_bytes(zlib.decompress(bytes.fromhex(hx)))
PY
  elif [[ -f "${f}.b64.txt" ]]; then
    base64 -d < "${f}.b64.txt" > "$f"
  elif ls ${f}.b64.part* >/dev/null 2>&1; then
    cat $(ls ${f}.b64.part* | sort) > "${f}.b64.txt"
    base64 -d < "${f}.b64.txt" > "$f"
  else
    cat $(ls ${f}.b64.w* | sort) > "${f}.b64.txt"
    base64 -d < "${f}.b64.txt" > "$f"
  fi
  ls -la "$f"
}

for f in chart-irvine-2026-09-19.jpg chart-tustin-2026-09-19.jpg; do
  decode_one "$f"
done

git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
rm -f chart-*.jpg.b64.txt chart-*.jpg.b64.w* chart-*.jpg.b64.part* \
      chart-*.jpg.zlib.hex.txt chart-*.jpg.zlib.hex.part*
git add -A
git status
git commit -m "Replace OC HOMES charts with HQ 860x420 JPEGs"
git push
