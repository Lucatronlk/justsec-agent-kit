#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "monitoring review root: $ROOT"

if have promtool; then
  find "$ROOT" \( -name 'prometheus.yml' -o -name 'prometheus.yaml' \) | while IFS= read -r file; do
    note "promtool check config $file"
    promtool check config "$file" || true
  done
  find "$ROOT" \( -name 'alert.rules' -o -name '*.rules.yml' -o -name '*.rules.yaml' \) | while IFS= read -r file; do
    note "promtool check rules $file"
    promtool check rules "$file" || true
  done
else
  skip "missing tool: promtool"
fi

if have docker; then
  find "$ROOT" \( -name 'docker-compose.yml' -o -name 'docker-compose.yaml' \) | while IFS= read -r file; do
    note "docker compose config $file"
    docker compose -f "$file" config >/dev/null || true
  done
fi
