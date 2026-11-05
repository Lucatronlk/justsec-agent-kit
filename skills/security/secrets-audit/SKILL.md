---
name: secrets-audit
description: Audits repositories and tool configuration for exposed secrets when secret hygiene or MCP/plugin safety is requested.
---

# secrets-audit

## Purpose
Scan a repository, pipeline config, or MCP/plugin config for hardcoded secrets, unsafe secret handling, and unsafe onboarding of new tools.

## When To Use
- Before merging any new MCP server, plugin, or hook configuration.
- Periodic repo secret-hygiene audit.
- After a suspected leak or as part of incident response.

## Inputs Expected
- Repo path, specific config files (`.mcp.json`, `.env.example`, CI pipeline files), or a git diff/range to scan.

## Step-By-Step Process
1. Scan tracked and staged/diffed files against the detection pattern bank in `instructions/security/secrets-handling.instructions.md` (AWS keys, GitHub PATs, generic API keys, private key headers, JWTs, Slack tokens, etc.).
2. For any new MCP server/plugin config, check specifically for: hardcoded secrets in server args/env, unpinned `@latest` dependency versions, shell-injection patterns in server invocation (`curl | bash`, `eval`, `bash -c`).
3. For any match, redact before reporting — never surface the full secret value, only `first4...last4`.
4. Check whether the match is already in git history (not just the working tree) — a removed-but-once-committed secret is still compromised.
5. Recommend rotation as the first remediation step, not just removal from the current file.

## Validation Checklist
- [ ] Working tree and staged diff scanned
- [ ] Git history checked for the same pattern if a match is found
- [ ] All reported evidence is redacted (no full secret values in output)
- [ ] New MCP/plugin configs checked for hardcoded secrets and unpinned/shell-injection risk
- [ ] Rotation recommended for any confirmed exposure, not just removal

## Output Format
- Summary
- Findings (redacted evidence, file:line, in-history yes/no)
- Fix (rotate + remove + add scanner allowlist/`.gitignore` entry as needed)
- Validation (re-scan clean)
- Residual risk

## Safety Notes
- Never read `.env`/credential files beyond what's needed to detect a pattern match; never print full secret values.
- Never exfiltrate scanned content to a third-party endpoint.

Related instructions: `instructions/security/secrets-handling.instructions.md`, `instructions/ai-agents/agent-safety.instructions.md`
