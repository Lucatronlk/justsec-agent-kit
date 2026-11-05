---
name: dependency-graph
description: Build evidence-backed service, package, infrastructure, and data dependency graphs to expose coupling and failure paths.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Dependency Graph

## Inputs
Lockfiles, manifests, IaC, API contracts, runtime traces where approved, and scope (build, runtime, or operational).

## Workflow
1. Normalize nodes by identity, version, owner, and environment; distinguish direct from transitive edges.
2. Extract directed edges with source references; label synchronous, asynchronous, optional, and critical dependencies.
3. Detect cycles, shared single points of failure, unsupported versions, and unowned nodes.
4. Deliver machine-readable edge list and a graph with confidence and provenance per edge.

## Validation
Compare a sample of edges to lockfiles and service configuration; confirm direction and exclusions with owners before treating the graph as complete.

## Rollback and safety
Read-only discovery by default; do not pull private artifacts or inspect credentials without permission. Revert graph revisions if validation reveals false edges; preserve the previous known-good graph.
