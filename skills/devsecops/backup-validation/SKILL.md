---
name: backup-validation
description: Verify backup completeness and recovery through isolated restore drills and measured RPO/RTO.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Backup Validation

## Inputs
Backup schedules, retention policies, storage inventory, encryption/key custody, RPO/RTO, and restore runbooks.

## Workflow
1. Map protected datasets, owners, dependencies, immutable copies, and backup success signals.
2. Select recent and older recovery points; restore into an isolated approved environment without overwriting live data.
3. Check counts, checksums, application consistency, permissions, and key availability; measure actual recovery time and data loss.
4. Document gaps and corrective actions with owners and retest dates.

## Validation
Demonstrate application-level reads on restored data and confirm retention plus offsite recoverability, not just backup job success.

## Rollback and safety
Treat backup data as production-sensitive. Restrict access and clean up isolated restores under retention policy; never test by restoring over production without explicit incident approval.
