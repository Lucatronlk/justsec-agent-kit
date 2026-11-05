---
name: migration-readiness-review
description: Assesses repository, pipeline, and artifact-store migration readiness when a migration or cutover is being planned.
---

# migration-readiness-review

## Purpose
Assess whether a repository, pipeline, or artifact store is ready to migrate (GitLab↔GitHub, Artifactory/Nexus, BAMS) and produce a phased migration plan.

## When To Use
- Before starting any repo/pipeline/artifact-store migration.
- Mid-migration checkpoint to confirm readiness for cutover.

## Inputs Expected
- Source system details (repo list, artifact registry contents, pipeline definitions), target system, and migration scope/deadline constraints.

## Step-By-Step Process
1. Inventory: enumerate every artifact/repo/pipeline/permission/webhook/secret in scope. Flag anything undocumented or unowned.
2. Dependency mapping: identify what depends on what (consumer pipelines, downstream services, package consumers).
3. Assess target system parity: does the target support every feature/setting the source has (branch protection, approvals, registry types)? List gaps explicitly.
4. Define phased plan: mirror/dry-run → validate parity (checksums, counts, successful test build) → dual-write/bridge if needed → cutover → bake period → decommission.
5. Identify credentials/secrets that must be rotated (never carried over) as part of migration.
6. Produce a go/no-go readiness verdict with explicit blockers, not just a general summary.

## Validation Checklist
- [ ] Full inventory complete and reviewed (no "we'll find out during migration" items)
- [ ] Dependency map covers consumer pipelines/services
- [ ] Target-system feature gaps explicitly listed (not assumed to auto-migrate)
- [ ] Phased plan includes an explicit validation step before cutover
- [ ] Credential rotation plan defined
- [ ] Rollback path defined for each phase

## Output Format
- Summary
- Inventory
- Dependency map
- Gaps / risks
- Phased migration plan
- Go/no-go verdict with blockers
- Residual risk

## Safety Notes
- This is an assessment/planning skill — it does not execute the migration itself.
- Never assume a feature (branch protection, approval rules, webhooks) migrates automatically; verify explicitly against target-system docs.

Related instructions: `instructions/migrations/migration-pipelines.instructions.md`
