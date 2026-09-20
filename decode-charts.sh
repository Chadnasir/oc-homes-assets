#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import base64, pathlib
for stem in ["chart-irvine-2026-09-19", "chart-tustin-2026-09-19"]:
    a = pathlib.Path(f"{stem}.b64.a.txt")
    b = pathlib.Path(f"{stem}.b64.b.txt")
    parts = sorted(pathlib.Path('.').glob(f"{stem}.b64.part*"))
    if a.exists() and b.exists():
        b64 = a.read_text().strip() + b.read_text().strip()
        a.unlink(); b.unlink()
    elif parts:
        b64 = ''.join(p.read_text().strip() for p in parts)
        for p in parts: p.unlink()
    else:
        p = pathlib.Path(f"{stem}.b64.txt")
        b64 = p.read_text().strip(); p.unlink()
    out = pathlib.Path(f"{stem}.jpg")
    out.write_bytes(base64.b64decode(b64))
    print(out, out.stat().st_size)
PY
git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
git add -A
git status
git commit -m "Add OC HOMES market chart"
git push
