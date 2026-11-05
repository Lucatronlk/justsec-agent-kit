---
name: nexus-migration
description: Migrate Sonatype Nexus repositories across formats and versions with asset integrity, proxy behavior, and consumer validation.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Nexus Migration

## Inputs
Nexus edition/version, hosted/proxy/group repository list, blob stores, formats, cleanup policies, realms, roles, routing rules, and consumers.

## Workflow
1. Discover component/asset counts, hashes, metadata, blob store size, proxy upstreams, group order, and permissions.
2. Plan supported backup/export or format-specific copy, schema/version compatibility, immutable versions, routing, and write freeze/delta strategy.
3. After approval, pilot hosted repository; stage blobs/components via supported methods and switch endpoints in waves.
4. Use count/hash samples only for early pilot diagnostics; before declaring scoped migration parity, reconcile every enumerable hosted asset and component with path, size, available trustworthy digest, blob-store mapping and repository metadata. Compare Maven metadata/npm dist-tags or other format indexes, uploads, group/proxy resolution, and permissions. Report inaccessible assets, absent hashes and unsupported algorithms as unverified rather than counting them as passed.
5. Watch missing assets, cache misses, and storage growth after cutover.

## Rollback and safety
Keep source service and blob snapshots until reconciliation. Restore client URLs to source and resolve diverging publishes before retry; do not copy raw blob stores across incompatible versions or expose tokens; no production changes without approval.

## Readiness, parity and release gates
- Inventory all scoped hosted, proxy and group repositories, formats, blob stores, assets/components (path, size, available digest), format indexes, group order, routing rules, cleanup, roles/realms, publishers and consumers. Document compatibility gaps and which proxy entries are cache-only (cannot demand source/target cache identity); set timestamped inventory and freeze/delta watermark.
- Use supported export/restore or format-aware transfer and read-only target consumer mirror first. Pilot requires approval; production transfer and separate cutover require explicit owner approval, change window, tested backup/restore, credential rotation to distinct target identities (never reuse source credentials), recovery owner and rollback time. This skill alone authorizes no live transfer.
- After bounded pilot and final delta, enumerate **every** in-scope hosted asset on both sides, compare path, size, component metadata and digest (SHA-256/read-back when authorized and supported; otherwise native digest with limitations). Require zero unexplained missing/extra/mismatched assets and format index differences (Maven metadata, npm dist-tags and applicable formats); compare counts and bytes per repository, not just global totals. Report unsupported algorithms, absent source hashes, inaccessible artifacts, unverifiable records, API visibility, proxy cache/index limitations and any approved exclusions explicitly; a hash sample is diagnostic, not complete parity. A genuinely unverifiable required record blocks a full-integrity claim and requires owner decision before cutover. Test real publish+resolve per format/consumer class, group/proxy routing and allow/deny permissions.
- Save timestamped redacted manifests, full compare summaries with exceptions, test/build IDs, approvals and monitoring snapshots. Go/no-go requires full scoped parity, successful builds, authorized exceptions and agreed thresholds for missing assets, auth failures and cache misses over a named bake window. If failed, stop new target publishes, restore consumer routes to retained source, reconcile target-only versions before retry, rerun parity; never disable integrity checks or delete source/blob snapshots before bake and owner sign-off.
