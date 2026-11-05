---
name: python-async-concurrency
description: Design safe asyncio and Python concurrency with cancellation, backpressure, and bounded resource use.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Python Async Concurrency

## Inputs
I/O workload, event-loop framework, shared resources, timeout requirements, and ordering guarantees.

## Workflow
1. Identify blocking functions, thread/process boundaries, shared mutable state, and external rate limits.
2. Use structured tasks, bounded semaphores/queues, explicit timeouts, and cancellation-safe cleanup.
3. Test retries, partial failures, shutdown, and idempotent operations under concurrent load.
4. Monitor pending tasks, queue depth, errors, and saturation.

## Validation
Stress with slow/dead endpoints and cancellation; ensure no orphan tasks, leaked connections, or broken ordering.

## Rollback and safety
Do not unleash unbounded concurrent production requests. Stage concurrency limits and revert config/code if downstream services saturate; do not expose credentials in task logs.
