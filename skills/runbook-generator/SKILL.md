---
name: runbook-generator
description: Creates or improves operational runbooks when deployment, rollback, incident response, or maintenance guidance is needed.
---

# runbook-generator

## When To Use

Use when a repo or system lacks operational runbooks for deployment, rollback, incident response, or recurring maintenance.

## Workflow

1. Identify the system boundary and owner.
2. Capture prerequisites, normal operations, alerts, failure modes, and rollback actions.
3. Keep instructions concrete, ordered, and environment-aware.
4. Note validation steps and escalation paths.
5. Highlight assumptions and residual gaps.

## Validation Commands

- confirm documented commands exist in the repo or platform tooling

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk
