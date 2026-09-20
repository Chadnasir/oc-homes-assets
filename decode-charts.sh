#!/usr/bin/env bash
set -euo pipefail
python3 << 'ENDPY'
import base64, pathlib, re
for stem in ["chart-irvine-2026-09-19", "chart-tustin-2026-09-19"]:
    chunks = sorted(pathlib.Path('.').glob(f"{stem}.b64.c*"), key=lambda p: int(re.search(r'c(\d+)$', p.name).group(1)))
    if not chunks:
        raise SystemExit(f'missing chunks for {stem}')
    b64 = ''.join(p.read_text().strip() for p in chunks)
    for p in chunks:
        p.unlink()
    out = pathlib.Path(f"{stem}.jpg")
    out.write_bytes(base64.b64decode(b64))
    print(out, out.stat().st_size)
for p in pathlib.Path('.').glob('chart-*.b64.*'):
    p.unlink(missing_ok=True)
for name in ['decode-charts.sh','.upload-test.txt','.upload-test2.txt','.byte-test.bin','test-push.txt','test3.txt','test4.txt']:
    pathlib.Path(name).unlink(missing_ok=True)
ENDPY
git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
git add -A
git status
git commit -m "Add OC HOMES market chart"
git push
