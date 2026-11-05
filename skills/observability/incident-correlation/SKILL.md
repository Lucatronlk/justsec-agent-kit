---
name: incident-correlation
description: Correlate service alerts, deploys, traces, and dependency health into explainable incident timelines.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Incident Correlation

## Inputs
Alert events, trace/log links, topology graph, deploy/change records, timestamps, and incident ownership.

## Workflow
1. Normalize event times, labels, environment, service identity, and severity; identify missing telemetry.
2. Group symptoms by shared dependency and temporal overlap; distinguish causation from coincidence.
3. Build evidence-linked timeline with candidate root causes, confidence, and next checks for on-call.
4. Record verified cause and improve correlation rules after incident review.

## Validation
Replay known incidents and unrelated simultaneous alerts; measure grouping precision and missed incidents.

## Rollback and safety
Never auto-remediate based solely on correlation. Keep raw alerts accessible; disable an over-grouping rule and restore prior routing if distinct incidents are suppressed. Redact sensitive log data.
