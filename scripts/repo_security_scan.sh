#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
SCRIPT_DIR="$(dirname "$0")"
. "$SCRIPT_DIR/_lib.sh"

note "repo security scan root: $ROOT"

"$SCRIPT_DIR/secrets_review.sh" "$ROOT" || true
"$SCRIPT_DIR/sast_review.sh" "$ROOT" || true
"$SCRIPT_DIR/dependency_review.sh" "$ROOT" || true
"$SCRIPT_DIR/iac_deep_review.sh" "$ROOT" || true
"$SCRIPT_DIR/docker_hardening.sh" "$ROOT" || true
"$SCRIPT_DIR/python_review.sh" "$ROOT" || true
"$SCRIPT_DIR/pipeline_review.sh" "$ROOT" || true

if have promtool || find "$ROOT" \( -name 'prometheus.yml' -o -name 'prometheus.yaml' -o -name 'alert.rules' \) | grep -q .; then
  "$SCRIPT_DIR/monitoring_review.sh" "$ROOT" || true
fi
