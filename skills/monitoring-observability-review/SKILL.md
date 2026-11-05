---
name: monitoring-observability-review
description: Reviews telemetry, dashboards, and alerting coverage when observability configuration changes are requested.
---

# monitoring-observability-review

## When To Use

Use for Prometheus, Grafana, Loki, Alloy, alerting, dashboards, and service health coverage.

## Workflow

1. Identify telemetry sources, sinks, and alert paths.
2. Check critical coverage for availability, latency, errors, saturation, and security events.
3. Review label cardinality, retention, auth, and exposure of dashboards or metrics.
4. Verify alert routing, ownership, and incident usefulness.
5. Recommend the smallest safe improvements.

## Validation Commands

- `promtool check config <file>`
- `promtool check rules <file>`
- `docker compose config`

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk
