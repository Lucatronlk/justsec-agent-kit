# GitHub Actions Instructions

> Condensed from `awesome-copilot` (`instructions/github-actions-ci-cd-best-practices.instructions.md`, `skills/github-actions-hardening`, `agents/github-actions-expert.agent.md`). Converted to generic Markdown.

## When To Use

Authoring or reviewing GitHub Actions workflows.

## Structure & Efficiency

- Use `permissions:` at the workflow or job level, defaulting to `contents: read`; escalate only in the specific job that needs write access.
- Use caching (`actions/cache`, or built-in caching in `setup-node`/`setup-python`) to reduce redundant dependency installs.
- Use matrix strategies for multi-version/multi-OS testing rather than duplicating jobs.
- Use `concurrency:` groups to cancel superseded runs on the same ref (saves CI minutes).

## Critical Security Rule: Expression Injection

`${{ }}` expressions are **pasted directly into the shell command**, not passed as a safe variable:

```yaml
# BAD — code injection sink
- run: echo "Title: ${{ github.event.issue.title }}"

# GOOD — pass via env, let the shell handle it as a string
- env:
    TITLE: ${{ github.event.issue.title }}
  run: echo "Title: $TITLE"
```

This applies to any untrusted input: PR titles, issue bodies, branch names, commit messages.

## Trust Boundaries

| Trigger | Risk |
|---|---|
| `pull_request` | Runs with restricted, read-only default token against PR code — relatively safe |
| `pull_request_target` | Runs with **base-branch permissions and secrets** against PR code if you check it out — high risk if misused |
| `workflow_run` | Similar elevated-trust risk if it checks out and executes the triggering workflow's code |
| `issue_comment` | Attacker-controlled comment body — sanitize before using in any `run:` step |

Never checkout and execute untrusted PR code under an elevated-trust trigger without careful gating (e.g., requiring a maintainer `/ok-to-test` comment).

## Supply Chain

- Pin third-party actions to a full commit SHA, not a tag (`uses: actions/checkout@<sha>` not `@v4`) — a tag can be repointed by the action author or a compromised account.
- Use Dependabot or a scheduled job to track/update pinned SHAs.
- Prefer OIDC federation (`permissions: id-token: write` + cloud provider's OIDC action) over long-lived cloud credentials in repo secrets.

## Review Checklist

- [ ] `permissions:` explicitly scoped, not default (which can be overly broad depending on org settings).
- [ ] No untrusted `${{ }}` expression interpolated directly into `run:` shell.
- [ ] Third-party actions pinned to SHA.
- [ ] Secrets sourced from GitHub encrypted secrets/OIDC, never hardcoded.
- [ ] `pull_request_target`/`workflow_run` usage reviewed for checkout-and-execute risk.

## Output Format

- Summary
- Findings by severity
- Evidence
- Fix
- Validation
- Rollback
- Residual risk

## Safety Notes

- Never grant `id-token: write` and broad `contents: write` to the same job unless specifically required and reviewed.
