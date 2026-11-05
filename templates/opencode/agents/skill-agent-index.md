# Skill-agent index

The authoritative mapping is [`agents/skill-agent-index.md`](../../../agents/skill-agent-index.md). Agent definitions live under `agents/`, with deny-by-default skill allow-lists; this template does not duplicate their permissions.

Six domain agents:

| Agent | Focus |
|---|---|
| `devsecops-agent` | Cloud, infrastructure, security, platform, Kubernetes, CI/CD, Terraform |
| `python-agent` | Python engineering |
| `typescript-agent` | TypeScript, Node.js, Electron, VS Code extensions |
| `migration-agent` | Artifactory, Jenkins, GitLab, Nexus, Vault migrations and Python automation |
| `ai-llmops-agent` | AI agents, local AI, LLMOps, RAG |
| `observability-sre-agent` | Monitoring, telemetry, incidents, SRE |

All have the same 16 existing repository-analysis and Understand skills and four new analysis skills available on demand. Command templates in `templates/opencode/commands/` target these six agents.
