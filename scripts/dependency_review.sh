#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "dependency review root: $ROOT"

if [ -f "$ROOT/pnpm-lock.yaml" ] && have pnpm; then
  note "pnpm audit"
  pnpm audit --prod || true
elif [ -f "$ROOT/package-lock.json" ] && have npm; then
  note "npm audit"
  npm audit --omit=dev --prefix "$ROOT" || true
elif [ -f "$ROOT/yarn.lock" ] && have yarn; then
  note "yarn audit"
  (cd "$ROOT" && yarn audit --groups dependencies) || true
else
  skip "no supported node dependency manifest or audit tool detected"
fi
