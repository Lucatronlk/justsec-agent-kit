---
name: typescript-performance
description: Profile TypeScript/JavaScript CPU, heap, and event-loop performance with repeatable workload baselines.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# TypeScript Performance

## Inputs
Runtime/build targets, representative traffic, latency and memory targets, CPU/heap profiles, and bundle budgets.

## Workflow
1. Record baseline p95/p99, event-loop lag, GC, memory, and bundle size.
2. Profile hot paths and dependency I/O; distinguish compile-time size from runtime cost.
3. Optimize algorithms, allocations, query fan-out, or lazy loading one change at a time.
4. Compare warmed and cold paths; monitor correctness and regressions after staging.

## Validation
Run reproducible benchmarks and load tests with realistic data; reject changes that worsen tail latency or leak memory.

## Rollback and safety
Never capture sensitive heap data without approval. Keep previous bundle/image and revert optimization if error or saturation budgets fail.
