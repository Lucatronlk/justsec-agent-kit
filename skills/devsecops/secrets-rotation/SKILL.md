---
name: secrets-rotation
description: Plan and verify credential rotation with consumer discovery, overlap windows, revocation, and audit evidence.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Secrets Rotation

## Inputs
Secret references and owners (not values), consumer inventory, provider rotation capabilities, TTL, and incident constraints.

## Workflow
1. Map all consumers and update paths; classify single-active versus dual-active credentials.
2. Plan creation, staged propagation, validation, and old-credential revocation within a bounded overlap window.
3. Test new identity with least privilege using approved secret manager integration; monitor auth errors.
4. Confirm stale versions revoked and schedule next rotation; record metadata, not secret material.

## Validation
Prove consumers authenticate with new version and old version fails after revocation; inspect error rates and audit events.

## Rollback and safety
Never read or print secret values. Obtain approval before rotation; if rollout fails during overlap, restore previous reference temporarily and investigate. If compromise suspected, do not reactivate old key; use incident procedure.
