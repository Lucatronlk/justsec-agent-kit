#!/usr/bin/env python3
"""Synchronize agent skill allow-lists from agents/skill-agent-index.md.

Usage (from any directory):
    python scripts/sync-agent-skill-permissions.py [--check]
    python scripts/sync-agent-skill-permissions.py --write

--check is the default and never writes. --write validates the entire index and all
agent frontmatter before replacing only permission.skill entries. It does not
install anything or modify skill files, the index, or agent body text.
"""

from __future__ import annotations

import argparse
from collections import defaultdict
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent.parent
AGENTS = frozenset({
    "devsecops-agent", "python-agent", "typescript-agent", "migration-agent",
    "ai-llmops-agent", "observability-sre-agent",
})
NAME = re.compile(r"[a-z0-9]+(?:-[a-z0-9]+)*\Z")
ROW = re.compile(r"\| `([^`]+)` \| `([^`]+)` \| ([^|]+) \|\Z")
KEY = re.compile(r"([A-Za-z_][\w-]*):(?:\s*(.*))?\Z")
ENTRY = re.compile(r'    (?:"([^"]+)"|\'([^\']+)\'|([^:\s]+)): (allow|deny)\s*\Z')


class Invalid(ValueError):
    """Unsafe or malformed input: stop before changing files."""


def require(test: bool, message: str) -> None:
    if not test:
        raise Invalid(message)


def text(path: Path) -> str:
    require(path.is_relative_to(ROOT) and all(not part.is_symlink()
            for part in (path, *path.parents) if part != ROOT),
            f"unsafe symlinked path: {path}")
    require(path.is_file(), f"missing file: {path}")
    return path.read_bytes().decode("utf-8")


def frontmatter(source: str, label: str) -> list[str]:
    lines = source.splitlines(keepends=True)
    require(bool(lines) and lines[0].strip() == "---", f"{label}: missing frontmatter")
    try:
        end = next(i for i in range(1, len(lines)) if lines[i].strip() == "---")
    except StopIteration as exc:
        raise Invalid(f"{label}: unclosed frontmatter") from exc
    return lines[:end + 1]


def skill_name(path: Path) -> str:
    fm = frontmatter(text(ROOT / path), str(path))
    names = [m.group(1).strip().strip('"\'') for line in fm[1:-1]
             if (m := re.fullmatch(r"name:\s*(.*?)\s*", line.strip()))]
    require(len(names) == 1 and bool(NAME.fullmatch(names[0])), f"{path}: invalid/duplicate name")
    return names[0]


def index_mapping() -> dict[str, set[str]]:
    lines = text(ROOT / "agents/skill-agent-index.md").splitlines()
    require(lines.count("## Full Matrix") == 1, "index: missing/duplicate Full Matrix")
    require(lines.count("## Agents") == 1, "index: missing/duplicate Agents table")
    agent_start = lines.index("## Agents")
    matrix_start = lines.index("## Full Matrix")
    require(agent_start < matrix_start, "index: incorrect section order")
    agent_rows = [line for line in lines[agent_start + 1:matrix_start] if line.startswith("|")]
    require(agent_rows[:2] == ["| Agent | File | Skills |", "|---|---|---|"],
            "index: malformed Agents table")
    counts: dict[str, int] = {}
    for line in agent_rows[2:]:
        m = re.fullmatch(r"\| ([a-z-]+) \| `agents/([^`/]+)\.md` \| (\d+) \|", line)
        require(m is not None, f"index: malformed agent row: {line}")
        agent, file, count = m.groups()
        require(agent in AGENTS and file == agent and agent not in counts,
                f"index: unknown/duplicate agent: {agent}")
        counts[agent] = int(count)
    require(set(counts) == AGENTS, "index: missing agent(s)")
    agent_files = {p.stem for p in (ROOT / "agents").glob("*-agent.md")}
    require(agent_files == AGENTS, f"unknown/missing agent files: {sorted(agent_files ^ AGENTS)}")

    rows = [line for line in lines[matrix_start + 1:] if line.strip()]
    require(rows[:2] == ["| skill | path | agent(s) |", "|---|---|---|"],
            "index: malformed Full Matrix header")
    mapping: dict[str, set[str]] = defaultdict(set)
    paths: set[Path] = set()
    names: set[str] = set()
    for line in rows[2:]:
        m = ROW.fullmatch(line)
        require(m is not None, f"index: malformed matrix row: {line}")
        name, raw_path, raw_agents = m.groups()
        path = Path(raw_path)
        require(bool(NAME.fullmatch(name)) and raw_path.startswith("skills/")
                and path.parts[-1] == "SKILL.md" and ".." not in path.parts
                and path not in paths and name not in names,
                f"index: unsafe/duplicate skill: {name} ({raw_path})")
        require(skill_name(path) == name, f"index: frontmatter name mismatch: {path}")
        members = raw_agents.split(", ")
        require(bool(members) and len(members) == len(set(members))
                and set(members) <= AGENTS, f"index: unknown/duplicate agent for {name}")
        names.add(name)
        paths.add(path)
        for agent in members:
            mapping[agent].add(name)
    # Only SKILL.md paths are examined; never read credentials or unrelated files.
    disk_paths = {p.relative_to(ROOT) for p in (ROOT / "skills").rglob("SKILL.md")}
    require(not (disk_paths - paths) and not (paths - disk_paths),
            "index: unindexed or missing skill paths: "
            f"unindexed={sorted(map(str, disk_paths - paths))} "
            f"missing={sorted(map(str, paths - disk_paths))}")
    require(bool(names), "index: no skills mapped")
    for agent in AGENTS:
        require(len(mapping[agent]) == counts[agent], f"index: incorrect count for {agent}")
    return mapping


def agent_block(agent: str) -> tuple[str, list[str], int, int, dict[str, str]]:
    source = text(ROOT / "agents" / f"{agent}.md")
    fm = frontmatter(source, agent)
    require(source.startswith("".join(fm)), f"{agent}: invalid frontmatter layout")
    top: dict[str, int] = {}
    for i, line in enumerate(fm[1:-1], 1):
        if line and not line[0].isspace() and not line.lstrip().startswith("#"):
            m = KEY.fullmatch(line.rstrip("\r\n"))
            require(m is not None and m.group(1) not in top, f"{agent}: malformed/duplicate top key")
            top[m.group(1)] = i
    require("permission" in top and "name" in top, f"{agent}: missing name/permission")
    name_line = fm[top["name"]].strip()
    require(name_line == f"name: {agent}", f"{agent}: name mismatch")
    p = top["permission"]
    require(fm[p].strip() == "permission:", f"{agent}: malformed permission")
    end_permission = min((i for i in top.values() if i > p), default=len(fm) - 1)
    subkeys: dict[str, int] = {}
    for i in range(p + 1, end_permission):
        line = fm[i].rstrip("\r\n")
        if line.startswith("  ") and not line.startswith("   ") and not line.strip().startswith("#"):
            m = KEY.fullmatch(line[2:])
            require(m is not None and m.group(1) not in subkeys,
                    f"{agent}: malformed/duplicate permission key")
            subkeys[m.group(1)] = i
    require("skill" in subkeys and fm[subkeys["skill"]].strip() == "skill:",
            f"{agent}: missing/malformed permission.skill")
    start = subkeys["skill"] + 1
    end = min((i for i in subkeys.values() if i >= start), default=end_permission)
    entries: dict[str, str] = {}
    for line in fm[start:end]:
        m = ENTRY.fullmatch(line.rstrip("\r\n"))
        require(m is not None, f"{agent}: malformed permission.skill entry: {line.strip()}")
        key = next(group for group in m.groups()[:3] if group is not None)
        require(key not in entries, f"{agent}: duplicate skill entry: {key}")
        entries[key] = m.group(4)
    require(entries.get("*") == "deny", f"{agent}: wildcard must be deny")
    require(all(k == "*" or NAME.fullmatch(k) for k in entries),
            f"{agent}: invalid skill key")
    return source, fm, start, end, entries


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true", help="validate without writing (default)")
    mode.add_argument("--write", action="store_true", help="synchronize permission.skill lists")
    args = parser.parse_args()
    try:
        mapping = index_mapping()
        pending = []
        for agent in sorted(AGENTS):
            source, fm, start, end, entries = agent_block(agent)
            expected = mapping[agent]
            actual = {key for key, value in entries.items() if key != "*" and value == "allow"}
            stale = set(entries) - actual - {"*"}
            if expected != actual or stale:
                print(f"{agent}: missing={sorted(expected - actual)} extra={sorted(actual - expected)} "
                      f"non-allow={sorted(stale)}")
                newline = "\r\n" if "\r\n" in fm[0] else "\n"
                replacement = [f'    "*": deny{newline}'] + [
                    f'    "{name}": allow{newline}' for name in sorted(expected)
                ]
                new_source = "".join(fm[:start] + replacement + fm[end:]) + source[len("".join(fm)):]
                pending.append((ROOT / "agents" / f"{agent}.md", new_source))
        if pending and not args.write:
            print(f"FAIL: {len(pending)} agent skill list(s) differ; use --write to synchronize")
            return 1
        if args.write:
            for path, content in pending:
                path.write_bytes(content.encode("utf-8"))
        print(f"OK: {len({skill for skills in mapping.values() for skill in skills})} indexed skills, {len(AGENTS)} agents; "
              f"{'updated' if args.write else 'checked'} {len(pending) if args.write else len(AGENTS)} file(s)")
        return 0
    except (Invalid, UnicodeError, OSError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
