#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "sast review root: $ROOT"

if have semgrep; then
  note "semgrep scan"
  semgrep --config "${SEMGREP_CONFIG:-p/ci}" "$ROOT" --metrics=off || true
else
  skip "missing tool: semgrep"
fi

if have yamllint; then
  note "yamllint repo scan"
  yamllint "$ROOT" || true
else
  skip "missing tool: yamllint"
fi
