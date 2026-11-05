# Instructions

Always-on domain **standards** — the rules and conventions an agent should follow, as opposed to `../skills/` which are invokable, step-by-step capabilities.

These files are loaded through the `instructions` array in `../opencode.json` (and referenced by agents/skills). They contain no `SKILL.md` and no skill copies — skills live only under `../skills/`.

## Standards by Domain

| Domain | Files |
|---|---|
| AI agents | `ai-agents/agent-safety.instructions.md`, `ai-agents/context-engineering.instructions.md`, `ai-agents/never-weaken.instructions.md`, `ai-agents/report-header.instructions.md` |
| AWS | `aws/aws-cloud.instructions.md`, `aws/aws-landing-zone.instructions.md` |
| Azure | `azure/azure-cloud.instructions.md`, `azure/azure-terraform.instructions.md`, `azure/azure-naming.instructions.md`, `azure/azure-iac-generation.instructions.md`, `azure/azure-devops-pipelines.instructions.md` |
| CI/CD | `cicd/github-actions.instructions.md`, `cicd/gitlab-ci.instructions.md` |
| DevSecOps | `devsecops/devsecops-general.instructions.md` |
| Docker | `docker/docker-best-practices.instructions.md` |
| Documentation | `documentation/technical-writing.instructions.md` |
| Kubernetes | `kubernetes/kubernetes-best-practices.instructions.md` |
| Migrations | `migrations/migration-pipelines.instructions.md` |
| Python | `python/python-automation.instructions.md`, `python/python-review.instructions.md` |
| Security | `security/owasp-security.instructions.md`, `security/secrets-handling.instructions.md`, `security/threat-modeling.instructions.md` |
| Terraform | `terraform/terraform-general.instructions.md`, `terraform/terraform-review.instructions.md` |
| TypeScript | `typescript/typescript-general.instructions.md` |

## Instructions vs Skills vs Agents

- **Instructions** (`instructions/`) — standards, always relevant, loaded by `opencode.json`.
- **Skills** (`skills/`) — invokable procedures with validation and output format.
- **Agents** (`agents/`) — personas that mount a specific set of skills.

Do not copy skill content into this directory. If guidance is procedural, it belongs in a skill.
