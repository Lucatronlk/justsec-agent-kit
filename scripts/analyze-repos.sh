#!/usr/bin/env bash
# Sequential dispatch only. Analysis instructions live in the shared skill.
# Requires Bash 4+, Git, GNU find/sort/realpath, Python + PyYAML, and the selected agent CLI.
# Git Bash: bash /d/Git/justsec-agent-kit/scripts/analyze-repos.sh --root /d/Git/DevSecOpsPlatform --dry-run
set -Eeuo pipefail

usage() {
  cat <<'EOF'
Usage: analyze-repos.sh [options]
  --root PATH       Collection directory (default: current directory)
  --agent NAME      codex or opencode (default: codex)
  --shared-dir PATH Shared checkout (default: parent of this script)
  --output-dir PATH Report directory (default: ROOT/intelligence/repositories)
  --max-depth N     Repository directory depth below root (default: 4; root is 0)
  --only REGEX      Include relative repository paths matching Bash ERE
  --skip REGEX      Exclude relative repository paths matching Bash ERE
  --force           Refresh analysis even if a current report exists
  --full            Request full Understand Anything analysis
  --dry-run         Print dispatch commands without running agents or creating reports
  -h, --help        Show help
Reports mirror relative repository paths, each ending in report.yaml.
Each invocation is a fresh session. No comparison or aggregation is performed.
EOF
}
die() { printf 'ERROR: %s\n' "$*" >&2; exit 2; }
value() { [[ $# -ge 2 && -n $2 ]] || die "Missing value for $1"; }
ROOT_DIR=$PWD
AGENT=codex
SHARED_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
OUTPUT_DIR=''
MAX_DEPTH=4
ONLY_PATTERN=''
SKIP_PATTERN=''
FORCE=false
FULL=false
DRY_RUN=false
while (($#)); do
  case $1 in
    --root) value "$@"; ROOT_DIR=$2; shift 2 ;;
    --agent) value "$@"; AGENT=$2; shift 2 ;;
    --shared-dir) value "$@"; SHARED_DIR=$2; shift 2 ;;
    --output-dir) value "$@"; OUTPUT_DIR=$2; shift 2 ;;
    --max-depth) value "$@"; MAX_DEPTH=$2; shift 2 ;;
    --only) value "$@"; ONLY_PATTERN=$2; shift 2 ;;
    --skip) value "$@"; SKIP_PATTERN=$2; shift 2 ;;
    --force) FORCE=true; shift ;;
    --full) FULL=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown argument: $1" ;;
  esac
done
[[ $AGENT == codex || $AGENT == opencode ]] || die 'Agent must be codex or opencode'
[[ $MAX_DEPTH =~ ^[0-9]+$ && ${#MAX_DEPTH} -le 3 ]] || die 'Depth must be an integer from 0 to 999'
MAX_DEPTH=$((10#$MAX_DEPTH))
for pattern in "$ONLY_PATTERN" "$SKIP_PATTERN"; do
  rc=0
  [[ '' =~ $pattern ]] || rc=$?
  ((rc != 2)) || die "Invalid regular expression: $pattern"
done
for dependency in git find sort realpath mktemp; do
  command -v "$dependency" >/dev/null || die "Missing dependency: $dependency"
done
ROOT_DIR=$(cd -- "$ROOT_DIR" && pwd -P) || die 'Invalid root directory'
SHARED_DIR=$(cd -- "$SHARED_DIR" && pwd -P) || die 'Invalid shared directory'
OUTPUT_DIR=$(realpath -m -- "${OUTPUT_DIR:-$ROOT_DIR/intelligence/repositories}")
AGENT_PATH=$SHARED_DIR/agents/devsecops-agent.md
SKILL_PATH=$SHARED_DIR/skills/repo-intelligence/SKILL.md
[[ -f $AGENT_PATH && -f $SKILL_PATH ]] || die 'Shared agent or skill missing'
if [[ $DRY_RUN == false ]]; then
  command -v "$AGENT" >/dev/null || die "Missing CLI: $AGENT"
  PYTHON=${PYTHON:-python}
  "$PYTHON" -c 'import yaml' || die 'Python with PyYAML required (set PYTHON to its executable)'
fi

# Temporary discovery lists keep find/sort errors observable; no repo/output writes in dry-run.
manifest=$(mktemp)
trap 'rm -f -- "$manifest"' EXIT
find "$ROOT_DIR" -maxdepth "$((MAX_DEPTH + 1))" \
  \( -type d \( -name node_modules -o -name .ua -o -name .repo-intelligence -o -name .venv -o -name intelligence \) -prune \) -o \
  \( -name .git \( -type d -o -type f \) -print0 -prune \) > "$manifest"
sort -zu -o "$manifest" "$manifest"
selected=0
failed=0
while IFS= read -r -d '' marker; do
  repo=${marker%/.git}
  # Reject .git lookalikes; .git files include linked worktrees and submodules.
  top=$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null) || continue
  [[ $(cd -- "$top" && pwd -P) == "$repo" ]] || continue
  if [[ $repo == "$ROOT_DIR" ]]; then relative=.; else relative=${repo#"$ROOT_DIR"/}; fi
  [[ -z $ONLY_PATTERN || $relative =~ $ONLY_PATTERN ]] || continue
  [[ -z $SKIP_PATTERN || ! $relative =~ $SKIP_PATTERN ]] || continue
  selected=$((selected + 1))
  # The root report is directly in OUTPUT_DIR, avoiding a reserved-name collision.
  report_dir=$OUTPUT_DIR
  [[ $relative == . ]] || report_dir=$OUTPUT_DIR/$relative
  output=$report_dir/report.yaml
  # %q encodes paths as data. This message only routes to the agent/skill with parameters.
  printf -v invocation 'Read and follow the shared agent at %q. Load its shared skill from skill_path=%q. Parameters (Bash-escaped values): repository=%q output_path=%q force=%s full=%s.' \
    "$AGENT_PATH" "$SKILL_PATH" "$repo" "$output" "$FORCE" "$FULL"
  if [[ $AGENT == codex ]]; then
    command_args=(codex exec --cd "$repo" --sandbox workspace-write --add-dir "$report_dir" "$invocation")
  else
    command_args=(opencode run --dir "$repo" "$invocation")
  fi
  printf '\nRepository: %s\nReport: %s\n' "$repo" "$output"
  if [[ $DRY_RUN == true ]]; then
    printf '%q ' "${command_args[@]}"
    printf '\n'
    continue
  fi
  if ! mkdir -p -- "$report_dir"; then failed=$((failed + 1)); continue; fi
  # No resume flags: each process gets its own repository context.
  if "${command_args[@]}" > "$report_dir/run.log" 2>&1 && [[ -s $output ]] && \
    "$PYTHON" "$SHARED_DIR/skills/repo-intelligence/scripts/validate-report.py" "$output" "$repo" >> "$report_dir/run.log" 2>&1; then
    printf 'Report available: %s\n' "$output"
  else
    printf 'FAILED or PARTIAL: %s (see %s/run.log)\n' "$relative" "$report_dir" >&2
    failed=$((failed + 1))
  fi
done < "$manifest"
printf '\nSelected: %s; failed: %s\n' "$selected" "$failed"
((selected > 0)) || exit 1
((failed == 0))
