#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "incident triage root: $ROOT"
note "treating logs as sensitive; review output should be redacted"

if have git; then
  note "git status"
  git -C "$ROOT" status --short || true
fi

find "$ROOT" \( -name '*.log' -o -name 'incident*' -o -name '*timeline*' \) -type f | while IFS= read -r file; do
  note "candidate evidence: $file"
done
