---
name: jfrog-artifactory-administration
description: Govern Artifactory repositories, replication, access, retention, and repository health before operational changes.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# JFrog Artifactory Administration

## Inputs
Repository inventory (local, remote, virtual), package types, permissions, replication targets, storage, and retention goals.

## Workflow
1. Discover consumers, upstream proxies, virtual resolution order, users/groups, and storage pressure using metadata-only access.
2. Plan repo layout, remote cache policy, replication, cleanup rules, and scoped service identities.
3. Stage config changes in nonproduction, then request approval for production execution with backup and maintenance window.
4. Validate resolution paths, checksums, permission boundaries, replication lag, and alerting after change.

## Rollback and safety
Export sanitized settings and keep last-good repository routing. Revert config or route to old repository on failed validation; cleanup/deletion is irreversible without verified backup. Never inspect or print access tokens.

## Change gates and evidence
- Inventory every repository (local/remote/virtual), package type, remote URL (redacted if sensitive), virtual member and resolution order, replication rule, permission target, cleanup rule, consumer and owner. Record a timestamped baseline of repository settings, asset counts/bytes, storage headroom, replication backlog/lag and recent resolution/auth/alert rates; document unknowns as blockers, not assumed parity.
- Before any mutation, obtain separate change-owner approval for the named repositories, nonproduction pilot, production window, authorized operators, verified config backup/restore test and expected rollback time. No production execution or destructive cleanup is authorized by this skill; require explicit approval for each. Define pass/fail limits for replication lag, storage headroom, 404/auth rates and alert health from the recorded baseline before testing.
- Compare exported sanitized before/after configuration for **every** scoped repository, virtual order, permission target and retention rule; require zero unexplained differences. Enumerate all in-scope assets and compare path, size and checksum where the API exposes them; never treat a sample as exhaustive. For remote/proxy caches or missing checksums, document exact unverified paths and coverage, obtain an authorized trustworthy read-back hash when feasible, and compare upstream resolution using a representative format/consumer matrix; exceptions require owner acceptance and cannot be described as proven full integrity. Test allowed and denied access using non-secret identities and monitor replication/alerts for the agreed observation window.
- Store dated inventory, redacted config diffs, checksum/count comparison summary (including unverified items), test/build IDs, monitoring snapshots, decision owner and approval/exception IDs in a restricted evidence location; no tokens, credentials or artifact contents. Any unexplained mismatch, failed permission boundary or missed limit is no-go: revert settings/routing to last-good, verify resolution and access again, retain backup, and escalate data loss before retry. Retain source/old routing through the agreed bake period and require owner sign-off before cleanup.
