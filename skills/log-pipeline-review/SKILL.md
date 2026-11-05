---
name: log-pipeline-review
description: Reviews log-forwarding pipelines for reliability, redaction, and secure transport when logging changes are requested.
---

# log-pipeline-review

## When To Use

Use for Logstash, Vector, Alloy, Splunk, syslog, and log-forwarding pipeline reviews.

## Workflow

1. Map sources, transforms, destinations, and trust boundaries.
2. Check parsing accuracy, loss handling, backpressure, retry, and redaction.
3. Review auth, encryption, route exposure, and tenant isolation.
4. Verify pipeline observability and failure alerts.
5. Draft minimal hardening or correctness changes.

## Validation Commands

- `vector validate` if available
- `logstash --config.test_and_exit -f <file>` if available
- `docker compose config`

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk
