---
name: alert-noise-reduction
description: Reduce unactionable paging through SLO alignment, deduplication, suppression review, and measured coverage.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Alert Noise Reduction

## Inputs
Alert history, on-call feedback, incidents, routing rules, service dependencies, and SLO/error-budget data.

## Workflow
1. Classify pages as actionable, duplicate, stale, or missing owner; identify alerts tied to real user impact.
2. Propose dedup keys, inhibit rules, severity thresholds, maintenance windows, and ticket-versus-page routing.
3. Test rules against historical incidents and quiet periods before staged rollout.
4. Measure pages per shift, detection delay, missed incidents, and responder feedback after change.

## Validation
Replay critical incidents to prove pages still fire and route correctly; require owner sign-off for suppressed alerts.

## Rollback and safety
Do not silence safety-critical pages without approval. Version rules and revert suppression promptly if detection coverage drops; keep raw event retention for diagnosis.
