#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import base64, pathlib
for stem in ["chart-irvine-2026-09-19", "chart-tustin-2026-09-19"]:
    b64 = pathlib.Path(f"{stem}.b64.txt").read_text().strip()
    out = pathlib.Path(f"{stem}.jpg")
    out.write_bytes(base64.b64decode(b64))
    print(out, out.stat().st_size)
    pathlib.Path(f"{stem}.b64.txt").unlink()
PY
git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
git add -A
git status
git commit -m "Add OC HOMES market chart"
git push
