---
name: synthetic-monitoring
description: Build safe synthetic checks for critical user journeys across regions with reliable alert thresholds.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Synthetic Monitoring

## Inputs
Critical journeys, test endpoints/accounts, regions, traffic budget, authentication strategy, and expected outcomes.

## Workflow
1. Choose lightweight probes for DNS/TLS/HTTP and bounded browser transactions for checkout or sign-in paths.
2. Use dedicated least-privilege test identities and isolated fixtures; label synthetic traffic and clean up writes.
3. Set region-aware frequency, timeout, retry, and threshold; route alerts to responsible on-call.
4. Compare synthetic failures with real-user signals and incident history.

## Validation
Induce a controlled staging failure to prove alert delivery and recovery; check false positives and probe load.

## Rollback and safety
Never place live passwords in scripts or generate uncontrolled production transactions. Disable noisy checks or revert prior configuration if probe traffic harms service; require approval for production tests.
