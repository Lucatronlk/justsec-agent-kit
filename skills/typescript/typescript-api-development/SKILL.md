---
name: typescript-api-development
description: Build type-safe TypeScript APIs with runtime validation, authorization, versioned contracts, and error handling.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# TypeScript API Development

## Inputs
API contract, client versions, auth model, framework, schema definitions, and data persistence semantics.

## Workflow
1. Define routes, input/output schema, status codes, pagination, and idempotency before implementation.
2. Validate at runtime; enforce authorization per resource and constrain body size/rate limits.
3. Keep domain logic separate from transport; propagate trace IDs and structured redacted errors.
4. Add unit, contract, and integration tests for success, unauthorized, malformed, and conflict cases.

## Validation
Compare generated OpenAPI/types with live responses in staging and test backward compatibility across supported clients.

## Rollback and safety
No breaking production contract without rollout approval. Deploy additive changes first; revert route behind flag on regression while preserving data compatibility. Never log auth tokens.
