#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$(pwd)}"
. "$(dirname "$0")/_lib.sh"

note "log pipeline review root: $ROOT"

if have vector; then
  find "$ROOT" \( -name 'vector*.yml' -o -name 'vector*.yaml' -o -name 'vector.toml' \) | while IFS= read -r file; do
    note "vector validate $file"
    vector validate --config-yaml "$file" || true
  done
else
  skip "missing tool: vector"
fi

if have logstash; then
  find "$ROOT" \( -name 'logstash.conf' -o -path '*/pipeline/*.conf' \) | while IFS= read -r file; do
    note "logstash test $file"
    logstash --path.settings "$(dirname "$file")" --config.test_and_exit -f "$file" || true
  done
else
  skip "missing tool: logstash"
fi

if have docker; then
  find "$ROOT" \( -name 'docker-compose.yml' -o -name 'docker-compose.yaml' \) | while IFS= read -r file; do
    note "docker compose config $file"
    docker compose -f "$file" config >/dev/null || true
  done
fi
