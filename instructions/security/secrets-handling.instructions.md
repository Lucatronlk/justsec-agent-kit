# Secrets Handling Instructions

> Synthesized from `awesome-copilot` (`hooks/secrets-scanner`, `skills/mcp-security-audit`, `skills/secret-scanning`) and `awesome-opencode` (`data/plugins/envsitter-guard.yaml`, `data/plugins/opencode-log-sanitizer.yaml`). Converted to generic Markdown.

## When To Use

Always — this is a baseline rule for every agent and every repo, not an opt-in skill.

## Hard Rules

- **Never** read the contents of `.env`, `.envrc`, `*.pem`, `*.key`, kubeconfig files, cloud credential files (`~/.aws/credentials`, `~/.azure/`, `~/.kube/config`), or any file matching a known secret-store pattern unless the user explicitly and specifically instructs it for that exact file in that exact turn.
- **Never** print a full secret value in output, logs, or commit messages — if a secret must be referenced, show only a redacted form (`first4...last4`).
- **Never** commit a secret to git, even "temporarily" — assume git history is permanent.
- **Never** exfiltrate secret-adjacent content to a third-party network endpoint (MCP server, plugin, telemetry) without the user knowing that endpoint exists and what it receives.

## Detection Patterns (starting bank — extend per org)

```
AWS_ACCESS_KEY        AKIA[0-9A-Z]{16}
GitHub PAT            gh[pousr]_[A-Za-z0-9]{36,255}
Generic API key       (?i)(api[_-]?key|secret|token)\s*[:=]\s*['"][A-Za-z0-9/+=_-]{16,}['"]
Private key header    -----BEGIN (RSA|EC|OPENSSH|PGP) PRIVATE KEY-----
Slack token           xox[baprs]-[0-9A-Za-z-]{10,}
JWT                    eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}
```

## CI/CD Secret Hygiene

- Use a secret manager (Azure Key Vault, AWS Secrets Manager, HashiCorp Vault, GitLab/GitHub encrypted secrets) — never repo-committed config for secrets.
- Enable native secret scanning + push protection (GitHub Advanced Security, GitLab Secret Detection) on every repo.
- Rotate any secret that was ever committed, even if later removed from history — treat it as compromised.
- Mask secret-like values in CI job logs explicitly (most CI systems support masking registered secrets automatically — verify it's actually happening).

## MCP / Plugin / Tool Onboarding Check

Before enabling any new MCP server or plugin that an agent will use:

1. Does it need to read `.env`/credential files? If yes, scope it to the minimum required and document why.
2. Does its config (`.mcp.json` or equivalent) contain hardcoded secrets/tokens? Flag and move to env-var injection instead.
3. Does it shell out with unpinned dependencies (`npx package@latest`, `curl | bash`)? Pin versions; avoid pipe-to-shell installers.
4. Does it send content to a remote/third-party endpoint? Document what leaves the machine.

## Output Format For A Secrets Review

- Summary
- Findings (each with redacted evidence, never the full secret)
- Fix (rotate + remove from history + add to `.gitignore`/scanner allowlist as needed)
- Validation (re-scan clean)
- Residual risk

## Safety Notes

- If a secret is found, the very first recommended action is **rotate it** — removing it from a file does not undo exposure if it was ever committed or logged.
