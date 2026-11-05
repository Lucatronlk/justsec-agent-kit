---
name: self-service-provisioning
description: Design governed self-service infrastructure requests with quotas, approvals, lifecycle, and auditability.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Self-Service Provisioning

## Inputs
Catalog offerings, requester identity, environment constraints, IaC modules, cost limits, and approval matrix.

## Workflow
1. Specify validated inputs, ownership labels, TTL, quota, cost estimate, and least-privilege execution role.
2. Model request → plan → policy check → approval → provision → inventory record → cleanup.
3. Test failure paths including duplicate requests, partial applies, timeout, and expired resources.
4. Expose status and audit trail to requester and operators.

## Validation
Run nonproduction requests, check idempotence and quota enforcement, then verify deprovision and billing attribution.

## Rollback and safety
Never allow direct arbitrary IaC execution or production provisioning without approval. Save state and plan; on partial failure stop automation and reconcile before controlled teardown.
