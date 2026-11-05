---
name: osquery-fleet-management
description: Manage osquery fleet enrollment, scheduled query packs, performance budgets, and endpoint evidence hygiene.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Osquery Fleet Management

## Inputs
Endpoint inventory, enrollment model, query packs, privacy policy, log retention, and fleet server health.

## Workflow
1. Segment hosts by OS and owner; review enrollment TLS, identity, and offline behavior.
2. Build narrowly scoped scheduled queries with interval, result volume, CPU, and sensitive-field limits.
3. Test on canary endpoints, measure query time and event volume, then stage wider enrollment.
4. Track stale hosts, failed queries, and alert destinations with ownership.

## Validation
Check endpoint coverage, query accuracy on each OS, resource overhead, and log delivery without sensitive-data leakage.

## Rollback and safety
Do not run arbitrary invasive queries or read credential tables without approval. Disable a noisy pack and restore last-good config if hosts degrade; keep enrollment secrets out of logs.
