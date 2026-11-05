#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "terraform review root: $ROOT"
if ! find "$ROOT" -name '*.tf' -o -name '.terraform.lock.hcl' | grep -q .; then
  skip "no terraform files detected"
  exit 0
fi

run_if terraform terraform fmt -check -recursive "$ROOT"

if have terraform; then
  while IFS= read -r dir; do
    note "terraform validate in $dir"
    (cd "$dir" && terraform validate) || true
  done < <(find "$ROOT" -name '*.tf' -printf '%h\n' | sort -u)
fi

run_if tflint tflint --chdir "$ROOT"
run_if tfsec tfsec "$ROOT"
run_if checkov checkov -d "$ROOT"
