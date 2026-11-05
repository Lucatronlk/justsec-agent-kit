---
name: compatibility-validation
description: Verify migration target compatibility across interfaces, metadata, runtime behavior, and consumer contracts.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Compatibility Validation

## Inputs
Source/target versions, feature matrix, client inventory, data formats, API contracts, and representative test cases.

## Workflow
1. Discover supported and undocumented source behaviors, protocol versions, and downstream consumers.
2. Plan parity matrix with blocking versus acceptable differences and owners for each gap.
3. Execute isolated contract tests and pilot reads/writes only after approval; compare metadata and observable behavior.
4. Validate compatibility across old/new clients, failure modes, performance limits, and access policies before cutover.

## Rollback and safety
Keep old endpoint and client configurations available. Revert routing if a blocking contract fails; do not assume data written to target is backward-compatible. Avoid live secrets and unapproved production writes.
