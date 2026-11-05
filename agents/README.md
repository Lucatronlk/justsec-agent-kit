# Agents

Six domain agents, each with a deny-by-default `permission.skill` list. Permission means available on demand, not auto-loaded; task-relevant skills must be loaded via the skill tool. Skills live once under `../skills/`. See [`USAGE.md`](USAGE.md) for a routing guide (which agent for which task, and why).

| Agent | Responsibility | Permitted skills |
|---|---|---|
| [`devsecops-agent`](devsecops-agent.md) | Cloud, infrastructure, security, platform engineering, Kubernetes, CI/CD and Terraform | 230 |
| [`python-agent`](python-agent.md) | Python development, packaging, debugging, quality, performance and concurrency | 32 |
| [`typescript-agent`](typescript-agent.md) | TypeScript, Node.js, Electron, VS Code-compatible extensions | 60 |
| [`migration-agent`](migration-agent.md) | JFrog Artifactory, Jenkins, GitLab, Nexus and Vault migration with Python automation | 54 |
| [`ai-llmops-agent`](ai-llmops-agent.md) | AI agents, LLMOps, local AI and RAG | 55 |
| [`observability-sre-agent`](observability-sre-agent.md) | Monitoring, logging, telemetry, SRE and incidents | 46 |

**274 indexed skills**, **274 skill files**, **104 shared skills**. The 16 existing analysis/Understand skills and four new analysis skills are permitted to all six agents; use only for matching work. See [`skill-agent-index.md`](skill-agent-index.md) for every skill and owner.

## Standard persona contract

Each frontmatter declares identity, routing description, `mode: all`, tool permissions and deny-by-default skill permissions. **Model is deliberately inherited** from host/global configuration; no `model:` override is set. Bodies cover role/invocation, specialist handoff, discovery → planning → execution → verification, safety and evidence-based output. Audit requests remain read-only; implementation requires explicit task authorization even for auto-approved project edits. `edit` defaults to `allow` with protected credential-path denials; external directories default to `ask` except `$HOME` source/installed skill roots. `bash: ask` remains. Once an external path is approved, an edit there may run without a second edit prompt, except protected credential paths. Auto-approved skill roots can also be edited without a prompt: this is a configuration limitation, not task authorization to modify skills. Credential-file patterns are denied in both `read` and `edit`, with full `[REDACTED]` reporting; a shell command must never bypass denied reads.

## Validate definitions

Run `PYTHONDONTWRITEBYTECODE=1 python3 scripts/validate-agents.py` and `python3 scripts/sync-agent-skill-permissions.py --check` from repository root. The first gate parses frontmatter with PyYAML, checks six agent names, 20 shared grants, required operating modes, instruction paths and restrictive permissions; it does not prove runtime enforcement or semantic completeness. PyYAML must already be installed; do not auto-install it. Do not present prose `read` restrictions as shell sandboxing. `.github/workflows/agent-validation.yml` runs both gates on PRs and pushes to `main`; hosted CI execution remains unverified.

### Runtime resolution status (v2.0.24, observed via `opencode debug agents`)

`opencode debug agents` confirms all six domain agents load. On this Linux installation (Oct 22 2026), each resolves `edit: allow` with protected-path denials, `shell: ask`, and `external_directory: ask` with `$HOME` skill-root exceptions expanded to the current home directory. This is configuration resolution only; execution-level path prompts and behavior on Windows/macOS remain **not verified**. A prior child-agent execution check showed a denied skill returning `permission.rejected` and an allowed skill loading; it did not test these path exceptions. The global config's four formerly missing instruction paths were added Oct 18 2026; avoid printing global config because it contains secrets.

## Keep permissions in sync

`skill-agent-index.md` is the canonical mapping. Run `python3 scripts/sync-agent-skill-permissions.py --check` from repository root to verify index, files and agent allow-lists; `--write` updates **only** `permission.skill` entries after review. It does not load skills or install agents.

## Install

The sync scripts in `../scripts/` install top-level agent files and skill links. Re-run manually after changes; restart OpenCode. On an already synced installation, remove obsolete copied agent files for `cloud-agent`, `infra-agent`, `repo-analyze-agent`, and `understand-agent` **after reviewing them**. No sync was performed as part of this edit.

## Safety

No production cutover, pipeline execution, plugin install or credential-file read is authorized merely because a skill is permitted. See `../AGENTS.md` and `../instructions/ai-agents/agent-safety.instructions.md`.
