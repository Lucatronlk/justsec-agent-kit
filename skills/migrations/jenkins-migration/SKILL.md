---
name: jenkins-migration
description: Migrate Jenkins controllers or jobs while preserving pipeline behavior, plugin compatibility, agents, and credentials boundaries.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Jenkins Migration

## Inputs
Controller/version, plugin and job inventories, Jenkinsfiles, nodes/labels, shared libraries, triggers, credentials IDs (not values), artifacts, and RBAC.

## Workflow
1. Discover job types, dependencies, plugin versions, webhooks, schedules, agent images, and artifact retention.
2. Plan target plugin/core compatibility, JCasC/job conversion, identity mapping, credentials recreation via approved store, and parallel-run strategy.
3. After approval, pilot noncritical jobs, migrate configuration, recreate scoped identities, and redirect triggers in staged waves.
4. Validate representative builds, shared libraries, labels, webhook/schedule behavior, approvals, artifacts, and permissions before cutover.
5. Observe duplicate-build and queue metrics during burn-in.

## Rollback and safety
Keep prior controller and configs backed up; disable target triggers before restoring source triggers to prevent duplicate side effects. Do not export plaintext credentials or delete old jobs until sign-off; production cutover requires authorization.

## Readiness, parity and recovery gates
- Inventory **all** scoped folders/jobs, Jenkinsfiles, build parameters, plugin/core versions, shared libraries, agents/labels, trigger sources and schedules, RBAC, credential IDs only, artifacts/retention and downstream effects (deploys, notifications, publishes). Map each job to consumers and owners; record plugin/JCasC incompatibilities and unowned jobs as blockers.
- Run a bounded nonproduction pilot only with owner approval; obtain separate explicit production migration/cutover approval, maintenance window, backup/restore test, recovery operator and new target scoped credentials via approved store (never reuse/export source secrets). Keep target triggers disabled until ownership of each trigger has moved; this skill does not authorize live changes.
- Compare full job/folder/config inventory and redacted normalized config fingerprints, plugin dependency and credential-ID mapping; require zero unexplained missing/extra jobs or changed policies. Compare in-scope historical artifacts by full path, size and digest where accessible; retention gaps or API/hash limits must be logged and owner-approved, never substitute sample results for exhaustive parity. Run representative builds for **each** job type and agent/trigger class on target, including shared-library, approval, artifact and RBAC allow/deny checks; exercise webhook/schedule delivery without duplicate production side effects.
- Save timestamped redacted manifests/diffs, test build IDs, artifact comparisons and explicit exclusions, approvals, and baseline versus bake queue, failed-build and duplicate-trigger metrics. Go/no-go requires zero unexplained config/artifact differences, successful tests and thresholds agreed before cutover. If failed, stop target triggers/publishes, reconcile any target-only outputs, re-enable source triggers once, route clients back, restore validated configs if needed and rerun gates; retain old controller through bake and owner sign-off.
