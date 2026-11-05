---
name: opa-rego
description: Author and test Rego policies for structured authorization and infrastructure decisions with explicit deny behavior.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# OPA Rego

## Inputs
Decision schema, request context, trusted data sources, existing Rego modules, and authorization invariants.

## Workflow
1. Specify input contract, default-deny behavior, and provenance for identity/resource attributes.
2. Write small rules with explicit exceptions and version policy bundles alongside decision tests.
3. Exercise positive, negative, missing-field, and conflicting-rule fixtures; measure decision latency.
4. Stage bundle changes in shadow/audit mode and review diff of real decisions before enforcement.

## Validation
Verify deny-by-default for absent or malformed input; compare allowed/denied results against owner-approved matrix.

## Rollback and safety
Do not publish authorization policy to production without approval. Keep last-good signed bundle and revert if legitimate traffic is blocked; never include secrets in test fixtures or decision logs.
