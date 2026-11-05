---
name: change-impact-analysis
description: Estimate downstream blast radius of code, schema, API, and infrastructure changes using dependency evidence and validation gates.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Change Impact Analysis

## Inputs
Proposed diff, dependency graph, deployment topology, consumers, release window, and availability targets.

## Workflow
1. Identify changed contracts, data formats, resources, and behavior; separate known effects from hypotheses.
2. Walk downstream consumers and transitive failure paths by environment and tenant.
3. Rank impact by likelihood, severity, reversibility, and owner; flag irreversible schema or state changes.
4. Recommend compatibility tests, phased rollout, monitoring, and explicit go/no-go criteria.

## Validation
Run approved targeted tests in nonproduction and confirm consumer inventory/contract assumptions with owners; compare expected vs observed impact.

## Rollback and safety
Do not deploy changes during analysis. Require a backup and backward-compatible rollback plan for stateful changes; halt rollout if error budgets or contract checks fail.
