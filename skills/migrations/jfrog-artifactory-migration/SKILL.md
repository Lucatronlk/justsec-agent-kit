---
name: jfrog-artifactory-migration
description: Migrate JFrog Artifactory packages and consumers with repository-type parity, checksum verification, and controlled cutover.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# JFrog Artifactory Migration

## Inputs
Source/target Artifactory versions, repository types, path layout, properties, build info, users/groups, Xray policies, replication and consumer inventory.

## Workflow
1. Discover local/remote/virtual repositories, immutability policies, storage, checksums, metadata, permissions, and CI resolution URLs.
2. Plan package-type compatibility, property/build-info handling, remote-cache behavior, namespace conflicts, throughput, and phased sync.
3. After explicit approval, pilot a bounded repository, then transfer via supported export/replication; freeze writes or coordinate delta sync for cutover.
4. Validate artifact counts and hashes, metadata/properties, test builds, upload/download permissions, virtual resolution order, and Xray parity.
5. Shift consumers in waves; monitor 404s, auth failures, and cache misses before source decommission.

## Rollback and safety
Keep source read-only/available and old URLs/credentials until burn-in. Route consumers back and reconcile writes before retry; do not delete source or migrate secret values. Never run production transfer without approved change window and recovery plan.

## Readiness, parity and release gates
- Inventory every scoped repository and artifact path with format, size, available source digest, properties, build-info references, immutability, retention, security policy and owner; map virtual membership/order, remote cache versus upstream ownership, CI and package consumers, permissions and URL dependencies. Record version/feature incompatibilities and unsynced items as explicit blockers. Set a signed scope manifest and delta/write-freeze boundary before comparison.
- Stage target as a read-only mirror for consumer tests; pilot only after distinct approval for nonproduction, then obtain separate explicit production transfer/cutover approval with window, operator, backup/restore test, credential **rotation** plan (new target identities, no source credential reuse) and recovery owners. Migration scripts or this guidance do not authorize execution.
- At pilot and final frozen/delta boundary, compare **all** in-scope source and target path lists, counts and bytes by repository, plus digest per artifact (SHA-256 when both sides support it; otherwise documented native digest plus size and a trusted read-back hash where authorized). Require zero missing/extra/mismatched paths, digests or required properties/build-info references; list skipped/unhashable/remote-cache entries and make exceptions owner-approved; any required unverifiable artifact blocks a full-integrity claim, and sampling never proves exhaustive integrity. Verify virtual resolution, permissions (allow/deny), Xray/policy parity and one real publish+resolve build per format and consumer class on target. Preserve dated redacted manifests, comparison outputs, build IDs, approvals and exceptions; do not collect token values.
- Go/no-go is zero unexplained differences, successful target builds and access checks, credential rotation readiness and agreed 404/auth/replication-lag thresholds over a defined bake window. On failure, stop new writes, redirect consumers to retained source, reconcile any target-only publishes before retry and rerun full scoped parity; never disable checksum/signature checks. Keep source and protected backup through bake; decommission only after owner sign-off and reproducible parity evidence.
