---
name: golden-paths
description: Build secure reusable service templates and paved paths for development, deployment, and operations.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Golden Paths

## Inputs
Target workload patterns, language stacks, platform constraints, policy baselines, and developer feedback.

## Workflow
1. Select high-frequency journey; define supported variants and explicit escape hatches.
2. Template repository layout, CI, deployment, ownership metadata, telemetry, and least-privilege defaults.
3. Test generated output with real sample values and negative policy cases.
4. Version template, publish upgrade guidance, and measure adoption and maintenance burden.

## Validation
Generate and build sample service end to end in nonproduction; check health, alerts, secrets references, and documentation freshness.

## Rollback and safety
Do not force-migrate existing services. Keep prior template version, revert generated changes via source control on failed checks, and never include live credentials in scaffolds.
