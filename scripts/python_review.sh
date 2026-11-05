#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "python review root: $ROOT"
run_if ruff ruff check "$ROOT"
run_if bandit bandit -r "$ROOT"
run_if pytest pytest -q "$ROOT"
run_if pip-audit pip-audit
