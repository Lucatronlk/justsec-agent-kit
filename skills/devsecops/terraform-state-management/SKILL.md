---
name: terraform-state-management
description: Plan secure Terraform backend, locking, import, state moves, and recovery without leaking state secrets.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Terraform State Management

## Inputs
Backend configuration, workspace inventory, state ownership, lock policies, recovery objectives, and proposed address moves.

## Workflow
1. Identify backend encryption, access scope, versioning, locking, replication, and environment isolation.
2. Plan backend migrations or moved blocks with resource-address mappings and state snapshots.
3. Review the plan for destroy/recreate surprises and lock contention before any approved mutation.
4. Document recovery procedure and owner for each workspace.

## Validation
In nonproduction, compare state resource addresses, serial/lineage, and no-op plan after migration; confirm restore from versioned backup.

## Rollback and safety
State can contain secrets: do not print, commit, or casually download it. Never force-unlock or run state rm/mv without authorization; stop writers, back up state, and restore prior backend version only under coordinated change control.
