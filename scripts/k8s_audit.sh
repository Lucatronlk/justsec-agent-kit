#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "kubernetes audit root: $ROOT"

if have helm; then
  find "$ROOT" -name Chart.yaml -printf '%h\n' | sort -u | while IFS= read -r chart; do
    note "helm lint $chart"
    helm lint "$chart" || true
  done
else
  skip "missing tool: helm"
fi

if have kubectl; then
  find "$ROOT" \( -name '*.yml' -o -name '*.yaml' \) | while IFS= read -r file; do
    note "kubectl dry-run $file"
    kubectl apply --dry-run=client -f "$file" >/dev/null || true
  done
else
  skip "missing tool: kubectl"
fi

run_if kubeconform kubeconform -summary "$ROOT"
