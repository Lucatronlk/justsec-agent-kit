---
name: pr-risk-summary
description: Summarizes delivery, security, validation, and rollback risk when a pull request or change set needs review.
---

# pr-risk-summary

## When To Use

Use before or during PR review to summarize delivery risk, security impact, validation confidence, and rollback readiness.

## Workflow

1. Identify changed areas and affected environments.
2. Summarize security, availability, and operational risks.
3. Check validation depth and rollback readiness.
4. Call out sensitive files and likely reviewer focus areas.
5. Produce a concise release-oriented summary.

## Validation Commands

- repo-specific tests and linters relevant to changed files

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk
