#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "deep iac review root: $ROOT"

if ! find "$ROOT" \( -name '*.tf' -o -name '.terraform.lock.hcl' -o -name 'Chart.yaml' -o -name 'values.yaml' -o -name 'Dockerfile' -o -name 'DockerFile' -o -name '*.yml' -o -name '*.yaml' \) | grep -q .; then
  skip "no obvious IaC or config files detected"
  exit 0
fi

if have trivy; then
  note "trivy config scan"
  trivy config "$ROOT" --severity HIGH,CRITICAL || true
else
  skip "missing tool: trivy"
fi

if have checkov; then
  note "checkov multi-framework scan"
  checkov -d "$ROOT" --framework terraform,kubernetes,helm,dockerfile,serverless || true
else
  skip "missing tool: checkov"
fi

if have kics; then
  note "kics iac scan"
  kics scan --path "$ROOT" --silent --no-color || true
else
  skip "missing tool: kics"
fi

if have tfsec && find "$ROOT" -name '*.tf' | grep -q .; then
  note "tfsec scan"
  tfsec "$ROOT" || true
else
  skip "missing tool or terraform scope: tfsec"
fi

if have tflint && find "$ROOT" -name '*.tf' | grep -q .; then
  note "tflint scan"
  tflint --chdir "$ROOT" || true
else
  skip "missing tool or terraform scope: tflint"
fi
