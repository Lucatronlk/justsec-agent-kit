# justsec-agent-kit

Just enough agent kit to do DevSecOps properly: security-first skills, personas, and deny-by-default guardrails for AI coding agents.

274 skills, six domain personas, and the permission model that decides which persona may load which skill. Built for OpenCode, portable to any host that reads `SKILL.md`.

## What this is

- A curated capability library for cloud, infrastructure, security, Python, TypeScript, migration, LLMOps, and SRE work.
- A deny-by-default permission model: every agent starts at `"*": deny` and gets named grants only.
- Two validation gates that keep the index, the skill files, and the agent allow-lists in sync.
- Read-only by default. Audits stay read-only; implementation needs explicit task scope.

## What this is not

- **Not a sandbox.** `bash: ask` prompts before a command, then runs it with your account's rights.
- **Not a runtime.** It does not install tools, call clouds, or manage credentials.
- **Not a guarantee.** Example commands are templates. Validate before running them against anything real.

## Security model

| Control | Behaviour |
|---|---|
| Skill grants | `permission.skill` denies by default; grants come from one canonical index |
| Shell | `bash: ask` on every agent |
| Credential files | `*.env`, `*.env.*`, `*.pem`, `*.key`, `*credentials*`, `*kubeconfig*`, `*/.ssh/*`, `.netrc`, `*.p12`, `*.pfx`, `*.tfstate` denied for `read` and `edit` |
| External paths | `ask`, except the two skill roots |
| Content trust | Skill text is data, not instructions; higher policy wins |
| CI | Both gates run on every pull request; token is `contents: read` |

These are approval and config controls. A shell command can still read a file the `read` rule denies. See [`SECURITY.md`](SECURITY.md) for the full model and reporting.

## Quick start

OpenCode, per project:

```bash
git clone https://github.com/Lucatronlk/justsec-agent-kit
```

Point your project config at the checkout, or copy the relevant `instructions/` paths into the project `opencode.json`. Agents live in `agents/*-agent.md`.

Any agent-skills-compatible host:

```bash
npx skills add Lucatronlk/justsec-agent-kit --list
npx skills add Lucatronlk/justsec-agent-kit --skill terraform-review
```

Global install on OpenCode (links every skill, installs the six personas):

```bash
# macOS / Linux
bash scripts/sync-global-opencode.sh
# Windows
powershell -File scripts/sync-global-opencode.ps1
```

Restart the host afterwards. The scripts never overwrite an existing non-link path and never delete a skill target.

## The six agents

| Agent | Domain | Skills |
|---|---|---|
| `devsecops-agent` | Cloud, infrastructure, security, Kubernetes, CI/CD, Terraform | 230 |
| `python-agent` | Python development, quality, security, performance | 32 |
| `typescript-agent` | TypeScript, Node.js, Electron, VS Code extensions | 60 |
| `migration-agent` | Artifactory, Jenkins, GitLab, Nexus, Vault migrations | 54 |
| `ai-llmops-agent` | Agents, LLMOps, local inference, RAG | 55 |
| `observability-sre-agent` | Telemetry, SLOs, alerts, incidents, DR | 46 |

A grant means *available on demand*, never auto-loaded. See [`agents/skill-agent-index.md`](agents/skill-agent-index.md) for the full matrix and [`agents/USAGE.md`](agents/USAGE.md) for routing.

## Layout

```
AGENTS.md          operating policy
STANDARDS.md       naming, tagging, security baseline
instructions/      domain standards, loaded as context
skills/            the capability library, one SKILL.md per folder
agents/            six personas plus the canonical skill index
scripts/           validation gates, install sync, read-only review helpers
templates/         repo and command scaffolding
plugins/ mcp/      access-profile review notes, nothing auto-installed
```

## Validate

```bash
PYTHONDONTWRITEBYTECODE=1 python3 scripts/validate-agents.py
python3 scripts/sync-agent-skill-permissions.py --check
```

Both must pass. `--write` regenerates the allow-lists from the index; do not hand-edit them. See [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Compatibility

Skills use plain `SKILL.md` frontmatter. `opencode.json` is the only host-specific file. The six agent files are also usable as reference personas in Copilot custom chat modes or Claude Code subagents.

## Licence

Original material is MIT — see [`LICENSE`](LICENSE). Bundled third-party material keeps its own terms; see [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).
