#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "python quality and testing review root: $ROOT"
run_if ruff ruff check "$ROOT"
run_if pytest pytest -q "$ROOT"
run_if mypy mypy "$ROOT"
run_if pyright pyright "$ROOT"

if have python; then
  note "python compile check"
  python -m compileall -q "$ROOT" || true
else
  skip "missing tool: python"
fi

run_if coverage coverage report --show-missing
