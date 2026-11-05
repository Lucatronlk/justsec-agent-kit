---
name: typescript-async-concurrency
description: Handle TypeScript promises, cancellation, queues, retries, and backpressure safely in concurrent workflows.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# TypeScript Async Concurrency

## Inputs
Async call graph, rate limits, ordering needs, timeout and retry policy, and cancellation hooks.

## Workflow
1. Identify fire-and-forget promises, shared state, blocking work, and downstream request ceilings.
2. Add bounded concurrency, AbortSignal propagation, explicit cleanup, and jittered retries for idempotent operations only.
3. Define Promise.all versus allSettled semantics and surface partial failures with context.
4. Instrument inflight counts, queue depth, and timeout/errors.

## Validation
Test concurrent load, cancellation, retries, and slow dependencies; assert no unhandled rejections or duplicate side effects.

## Rollback and safety
Do not raise production concurrency limits without approval. Revert limit/feature flag if downstream saturation grows; redact sensitive request context from errors.
