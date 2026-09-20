#!/usr/bin/env bash
set -euo pipefail

decode_one() {
  local stem="$1"
  local jpg="${stem}.jpg"
  local parts
  mapfile -t parts < <(ls -1 "${stem}.jpg.zlib.b64.p"[0-9][0-9] 2>/dev/null | sort || true)
  if ((${#parts[@]} > 0)); then
    python3 - "$jpg" "${parts[@]}" <<'PY'
import sys, base64, zlib
from pathlib import Path
out = Path(sys.argv[1])
blob = "".join(Path(p).read_text().replace("\n","").replace(" ","") for p in sys.argv[2:])
out.write_bytes(zlib.decompress(base64.b64decode(blob)))
PY
  elif [[ -f "${jpg}.b64.txt" ]]; then
    base64 -d < "${jpg}.b64.txt" > "$jpg"
  else
    echo "No payload for $jpg" >&2
    exit 1
  fi
  base64 -w0 < "$jpg" > "${jpg}.b64.txt"
  ls -la "$jpg"
}

for f in chart-irvine-2026-09-19 chart-tustin-2026-09-19; do
  decode_one "$f"
done

git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
rm -f chart-*.jpg.b64.w* chart-*.jpg.b64.part* \
      chart-*.jpg.zlib.hex.txt chart-*.jpg.zlib.hex.part* \
      hq-upload-probe.txt hq-size-test.txt hq-probe-enc.jpg || true
git add -A
git status
git commit -m "Replace OC HOMES charts with HQ 860x420 JPEGs" || true
git push
