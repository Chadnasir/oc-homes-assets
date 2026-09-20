#!/usr/bin/env bash
set -euo pipefail
python3 << 'ENDPY'
import base64, pathlib
for stem in ["chart-irvine-2026-09-19", "chart-tustin-2026-09-19"]:
    p = pathlib.Path(f"{stem}.b64.txt")
    b64 = p.read_text().strip()
    out = pathlib.Path(f"{stem}.jpg")
    out.write_bytes(base64.b64decode(b64))
    print(out, out.stat().st_size)
    p.unlink()
# cleanup helpers
for pat in ['chart-*.b64.*', 'decode-charts.sh', '.upload-test*', '.byte-test.bin', 'test*.txt']:
    for f in pathlib.Path('.').glob(pat):
        if f.name.endswith('.svg') or f.name.endswith('.jpg') or f.name == 'README.md':
            continue
        f.unlink(missing_ok=True)
ENDPY
git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
git add -A
git status
git commit -m "Add OC HOMES market chart"
git push
