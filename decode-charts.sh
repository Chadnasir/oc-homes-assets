#!/usr/bin/env bash
set -euo pipefail
for f in chart-irvine-2026-09-19.jpg chart-tustin-2026-09-19.jpg; do
  base64 -d < "${f}.b64.txt" > "$f"
  ls -la "$f"
done
git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
rm -f chart-irvine-2026-09-19.jpg.b64.txt chart-tustin-2026-09-19.jpg.b64.txt
git add -A
git status
git commit -m "Replace OC HOMES charts with HQ 860x420 JPEGs"
git push
