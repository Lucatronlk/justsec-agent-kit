#!/usr/bin/env bash
#
# Sync justsec-agent-kit into the global OpenCode config (~/.config/opencode) on
# macOS/Linux.
#
# Structure this script assumes (current justsec-agent-kit layout):
#
#   skills/                one directory per skill, each with a SKILL.md
#                          -> symlinked individually into global skill/
#   agents/*-agent.md      six top-level domain-agent personas
#                          -> symlinked as global agent files (no subdirectories)
#   instructions/          domain standards, NOT touched here (loaded via the
#                          'instructions' array in opencode.json)
#
# Unlike the Windows PowerShell version, this script uses real symlinks for
# BOTH skills and agents, so agent edits apply immediately. Re-run only when
# you add or remove a skill/agent.
#
# Usage:
#   bash scripts/sync-global-opencode.sh
#   SHARED_DIR=/path/to/justsec-agent-kit GLOBAL_DIR=/custom/config bash scripts/sync-global-opencode.sh
#
set -euo pipefail

# Resolve the repo root as the parent of this script's directory, unless
# overridden explicitly via SHARED_DIR.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
SHARED_DIR="${SHARED_DIR:-$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd -P)}"
GLOBAL_DIR="${GLOBAL_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/opencode}"

if [[ ! -d "${SHARED_DIR}/skills" || ! -d "${SHARED_DIR}/agents" ]]; then
    echo "error: SHARED_DIR does not look like an justsec-agent-kit checkout: ${SHARED_DIR}" >&2
    exit 1
fi

SKILL_DIR="${GLOBAL_DIR}/skill"
AGENT_DIR="${GLOBAL_DIR}/agent"

mkdir -p "${SKILL_DIR}" "${AGENT_DIR}"

echo "Shared source : ${SHARED_DIR}"
echo "Global target : ${GLOBAL_DIR}"
echo

echo "== Syncing skills (symlinked directories) =="
skill_count=0
declare -A seen_names=()

# Warn about duplicate skill folder names (only one can be linked by name).
while IFS= read -r -d '' skill_md; do
    name="$(basename -- "$(dirname -- "${skill_md}")")"
    seen_names["${name}"]=$(( ${seen_names["${name}"]:-0} + 1 ))
done < <(find "${SHARED_DIR}/skills" -type f -name "SKILL.md" -print0)

for name in "${!seen_names[@]}"; do
    if (( ${seen_names[${name}]} > 1 )); then
        echo "  warning: duplicate skill folder name '${name}' in ${seen_names[${name}]} paths; only the first is linked" >&2
    fi
done

# Sort for deterministic "first wins" behavior on duplicate names.
declare -A processed_names=()
while IFS= read -r -d '' skill_md; do
    skill_dir="$(dirname -- "${skill_md}")"
    name="$(basename -- "${skill_dir}")"
    dest="${SKILL_DIR}/${name}"

    # Duplicate folder name already linked this run -> first wins.
    if [[ -n "${processed_names[${name}]:-}" ]]; then
        continue
    fi
    processed_names["${name}"]=1

    if [[ -e "${dest}" && ! -L "${dest}" ]]; then
        echo "  skip (existing non-symlink path is in the way): ${name}" >&2
        continue
    fi

    if [[ -L "${dest}" ]]; then
        current_target="$(readlink -f "${dest}" || true)"
        case "${current_target}" in
            "${SHARED_DIR}"/skills/*) : ;;  # managed by us -> safe to refresh
            *) echo "  skip (existing link points outside this checkout): ${name} -> ${current_target}" >&2
               continue ;;
        esac
    fi

    ln -sfn "${skill_dir}" "${dest}"
    echo "  linked: ${name}"
    skill_count=$((skill_count + 1))
done < <(find "${SHARED_DIR}/skills" -type f -name "SKILL.md" -print0 | sort -z)

# Prune symlinks created by this script whose source skill no longer exists.
pruned=0
for entry in "${SKILL_DIR}"/*; do
    [[ -L "${entry}" ]] || continue
    name="$(basename -- "${entry}")"
    [[ -n "${seen_names[${name}]:-}" ]] && continue
    target="$(readlink -f "${entry}" || true)"
    case "${target}" in
        "${SHARED_DIR}"/skills/*)
            rm -f -- "${entry}"
            echo "  pruned stale skill: ${name}"
            pruned=$((pruned + 1))
            ;;
    esac
done

echo
echo "== Syncing agents (symlinked files) =="
# Top-level *-agent.md only. agents/ contains no skill copies or subdirectories.
agent_count=0
while IFS= read -r -d '' agent_md; do
    name="$(basename -- "${agent_md}")"
    dest="${AGENT_DIR}/${name}"

    if [[ -e "${dest}" && ! -L "${dest}" ]]; then
        echo "  skip (existing non-symlink is in the way): ${name}" >&2
        continue
    fi

    ln -sfn "${agent_md}" "${dest}"
    echo "  linked: ${name}"
    agent_count=$((agent_count + 1))
done < <(find "${SHARED_DIR}/agents" -maxdepth 1 -type f -name "*-agent.md" -print0 | sort -z)

# Prune agent symlinks created by this script whose source agent no longer exists.
for entry in "${AGENT_DIR}"/*; do
    [[ -L "${entry}" ]] || continue
    target="$(readlink -f "${entry}" || true)"
    case "${target}" in
        "${SHARED_DIR}"/agents/*)
            [[ -e "${target}" ]] && continue
            name="$(basename -- "${entry}")"
            rm -f -- "${entry}"
            echo "  pruned stale agent: ${name}"
            ;;
    esac
done

echo
echo "Done. Skills linked: ${skill_count} (stale pruned: ${pruned})  Agents linked: ${agent_count}"
echo "Both skills and agents are symlinks here, so edits in ${SHARED_DIR} take effect"
echo "immediately. Re-run this script only when you add/remove a skill or agent."
echo
echo "Reminder: instructions are wired via the 'instructions' array in"
echo "${GLOBAL_DIR}/opencode.json (or opencode.jsonc) -- this script does not touch that file."
echo "Add each instructions/**/*.instructions.md path you want loaded globally, e.g.:"
echo '  "instructions": ["'"${SHARED_DIR}"'/AGENTS.md", "'"${SHARED_DIR}"'/instructions/terraform/terraform-review.instructions.md"]'
