---
name: hashicorp-vault-migration
description: Migrate Vault clusters and auth paths with secret engine, policy, lease, and seal compatibility while protecting sensitive material.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# HashiCorp Vault Migration

## Inputs
Vault versions, storage/seal configuration, mount inventory, auth methods, namespaces, policies, PKI, dynamic engines, clients, leases, and recovery objectives.

## Workflow
1. Discover mounts/versions, auth role references, lease TTLs, replication, audit devices, and client endpoints from metadata only.
2. Plan supported snapshot/replication method, unseal/KMS access, policy and path mapping, PKI trust continuity, dynamic credential turnover, and write freeze.
3. With security approval, rehearse in isolated environment and execute bounded cluster migration; switch client endpoints gradually.
4. Validate sealed/unsealed recovery, policy allow/deny tests, auth logins, engine metadata, issuance/renewal/revocation, and audit continuity without displaying secret values.
5. Monitor lease failures and auth errors through bake period.

## Rollback and safety
Never print/export plaintext secrets in reports or clone production data without authorization. Retain protected source and encrypted snapshots; revert clients to old endpoint only if lease/state divergence is understood. No source teardown before owner sign-off.

## Readiness, parity and recovery gates
- Inventory every namespace, mount/path and engine type/version, auth method/role, policy, audit device, seal/KMS dependency, replication mode, client/service owner and lease/PKI dependency using metadata only. Map read/write paths and TTL/renewal obligations; missing access or unsupported state/snapshot compatibility is a blocker, never inferred parity.
- Before any production snapshot, transfer or endpoint switch obtain distinct security/data-owner approvals for scope, isolated rehearsal and production window, encryption/access controls, approved recovery operator, tested restore/unseal path and rollback time. Use new scoped target credentials; never reuse source auth secrets. This skill does not authorize live migration, secret reads or plaintext export.
- Compare complete *enumerable non-secret* source/target mount/auth/policy/role metadata lists and configuration fingerprints with zero unexplained differences. Test an allow and deny decision per policy/role class, auth per client class, engine-specific issuance/renewal/revocation and PKI trust chain, audit delivery, restart/unseal recovery. Secret payloads, non-exportable keys, dynamic leases and eventual consistency cannot be safely hashed for exhaustive value parity: log coverage/limits and require owner-approved validation using synthetic canary secrets/leases only; do not claim exhaustive secret integrity. Track lease counts/expiry/renewal failures and auth errors against agreed pre-cutover baselines and bake thresholds.
- Preserve timestamped redacted metadata manifests, test IDs/results, encrypted snapshot verification (without contents), audit continuity evidence, approvals and explicit exceptions in restricted storage. Any unexplained config mismatch, failed deny test, lease/PKI outage or unsafe divergence is no-go. Stop endpoint shifts, retain source and protected snapshots; revert only clients whose state/leases are reconciled, otherwise isolate affected clients and follow approved recovery plan. Revalidate before retry and keep source until bake and owner sign-off.
