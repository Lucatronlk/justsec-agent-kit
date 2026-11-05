# Plugins Directory

No plugins are bundled directly in `justsec-agent-kit`. This directory documents **review notes** for plugin categories found in `awesome-copilot`/`awesome-opencode` so you can make an informed decision before installing any of them into a real OpenCode/Copilot setup.

## Safety Rule

**Never enable a shell-executing, filesystem-broad, or network-calling plugin without reading its access profile first.** Use `skills/ai-agents/repo-ai-readiness/SKILL.md` or `instructions/ai-agents/agent-safety.instructions.md` to evaluate any candidate plugin.

## Reviewed Plugin Categories (from source repos, NOT installed here)

| Category | Example (source repo) | Access Profile | Verdict |
|---|---|---|---|
| Secret-scan / destructive-command guardrails | `awesome-copilot/hooks/secrets-scanner`, `hooks/tool-guardian`; `awesome-opencode/data/plugins/cc-safety-net.yaml`, `envsitter-guard.yaml` | Reads git diff / tool-call JSON; redacts before logging | **Recommended** — defensive, well-scoped. Review the deny-list before enabling. |
| Policy-as-code (OPA/Rego) | `awesome-opencode/data/projects/cupcake.yaml` | Policy engine hooked into the tool-call path | **Recommended for governance** — same engine as Kubernetes Gatekeeper / Terraform Conftest. Requires writing your own Rego policies. |
| MCP security audit | `awesome-copilot/skills/mcp-security-audit` | Reads `.mcp.json` files only | **Recommended** — use before onboarding any new MCP server. |
| CI/CD automation (`opencode-actions`) | `awesome-opencode/data/projects/opencode-actions.yaml` | Runs OpenCode unattended in CI with repo token scope | **Use with caution** — scope the CI token to least privilege; review `instructions/cicd/github-actions.instructions.md` first. |
| Browser automation | `awesome-opencode/data/plugins/opencode-chromium-browser-plugin.yaml` | Full local browser control (CDP, DOM, downloads, network/console inspection) | **High risk — do not enable by default.** Only for an explicit, scoped browser-automation task with the user's informed consent. |
| Auto-fix code review (`opencode-review`) | `awesome-opencode/data/plugins/opencode-review.yaml` | Can auto-fix code automatically | **Review before CI use** — disable auto-fix in any pipeline; keep human review in the loop. |
| direnv / command-inject | `awesome-opencode/data/plugins/direnv.yaml`, `command-inject.yaml` | Executes arbitrary `.envrc`/Makefile/npm scripts | **High risk** — trust boundary depends entirely on repo trust; do not enable in a repo you don't fully control. |
| Docker/devcontainer wrappers | `devcontainers.yaml`, `jailoc.yaml`, `deck.yaml` | Docker daemon access | **Moderate risk** — useful for agent sandboxing itself, but requires privileged Docker access to set up. |
| Telemetry/OTel export | `opencode-plugin-otel.yaml` | Sends session metadata to external OTel collector (Datadog/Honeycomb/Grafana) | **Review data sensitivity** before enabling — confirm what leaves the machine. |

## Before Enabling Any Plugin

1. Does it need filesystem access beyond the project directory? Scope it down.
2. Does it call out to a network endpoint? Document what data leaves the machine.
3. Does it execute shell commands? Confirm there's a deny-list for destructive patterns.
4. Does it need git/GitHub write access? Scope tightly (no broad `contents: write` for read-only tasks).
5. Does it need browser access? Treat as high-sensitivity, explicit opt-in only.
