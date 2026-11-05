# DevSecOps General Instructions

> Synthesized from `awesome-copilot` (`instructions/security-and-owasp.instructions.md`, `skills/security-review`, `skills/mcp-security-audit`, `instructions/github-actions-ci-cd-best-practices.instructions.md`, `skills/github-actions-hardening`) and `awesome-opencode` (`data/projects/cupcake.yaml` OPA/Rego policy layer). Converted to generic Markdown.

## When To Use

Any pipeline, infrastructure, or code change that touches security posture: CI/CD, IAM, network exposure, secrets, dependencies, containers.

## Shift-Left Principles

- Run SAST, dependency/SCA scanning, secret scanning, and IaC scanning **before merge**, not just before deploy.
- Treat every finding as either: fixed, suppressed-with-justification, or accepted-risk-with-owner — never silently ignored.
- Prefer policy-as-code (OPA/Rego, Conftest, Sentinel) over tribal-knowledge review checklists for repeatable gates. OPA/Rego is the same engine behind Kubernetes admission control (Gatekeeper/Kyverno-adjacent) and Terraform policy checks — one policy language, multiple enforcement points.

## CI/CD Hardening (GitHub Actions / GitLab CI, same principles apply to both)

- Pin third-party actions/images to a SHA, not a floating tag (`@v4` can be repointed; a SHA cannot).
- Least-privilege `GITHUB_TOKEN` / CI job token: default `permissions: contents: read`, escalate only specific jobs that need write.
- **Critical injection risk**: `${{ github.event.issue.title }}`-style expression interpolation inside a `run:` step is pasted directly into the shell — it is a code-injection sink, not a safe variable substitution. Always pass untrusted values via environment variables instead:
  ```yaml
  # BAD
  - run: echo "Title: ${{ github.event.issue.title }}"
  # GOOD
  - env:
      TITLE: ${{ github.event.issue.title }}
    run: echo "Title: $TITLE"
  ```
- Distrust `pull_request_target` / `workflow_run` / `issue_comment` triggers — they can run with write-level secrets against attacker-controlled code. Never checkout and execute untrusted PR code under these triggers.
- Require OIDC/workload-identity federation for cloud auth in CI (AWS/Azure/GCP) instead of long-lived static credentials.
- Enable branch protection + required status checks on protected branches; no direct pushes to `main`/`master`.

## Secure Coding Baseline

- Injection (SQLi/XSS/SSRF/command injection): parameterize queries, allow-list URL schemes/hosts for any server-side fetch, never string-concatenate shell commands with user input.
- AuthN/AuthZ: verify authorization on every request, not just authentication; deny by default.
- Secrets: no plaintext secrets in code, config, logs, or CI output; use a secret manager + short-lived credentials.
- Logging: log security-relevant events (auth failures, privilege changes, config changes) without logging secret values or full PII.
- Dependencies: pin versions, monitor for known-vulnerable packages (CVE feeds / SCA tooling), avoid abandoned/unmaintained packages for security-critical paths.

## Agent-Specific Governance (for AI-driven DevSecOps agents)

- Every tool call an agent makes should be logged (append-only audit trail) with enough context to reconstruct intent.
- An inner/delegated agent must never have broader permissions than the outer agent that invoked it.
- Fail closed: if a policy/tool result is ambiguous or unavailable, do not proceed with a destructive action.
- Rate-limit and scope agent tool access per task, not globally.

## Output Format

- Summary
- Findings by severity
- Evidence
- Fix
- Validation
- Rollback
- Residual risk

## Safety Notes

- Never auto-apply a security patch without human review — present the diff and let a human merge it.
- Never disable a security scanner/gate to "unblock" a pipeline without an explicit, documented, owner-approved exception.
