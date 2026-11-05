---
name: sli-slo-error-budgets
description: Define user-centered SLIs, measurable SLOs, and error-budget policy with actionable burn-rate alerts.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# SLI SLO Error Budgets

## Inputs
User journeys, service ownership, event telemetry, reliability commitments, release cadence, and incident history.

## Workflow
1. Select request/availability/latency correctness SLIs from actual user-visible outcomes; define numerator and denominator.
2. Set attainable SLO windows and exclusions; calculate remaining budget and burn rates.
3. Draft multi-window alerts and release policies proportional to burn; align with on-call ownership.
4. Review SLOs with service and product owners quarterly using incident and budget history.

## Validation
Backtest queries against outages and quiet periods; verify missing data does not appear as success.

## Rollback and safety
Do not pause deployments automatically without approved policy. Revert broken recording/alert rules to previous version and document data gaps; avoid user identifiers in metric labels.
