#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "secrets review root: $ROOT"

if have gitleaks; then
  note "gitleaks repo scan"
  gitleaks detect --source "$ROOT" --no-banner --redact || true
else
  skip "missing tool: gitleaks"
fi

if have trufflehog; then
  note "trufflehog filesystem scan"
  trufflehog filesystem "$ROOT" || true
else
  skip "missing tool: trufflehog"
fi

if have trivy; then
  note "trivy secret scan"
  trivy fs --scanners secret "$ROOT" || true
else
  skip "missing tool: trivy"
fi
