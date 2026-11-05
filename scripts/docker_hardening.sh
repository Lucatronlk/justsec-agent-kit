#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "docker review root: $ROOT"

if have hadolint; then
  find "$ROOT" \( -name 'Dockerfile' -o -name 'DockerFile' \) | while IFS= read -r file; do
    note "hadolint $file"
    hadolint "$file" || true
  done
else
  skip "missing tool: hadolint"
fi

if have docker; then
  find "$ROOT" \( -name 'docker-compose.yml' -o -name 'docker-compose.yaml' \) | while IFS= read -r file; do
    note "docker compose config $file"
    docker compose -f "$file" config >/dev/null || true
  done
else
  skip "missing tool: docker"
fi
