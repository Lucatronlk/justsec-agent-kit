---
name: technical-debt-analysis
description: Prioritize architectural and code debt by measurable reliability, security, delivery, and maintenance costs.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Technical Debt Analysis

## Inputs
Code hotspots, incidents, dependency age, cycle times, ownership, backlog, and business constraints.

## Workflow
1. Inventory debt items with concrete evidence and affected components; do not equate every style issue with debt.
2. Estimate recurring cost, change frequency, failure exposure, remediation effort, and risk of deferral.
3. Group root causes, dependencies, and sequencing constraints; identify quick wins versus migrations requiring design.
4. Produce a ranked register with owner, acceptance criteria, time horizon, and expected payoff.

## Validation
Review estimates with maintainers and compare priorities against incidents and delivery metrics; define baseline metrics for each accepted item.

## Rollback and safety
Analysis is read-only. Prototype risky refactors in a branch, preserve behavioral tests, and revert to baseline if regression gates fail; never delete legacy paths before consumer verification.
