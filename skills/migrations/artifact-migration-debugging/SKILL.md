---
name: artifact-migration-debugging
description: Diagnoses artifact migration failures and checksum mismatches when packages fail to resolve after a migration.
---

# artifact-migration-debugging

## Purpose
Debug a failing or inconsistent artifact migration (e.g., Artifactory/Nexus/BAMS repository migration, package registry cutover).

## When To Use
- A migrated artifact/package fails to resolve, is missing, or has a checksum mismatch.
- A consumer build/pipeline fails after pointing at the new artifact store.

## Inputs Expected
- Source and target repository details, the specific artifact/package coordinates failing, and the consumer error (build log, resolution error).

## Step-By-Step Process
1. Reproduce: identify the exact artifact coordinate (group/artifact/version or package name/version) and the exact resolution failure (404, checksum mismatch, wrong version resolved, permission denied).
2. Compare source vs target: does the artifact exist in the target with the same checksum (SHA-256)? Check metadata (retention policy, virtual/remote repo layout) parity.
3. Check consumer configuration: is the consumer pointed at the correct repository URL/credentials for the target? Check for stale cached credentials or a cached "not found" negative-cache entry.
4. Check permissions: does the migrated identity/token have read access to the equivalent path in the target (permissions rarely migrate 1:1 with a naive copy)?
5. Check virtual/aggregate repository configuration: if using a virtual repo (Artifactory) that aggregates local+remote, confirm the resolution order matches the source setup.
6. Once root cause is confirmed, propose the smallest fix (re-sync artifact, fix permission, correct repo config) — do not "fix" by disabling checksum validation.

## Validation Checklist
- [ ] Exact failing artifact coordinate identified
- [ ] Checksum comparison done (source vs target), not assumed equal
- [ ] Consumer configuration confirmed correct (URL, credentials, cache state)
- [ ] Permissions confirmed equivalent to source
- [ ] Fix validated with a real consumer build/pipeline run against the target

## Output Format
- Summary
- Root cause (with evidence: checksums, logs, config diffs)
- Fix
- Validation (successful consumer build/resolution)
- Residual risk

## Safety Notes
- Never disable checksum/signature validation as a "fix" — treat a mismatch as a real data-integrity issue to resolve at the source.
- Never reuse a source-system credential in the target as a workaround — rotate and issue a target-native credential.

Related instructions: `instructions/migrations/migration-pipelines.instructions.md`
