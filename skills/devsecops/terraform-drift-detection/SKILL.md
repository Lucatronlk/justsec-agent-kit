---
name: terraform-drift-detection
description: Detect and triage Terraform-managed infrastructure drift using read-only plans and ownership checks.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Terraform Drift Detection

## Inputs
Approved workspaces, backend access, provider versions, last applied plan, change records, and maintenance windows.

## Workflow
1. Schedule bounded read-only refresh/plan jobs with remote state locking and masked output.
2. Separate provider noise and computed-field churn from real unauthorized or emergency changes.
3. Correlate drift with cloud audit events and owner-approved changes; rank security and outage risk.
4. Propose reconcile-via-code, import, or documented exception with owner and deadline.

## Validation
Re-run a targeted plan after classification; confirm expected no-op state or explicitly tracked exceptions.

## Rollback and safety
Never auto-apply detected drift. Treat plans/state as sensitive; if a remediation causes adverse impact, stop rollout and restore reviewed configuration and state snapshot under approval.
