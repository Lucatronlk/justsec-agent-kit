---
name: incident-triage
description: Triages outages, failed deployments, suspicious logs, and security incidents when incident response is requested.
---

# incident-triage

## When To Use

Use for ongoing incidents, suspicious logs, failed deployments, outages, and suspected security events.

## Workflow

1. Establish the situation, timeline, and affected systems.
2. Gather minimal necessary evidence while treating logs as sensitive.
3. Estimate blast radius and likely cause with confidence level.
4. Recommend containment and recovery actions.
5. Capture follow-up work and monitoring gaps.

## Validation Commands

- `git status` for deployment drift when relevant
- service-specific read-only diagnostics approved for the environment

## Output Format

- Situation
- Timeline
- Blast radius
- Likely cause
- Confidence
- Containment
- Recovery
- Follow-up
