---
name: cutover-rollback
description: Plan migration cutovers with explicit freeze, decision points, ownership, and tested rollback triggers.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Cutover Rollback

## Inputs
Source/target topology, dependency map, RPO/RTO, write paths, change window, observability, approvers, and data reconciliation method.

## Workflow
1. Discover clients and mutable state; identify irreversible steps and propagation delays.
2. Plan pilot, freeze or dual-write boundaries, traffic shifts, checkpoints, go/no-go thresholds, and owner communications.
3. Execute only after approval: snapshot state, perform timed switch in waves, record actions and timestamps.
4. Validate contracts, data parity, health, and user journeys at each checkpoint; trigger rollback promptly on breach.

## Rollback and safety
Keep source viable until burn-in. Reverse traffic, reconcile post-switch writes before accepting new writes, and verify recovery against RPO/RTO. No production DNS, data, or routing change without authorization; never expose credentials.
