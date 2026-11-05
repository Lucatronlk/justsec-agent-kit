---
name: repo-ai-readiness
description: Assesses repository AI-agent configuration and safety guardrails when onboarding or auditing OpenCode, Copilot, or Claude Code setup.
---

# repo-ai-readiness

## Purpose
Assess whether a repository is well set up for AI coding agents (OpenCode, Copilot, Claude Code) — instructions, skills, agent configs, and safety guardrails — and produce a concrete improvement plan.

## When To Use
- Onboarding a new repo into the `justsec-agent-kit` framework.
- Periodic audit of an existing repo's AI-agent configuration.

## Inputs Expected
- Repository root path.

## Step-By-Step Process
1. Check for a repo-local `AGENTS.md` (or `.github/copilot-instructions.md` / `CLAUDE.md` equivalent) — if missing, recommend adding one from `templates/` rather than duplicating global content.
2. Check `.opencode/` (or equivalent) for project-specific skills/agents/commands; confirm they don't conflict with or duplicate `justsec-agent-kit` content (prefer referencing shared content over copy-pasting).
3. Check for any MCP server / plugin configuration (`.mcp.json`, opencode config) — run through the safety checklist in `instructions/ai-agents/agent-safety.instructions.md` for each (filesystem/network/shell/git/browser access).
4. Check `.gitignore` covers `.env`, credential files, and any local agent session/state files that shouldn't be committed.
5. Check that CI (if present) doesn't grant an unattended agent run broader permissions than necessary (see `skills/devsecops/pipeline-security-review`).
6. Produce a gap list and a prioritized improvement plan (e.g., "add AGENTS.md", "scope down MCP server X", "add secret-scanning hook").

## Validation Checklist
- [ ] Repo has an `AGENTS.md` (or equivalent) — global or repo-specific, not missing entirely
- [ ] No duplicated/conflicting local copies of shared instructions (reference instead of copy where possible)
- [ ] Every MCP server/plugin has a documented access profile (filesystem/network/shell/git/browser)
- [ ] `.gitignore` covers secrets/credentials/agent state
- [ ] Any unattended CI agent run is scoped to least-privilege tokens

## Output Format
- Summary
- Gaps found
- Prioritized improvement plan
- Residual risk

## Safety Notes
- This skill only reads configuration; it does not install plugins/MCP servers or modify CI permissions itself.
- Flag (do not silently enable) any shell-executing plugin/hook found during the audit.

Related instructions: `instructions/ai-agents/agent-safety.instructions.md`, `instructions/ai-agents/context-engineering.instructions.md`
