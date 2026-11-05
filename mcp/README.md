# MCP Servers Directory

No MCP servers are bundled or auto-configured by `justsec-agent-kit`. This directory documents safety guidance for evaluating MCP (Model Context Protocol) servers referenced in `awesome-copilot`/`awesome-opencode` before wiring any into your own `opencode.json`.

## Safety Rule

Every MCP server is effectively a plugin with its own tool surface. Apply the same review as `plugins/README.md` plus these MCP-specific checks:

1. **Config file secrets** — scan `.mcp.json`/`opencode.json` `mcpServers` blocks for hardcoded API keys/tokens before committing. Use `skills/security/secrets-audit/SKILL.md`.
2. **Unpinned dependencies** — avoid `npx package@latest` style server invocations; pin to a specific version.
3. **Shell-injection in server args** — check `args:` arrays for `curl | bash`, `eval`, `bash -c` patterns.
4. **Network egress** — an MCP server that proxies to a remote API (LLM providers, cost/pricing APIs, ticketing systems) sends whatever the agent passes it off-machine. Document this explicitly per server.
5. **Operation gating** — for MCP servers that can perform mutating operations (e.g., HashiCorp Terraform MCP server's `ENABLE_TF_OPERATIONS` flag, cloud-provider MCP servers), confirm the mutating flag defaults to **off** and requires explicit opt-in.

## Reviewed MCP-Adjacent References (from source repos, none installed here)

| Server | Source | Notes |
|---|---|---|
| HashiCorp Terraform MCP server | `awesome-copilot/agents/terraform.agent.md` | Docker-run, registry search + HCP Terraform workspace/run automation. Gate `ENABLE_TF_OPERATIONS` — do not enable apply/destroy operations without explicit review. |
| Azure MCP (`bicepschema`, Resource Graph) | `awesome-copilot/agents/azure-iac-generator.agent.md`, `azure-iac-exporter.agent.md` | Read-focused (schema lookup, resource graph); avoid granting write scope. |
| JFrog MCP (`curation-check`, `remediation-guide`) | `awesome-copilot/agents/jfrog-sec.agent.md` | Requires a JFrog Curation Policy backend; conceptually portable to other package-curation platforms. |
| RunAPI MCP | `awesome-opencode/data/resources/runapi-mcp.yaml` | Sends prompts/media to a remote API — treat as a network-egress risk; not recommended for sensitive repos. |
| Generic "resource" MCP pattern | `awesome-opencode/data/examples/resource.yaml` | Canonical `mcpServers` config block example — useful as a scaffold, not a real server. |

## Recommended Pattern

Keep any real MCP server config **outside** version control if it contains credentials (use env-var references instead), and document its access profile in this file when you add one for real use.
