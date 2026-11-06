# Skill-agent index

The authoritative mapping is [`agents/skill-agent-index.md`](../../../agents/skill-agent-index.md). Agent definitions live under `agents/`; specialists have deny-by-default skill allow-lists. This template does not duplicate their permissions.

Seven agents:

| Agent | Focus |
|---|---|
| `master-devsecops-agent` | Any domain, every skill, unrestricted except `git commit`, `git push`, `sudo` |
| `devsecops-agent` | Cloud, infrastructure, security, platform, Kubernetes, CI/CD, Terraform |
| `python-agent` | Python engineering |
| `typescript-agent` | TypeScript, Node.js, Electron, VS Code extensions |
| `migration-agent` | Artifactory, Jenkins, GitLab, Nexus, Vault migrations and Python automation |
| `ai-llmops-agent` | AI agents, local AI, LLMOps, RAG |
| `observability-sre-agent` | Monitoring, telemetry, incidents, SRE |

The six specialists share the 16 existing repository-analysis and Understand skills and four new analysis skills on demand; the master holds every skill. Command templates in `templates/opencode/commands/` target the specialist agents.
