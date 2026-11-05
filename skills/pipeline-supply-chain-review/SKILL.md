---
name: pipeline-supply-chain-review
description: Reviews CI/CD supply-chain controls and artifact provenance when pipeline or release automation changes are requested.
---

# pipeline-supply-chain-review

## When To Use

Use for GitHub Actions, GitLab CI, Jenkins, build scripts, release automation, and artifact provenance reviews.

## Workflow

1. Identify workflow entry points and trigger conditions.
2. Check secret use, token scope, runner trust, and environment protections.
3. Review action pinning, image provenance, dependency installation, and artifact handling.
4. Verify branch protections, deployment gates, and rollback support.
5. Draft minimal hardening changes.

## Validation Commands

- `actionlint`
- `yamllint`
- `shellcheck` for shell scripts

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk
