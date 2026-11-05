# Severity Model

## Critical

- Description: Immediate exploitability, active compromise risk, or major exposure of production systems or secrets.
- Examples: Public admin endpoint without auth, exposed cloud keys, cluster-admin to anonymous users, supply-chain compromise in production path.
- Expected response: Immediate containment, owner escalation, rollback or mitigation now, same-day remediation and incident handling.

## High

- Description: Strong security or production risk with realistic abuse path or significant blast radius.
- Examples: Broad IAM wildcard in production, missing encryption on sensitive storage, unsafe CI secret handling, public service without required controls.
- Expected response: Prioritize in current cycle, add mitigation if fix must wait, validate carefully before release.

## Medium

- Description: Real weakness that weakens defenses, correctness, or recovery, but is not immediately catastrophic.
- Examples: Missing alerts, weak image pinning, incomplete network restrictions, unsafe Python subprocess pattern with limited exposure.
- Expected response: Fix in planned work, track owner and due date, improve tests and monitoring.

## Low

- Description: Hygiene issue or low-likelihood weakness with limited impact.
- Examples: Inconsistent tagging, missing comments for risky workflow steps, stale but unused dependency, minor logging gaps.
- Expected response: Clean up opportunistically or batch with related work.

## Info

- Description: Improvement, observation, or hardening suggestion with no confirmed defect.
- Examples: Suggest OIDC migration, propose tighter retention, recommend standard labels, note validation gaps.
- Expected response: Consider during next maintenance cycle or platform refresh.
