#!/usr/bin/env bash
set -euo pipefail

have() {
  command -v "$1" >/dev/null 2>&1
}

note() {
  printf '[info] %s\n' "$*"
}

skip() {
  printf '[skip] %s\n' "$*"
}

run_if() {
  local tool="$1"
  shift
  if have "$tool"; then
    note "$*"
    "$@"
  else
    skip "missing tool: $tool"
  fi
}
