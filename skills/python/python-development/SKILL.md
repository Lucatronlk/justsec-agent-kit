---
name: python-development
description: Develop maintainable Python modules with explicit interfaces, type hints, tests, and safe dependency handling.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Python Development

## Inputs
Feature contract, supported Python versions, repository conventions, dependency constraints, and test fixtures.

## Workflow
1. Trace existing call sites and error behavior; specify input/output types and failure cases.
2. Implement small composable functions; isolate I/O from business logic and use context managers for resources.
3. Add tests for boundary values and failures; run formatter, linter, type checker, and targeted suite.
4. Document compatibility and operational impacts for reviewers.

## Migration automation (when moving repositories, pipelines, or artifacts)
Apply this to Python transfer tooling alongside the relevant platform migration skill and `instructions/migrations/migration-pipelines.instructions.md`; platform inventory, parity and cutover decisions remain there.

- Model each item with stable source identity, target mapping, expected SHA-256 (for artifacts) and metadata in a versioned, immutable inventory manifest. Record its digest/run ID; never silently revise a manifest during resume. New source state needs a new manifest and reconciliation plan.
- Default to read-only discovery/`--dry-run`: preview counts, mappings, writes, overwrites and skips without invoking mutation endpoints. Require separate explicit, scoped human approval before live writes; never let a dry-run flag or tool permission count as production approval. Keep deletes/overwrites separately gated.
- Persist a durable per-item checkpoint keyed by manifest digest and stable identity/idempotency key; write it atomically. On restart, verify manifest digest and target state before skipping an item. Mark success only after confirmed target integrity/metadata parity, not merely after a request returned. Treat uncertain write outcomes as unknown: reconcile target first, never blindly replay a non-idempotent request.
- Bound page count/items and detect repeated or missing cursors; fail closed on truncated inventory or API errors instead of calling it complete. Limit concurrency and request rate, honor bounded `Retry-After`, use capped exponential backoff with jitter and timeouts for retryable reads/idempotent writes; stop after a finite retry budget. Do not retry auth, validation or checksum failures as transient.
- Produce structured per-item outcomes (pending, verified, failed, unknown) with redacted logs: no tokens, signed URLs, auth headers or secret-bearing payloads. Preserve failed/unknown items and reason codes for later reconciliation; never advance cutover on partial success.
- Test offline with fake APIs/files: duplicate pages/items, cursor loops, 429/5xx and timeout exhaustion, interruption before/after checkpoint, ambiguous write followed by resume, manifest drift, checksum mismatch, and partial batch failure. Assert dry-run performs zero writes and unapproved writes are rejected. Run a non-production pilot only after authorization.

## Validation
Confirm happy path, negative path, and version compatibility in CI; check public API behavior against prior contract.

## Rollback and safety
Do not run writes against live data during development. Keep change behind a flag when behavior is risky and revert commit if regression occurs; never log secrets.
