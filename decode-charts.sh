#!/usr/bin/env bash
set -euo pipefail
for f in chart-irvine-2026-09-19.jpg chart-tustin-2026-09-19.jpg; do
  if [[ -f "${f}.b64.txt" ]]; then
    base64 -d < "${f}.b64.txt" > "$f"
  else
    cat $(ls ${f}.b64.w* | sort) > "${f}.b64.txt"
    base64 -d < "${f}.b64.txt" > "$f"
  fi
  ls -la "$f"
done
git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
rm -f chart-*.jpg.b64.txt chart-*.jpg.b64.w*
git add -A
git status
git commit -m "Replace OC HOMES charts with HQ 860x420 JPEGs"
git push
