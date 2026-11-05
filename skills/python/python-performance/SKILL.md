---
name: python-performance
description: Profile Python CPU, memory, and I/O bottlenecks and validate optimizations with representative benchmarks.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Python Performance

## Inputs
Latency/throughput SLOs, representative workload, profiles, runtime version, and memory/CPU budgets.

## Workflow
1. Establish p50/p95/p99 and resource baseline under repeatable inputs.
2. Profile call stacks, allocations, queries, and I/O; distinguish algorithmic cost from external latency.
3. Change one bottleneck at a time: data structures, batching, caching, or concurrency with bounded resources.
4. Benchmark before/after and inspect correctness, tail latency, and memory growth.

## Validation
Repeat tests on realistic data and warm/cold paths; reject changes with correctness regression or unstable gains.

## Rollback and safety
Avoid profiling sensitive production data without approval. Feature-flag high-risk optimizations and revert to baseline if latency or error budgets worsen.
