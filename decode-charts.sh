#!/usr/bin/env bash
set -euo pipefail

# Authoritative HQ sources (860x420, ~37KB / ~43KB) staged on Netlify.
# Do NOT prefer local zlib.b64 parts — those may be truncated/corrupt.
NETLIFY_BASE="https://spark-line-0goa.netlify.app"

fetch_hq() {
  local f="$1"
  echo "Fetching HQ $f from Netlify..."
  curl -fsSL -o "$f" "${NETLIFY_BASE}/${f}"
  # sanity: must be > 30KB
  local sz
  sz=$(wc -c < "$f")
  if [[ "$sz" -lt 30000 ]]; then
    echo "Refusing undersized chart $f ($sz bytes)" >&2
    exit 1
  fi
  ls -la "$f"
}

for f in chart-irvine-2026-09-19.jpg chart-tustin-2026-09-19.jpg; do
  fetch_hq "$f"
done

git config user.name "Chadnasir"
git config user.email "sales@realestateca.org"
# Remove helper payloads so they cannot poison a future decode
rm -f chart-*.jpg.b64.txt chart-*.jpg.b64.w* chart-*.jpg.b64.part* \
      chart-*.jpg.zlib.hex.txt chart-*.jpg.zlib.hex.part* \
      chart-*.jpg.zlib.b64.p* \
      hq-upload-probe.txt hq-size-test.txt hq-probe-enc.jpg || true
git add -A
git status
git commit -m "Replace OC HOMES charts with HQ 860x420 JPEGs (Netlify source)"
git push
