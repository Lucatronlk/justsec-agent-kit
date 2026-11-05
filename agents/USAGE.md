# Seven-Agent Usage Guide

How to route work across the six specialist agents (plus one unrestricted master), and why the boundaries are drawn the way they are. Source of truth for skill-to-agent ownership is [`skill-agent-index.md`](skill-agent-index.md); the agent definitions live in this directory.

## Core principles (why it's built this way)

1. **One primary owner per domain.** Each specialist owns one slice; no two claim primary ownership of the same code. This prevents two specialists from editing the same file at cross-purposes.
2. **Deny-by-default skills.** Every specialist starts with `skill: "*": deny` and receives only named `allow` grants from `skill-agent-index.md`. A grant means *available on demand*, **not** auto-loaded — a skill must still be explicitly loaded via the skill tool and matched to the task. `master-devsecops-agent` is the exception: `"*": allow`, every skill, no selection bookkeeping.
3. **Tool permission ≠ task authorization.** Named skills may load without prompts. For specialists, edits in the active project default to `allow` with protected credential-path patterns denied, external directories default to `ask`, and `bash: ask` remains. `master-devsecops-agent` removes all three gates except `git commit`, `git push` and `sudo`. In both models a no-prompt rule is *not* task authorization, and shell commands use the host account's filesystem permissions, not a sandbox.
4. **Read-only by default for audits.** Review/audit/triage requests never mutate files or systems. Implementation requires explicit authorization even when a tool no longer prompts.
5. **Model is inherited.** No agent pins a `model:` override — model selection stays centralized in host/global config.
6. **One skill file, one canonical map.** Skills live once under `../skills/`; `skill-agent-index.md` is the single source of truth for which agent may load which skill.

## The seven agents — when to use which

| Agent | Use it for | Primary ownership | Route away from it |
|---|---|---|---|
| [`master-devsecops-agent`](master-devsecops-agent.md) | Cross-domain work, or anything with no clear specialist. Every skill, no prompts except `git commit`, `git push`, `sudo` | Anything, end to end | Narrow, repeated work → the owning specialist |
| [`devsecops-agent`](devsecops-agent.md) | Cloud/IaaS, IAM, networking, Kubernetes, containers, Terraform/OpenTofu, CI/CD, secrets, scanning, compliance, release/supply-chain, threat models | Cloud, infrastructure, platform engineering, security architecture, release engineering | Python/TS/migration/LLMOps/SRE *implementation* → specialists |
| [`python-agent`](python-agent.md) | Python services, scripts, packages, tests, debugging, async, performance, untrusted-input hardening | All Python code | Cloud/IaC → devsecops; TS → typescript-agent |
| [`typescript-agent`](typescript-agent.md) | TypeScript/Node, APIs, builds, migrations, **Electron IPC**, **VS Code extensions**, app-level security | TypeScript/Node, Electron, VS Code-compatible extensions | Cloud/IaC/pipeline security → devsecops |
| [`migration-agent`](migration-agent.md) | JFrog Artifactory, Jenkins, GitLab, Nexus, Vault migration + Python migration automation | System cutovers and migration automation | Terraform/IaC migration, blue-green, semver → devsecops |
| [`ai-llmops-agent`](ai-llmops-agent.md) | AI agents, tool development, RAG, local AI, GPU serving, LLMOps, model/agent security, evals | AI/LLMOps and local-AI infrastructure | Cloud IAM/CI → devsecops; incidents → SRE |
| [`observability-sre-agent`](observability-sre-agent.md) | Metrics/logs/traces, SLIs/SLOs/error budgets, alerting, incident triage, runbooks, DR | Monitoring, telemetry, reliability, incidents | IAM/provisioning → devsecops; code fixes → language specialist |

Counts are the named `allow` grants (excluding the `"*": deny` wildcard): devsecops 230, python 32, typescript 60, migration 54, ai-llmops 55, observability-sre 46. `master-devsecops-agent` grants all 274 through `"*": allow`.

## Quick routing ("I have X")

- **Terraform plan/apply, kubeconfig, IAM policy, CI workflow, secret leak, scan triage** → `devsecops-agent`
- **Python bug / package / script / test / perf** → `python-agent`
- **TypeScript bug / Electron `ipcMain` / VS Code extension / Node build** → `typescript-agent`
- **JFrog→Nexus / Jenkins→GitLab / Vault move / Artifactory cutover** → `migration-agent`
- **RAG pipeline / prompt injection / local Ollama / vLLM serving / model evals** → `ai-llmops-agent`
- **Alert fatigue / P1 incident / missing telemetry / SLO / runbook / DR test** → `observability-sre-agent`
- **Cross-domain repo analysis with no clear owner** → start at `devsecops-agent`, which coordinates and hands off per artifact (Python→python, TS→typescript, migration→migration, AI→llmops, telemetry→SRE).

## Delegation matrix (who hands off to whom)

| Agent | Delegates to |
|---|---|
| devsecops | python (Python), typescript (TS/Electron), migration (cutovers), ai-llmops (AI/LLMOps), observability-sre (monitoring/incidents) — but **retains security review** of shared IAM/CI/platform controls |
| python | devsecops (cloud/IaC/secrets/CI), migration (cutovers), typescript (TS), ai-llmops (model serving), observability-sre (incidents) |
| typescript | devsecops (cloud/IaC/pipeline security), python (Python), migration (cutovers), ai-llmops (LLMOps), observability-sre (prod SRE) |
| migration | devsecops (platform/IAM security), python (non-migration Python engineering), observability-sre (operational incidents) |
| ai-llmops | devsecops (cloud IAM/CI/platform), observability-sre (monitoring/incidents), python/typescript (non-AI code), migration (migrations) |
| observability-sre | devsecops (IAM/provisioning/security), ai-llmops (AI eval), migration (cutovers), language specialist (code) |

## Special cases worth knowing

- **Four skills are deliberately *not* granted to migration-agent** (they route to devsecops): `blue-green-deploy`, `opentofu-migration`, `semantic-versioning`, `terraform-review`. Terraform/IaC migration, deployment-strategy engineering, and general release engineering belong to `devsecops-agent`.
- **`typescript-review` is granted to devsecops-agent** — but only for security-sensitive **cross-domain** reviews, not routine TypeScript ownership. Routine TS work goes to `typescript-agent`.
- **20 shared skills** (16 existing analysis/Understand + 4 new architecture/impact) are permitted to all seven agents: repo-intelligence, repo-ai-readiness, the nine `understand-*` skills, architecture-mapping, change-impact-analysis, dependency-graph, pr-risk-summary, verification-before-completion, and the other shared analysis skills. They are for corresponding tasks **only**, never defaults.
- **Understand skills are selected by artifact**, not by agent: `understand` (build graph), `understand-chat` (query), `understand-dashboard` (visualize), `understand-diff` (revisions), `understand-explain` (explain code), `understand-domain` (business flow), `understand-figma` (designs), `understand-knowledge` (wiki), `understand-onboard` (onboarding).
- **Six specialists share one safety floor: master-devsecops-agent departs from it deliberately.** Specialists use `"*": deny`; `bash: ask`; external-directory `ask` except for `$HOME/justsec-agent-kit/skills/**` and `$HOME/.config/opencode/skill/**`; and eleven protected credential-path patterns denied for both read and edit (`*.env`, `*.env.*`, `*.pem`, `*.key`, `*credentials*`, `*kubeconfig*`, `*/.ssh/*`, `.netrc`, `*.p12`, `*.pfx`, `*.tfstate`). The master allows all skills, reads, edits and external paths, and prompts only on `git commit`, `git push` and `sudo`. Skill path access is not permission to modify skill files. `$HOME` is expanded by OpenCode; these exceptions assume the documented default install layout. If skill roots move (e.g., custom `XDG_CONFIG_HOME`), update the rules at installation.

## How to pick (decision flow)

1. **What kind of artifact is it?** Code → language specialist. Cloud/IaC/security → devsecops. Cutover → migration. AI/model → llmops. Telemetry/incident → SRE.
2. **Is it a review/audit or an implementation?** Audits stay read-only; implementation needs explicit authorization even when an edit is auto-approved. Shell still prompts; cloud/IAM/pipeline/production writes are a *separate* approval boundary.
3. **Does it cross domains?** Start at devsecops for coordination and shared IAM/CI/platform security review; hand the actual artifact work to the primary specialist.
4. **Is a skill needed?** Confirm the identifier against `skill-agent-index.md`, load only the minimum matching skill, and follow its output contract. A permitted skill is never an automatic load.
