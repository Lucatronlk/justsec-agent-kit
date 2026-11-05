#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "pipeline review root: $ROOT"
run_if actionlint actionlint -color
run_if yamllint yamllint "$ROOT/.github/workflows" "$ROOT/.gitlab-ci.yml"

if have shellcheck; then
  find "$ROOT" -path '*/.github/workflows/*' -o -name '*.sh' | while IFS= read -r file; do
    [ -f "$file" ] || continue
    note "shellcheck $file"
    shellcheck "$file" || true
  done
else
  skip "missing tool: shellcheck"
fi
