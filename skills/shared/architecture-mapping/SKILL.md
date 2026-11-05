---
name: architecture-mapping
description: Map system components, ownership, trust boundaries, and data flows from repository and design evidence before proposing architecture changes.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Architecture Mapping

## Inputs
Repository/service inventory, deployment manifests, diagrams, ownership records, and the question the map must answer.

## Workflow
1. Establish scope and distinguish observed implementation from proposed design.
2. Trace entry points through services, persistence, queues, external APIs, and network/trust boundaries; cite evidence for each edge.
3. Record owners, environments, interfaces, data classification, and uncertain or missing links.
4. Produce a component-and-flow map plus an assumptions register; review with system owners.

## Validation
Check map edges against code/config and at least one runtime or owner source when available; identify orphan components and unverified claims.

## Rollback and safety
Mapping is read-only. Do not scan production or access secrets without approval. If a proposed map is wrong, revert the diagram to the last reviewed version and mark disputed edges unresolved.
