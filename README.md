<h1 align="center"><img src="assets/justsec/JustSec%20agent%20kit%20gradient%20wordmark.png" alt="justsec-agent-kit" width="100%"></h1>

<p align="center"><strong>No shortcuts — Just security.</strong></p>

274 skills, six specialist personas, one unrestricted master, and the permission model that decides which persona may load which skill. Built for OpenCode, portable to any host that reads `SKILL.md`.

Security-first skills, agent personas and reviewable permission controls for AI coding agents. Built for OpenCode; skill files use portable `SKILL.md` format.

<p align="center"><img src="assets/brand/section-divider.svg" width="100%" height="6" alt=""></p>

## <img src="assets/icons/star.svg" width="22" height="22" alt=""> What you get

<table>
  <tr>
    <td align="center" valign="top" width="33%"><img src="assets/icons/toolbox.svg" width="28" height="28" alt=""><br><strong>Skills on demand</strong><br><sub>274 skills across cloud, infrastructure, security, Python, TypeScript, migrations, LLMOps and SRE.</sub></td>
    <td align="center" valign="top" width="33%"><img src="assets/icons/robot.svg" width="28" height="28" alt=""><br><strong>Domain personas</strong><br><sub>Six agents with named skill grants and clear review versus implementation boundaries.</sub></td>
    <td align="center" valign="top" width="33%"><img src="assets/icons/shield.svg" width="28" height="28" alt=""><br><strong>Reviewable controls</strong><br><sub>Default-deny skill permissions; validation scripts check agent definitions and skill mappings.</sub></td>
  </tr>
</table>

<p align="center"><img src="assets/brand/section-divider.svg" width="100%" height="6" alt=""></p>

## <img src="assets/icons/sparkle.svg" width="22" height="22" alt=""> Quick start

```bash
git clone https://github.com/Lucatronlk/justsec-agent-kit
cd justsec-agent-kit
PYTHONDONTWRITEBYTECODE=1 python3 scripts/validate-agents.py
python3 scripts/sync-agent-skill-permissions.py --check
```

For an agent-skills-compatible host, list skills before selecting one:

```bash
npx skills add Lucatronlk/justsec-agent-kit --list
npx skills add Lucatronlk/justsec-agent-kit --skill terraform-review
```

Global install on OpenCode (links every skill, installs the seven personas):

<p align="center"><img src="assets/brand/section-divider.svg" width="100%" height="6" alt=""></p>

## <img src="assets/icons/shield.svg" width="22" height="22" alt=""> Security model

## The seven agents

| Agent | Domain | Skills |
|---|---|---|
| `master-devsecops-agent` | Everything, every skill, unrestricted. Only `git commit`, `git push` and `sudo` prompt | 274 |
| `devsecops-agent` | Cloud, infrastructure, security, Kubernetes, CI/CD, Terraform | 230 |
| `python-agent` | Python development, quality, security, performance | 32 |
| `typescript-agent` | TypeScript, Node.js, Electron, VS Code extensions | 60 |
| `migration-agent` | Artifactory, Jenkins, GitLab, Nexus, Vault migrations | 54 |
| `ai-llmops-agent` | Agents, LLMOps, local inference, RAG | 55 |
| `observability-sre-agent` | Telemetry, SLOs, alerts, incidents, DR | 46 |

<p align="center"><img src="assets/brand/section-divider.svg" width="100%" height="6" alt=""></p>

`master-devsecops-agent` is the exception to the restrictive model: all 274 skills, no `ask` on shell or external paths, and no credential-path denial. Three commands still stop for approval — `git commit`, `git push`, `sudo`. Use it when a task crosses domains, and remember that removed prompts are not authorization.

### Unattended runs

Those three asks are the only place an unattended session can stall. Pick one of these before relying on it headless:

1. **Warm up once, interactively.** Answer `always` on the first `git commit` and `git push`. OpenCode saves them as durable project-scoped `allow` rules that survive restarts. Review and prune saved rules later.
2. **Ship a zero-prompt variant.** Copy `agents/master-devsecops-agent.md` and change the three `ask` values to `allow`. Keep the commit and push steps in your prompt sequence so history and remote state are still deliberate.
3. **Make `sudo` non-interactive.** A prompt cannot be answered in a headless run. Grant `NOPASSWD` for the specific commands in `sudoers`, and prefer `sudo -n` so a missing grant fails fast instead of hanging.

Unattended also needs push credentials already in place (SSH agent or a scoped token) and a clean working tree policy, or `git commit` will silently include unrelated changes. With no prompts in the way, keep the dry-run defaults that the skills already specify.

## Layout

```
AGENTS.md          operating policy
STANDARDS.md       naming, tagging, security baseline
instructions/      domain standards, loaded as context
skills/            the capability library, one SKILL.md per folder
agents/            seven personas plus the canonical skill index
scripts/           validation gates, install sync, read-only review helpers
templates/         repo and command scaffolding
plugins/ mcp/      access-profile review notes, nothing auto-installed
```

Grants make skills available on demand; they do not auto-load them. See [agents/USAGE.md](agents/USAGE.md) for routing and [agents/skill-agent-index.md](agents/skill-agent-index.md) for complete mapping.

<p align="center"><img src="assets/brand/section-divider.svg" width="100%" height="6" alt=""></p>

## <img src="assets/icons/layers.svg" width="22" height="22" alt=""> Repository map

| Path | Purpose |
|---|---|
| `AGENTS.md`, `STANDARDS.md` | Operating policy and security baseline |
| `instructions/` | Domain standards |
| `skills/` | Capability library; one `SKILL.md` per skill |
| `agents/` | Domain personas and canonical skill index |
| `scripts/` | Validation, setup and review helpers |
| `templates/`, `plugins/`, `mcp/` | Scaffolding and integration notes; nothing auto-installed |

<p align="center"><img src="assets/brand/section-divider.svg" width="100%" height="6" alt=""></p>

## <img src="assets/icons/terminal.svg" width="22" height="22" alt=""> Validate

```bash
PYTHONDONTWRITEBYTECODE=1 python3 scripts/validate-agents.py
python3 scripts/sync-agent-skill-permissions.py --check
```

Both checks must pass; `--write` regenerates agent allow-lists from index, so do not hand-edit them. See [CONTRIBUTING.md](CONTRIBUTING.md).

<p align="center"><img src="assets/brand/section-divider.svg" width="100%" height="6" alt=""></p>

Skills use plain `SKILL.md` frontmatter. `opencode.json` is the only host-specific file. The seven agent files are also usable as reference personas in Copilot custom chat modes or Claude Code subagents.

Original material is MIT-licensed under [LICENSE](LICENSE). Bundled third-party material retains its own terms; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). Brand artwork has separate [reuse notice](assets/NOTICE.md).

`opencode.json` contains host-specific configuration. Skills use portable `SKILL.md` files; persona definitions can also serve as reference for other agent hosts.
