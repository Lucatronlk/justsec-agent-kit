#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "local pr guardrails root: $ROOT"
note "this lightweight local guard checks for available scanners and reminds you to enforce secrets, high, and critical findings before merge"

if have git; then
  note "changed files"
  git -C "$ROOT" diff --name-only --diff-filter=ACMRT HEAD~1..HEAD 2>/dev/null || git -C "$ROOT" diff --name-only --diff-filter=ACMRT || true
else
  skip "missing tool: git"
fi

note "recommended local gate order: secrets_review.sh, sast_review.sh, iac_deep_review.sh, targeted domain validators"
