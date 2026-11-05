---
name: agent-integration-testing
description: Test AI-agent interactions with tools, memory, and external systems under realistic failures and security boundaries.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Agent Integration Testing

## Inputs
Agent specification, model/tool versions, golden trajectories, sandbox backends, permissions, and pass thresholds.

## Workflow
1. Assemble deterministic cases for multi-step tasks, tool errors, stale data, prompt injection, and authorization denial.
2. Use isolated fake or nonproduction services with captured tool-call traces and capped tokens/cost.
3. Grade final answer plus intermediate tool choice, arguments, side effects, and recovery after failure.
4. Gate changes on safety and task-success regressions; review flaky model cases separately.

## Validation
Run repeated trials, inspect audit traces, assert no unauthorized writes or secret leakage, and compare baseline distributions.

## Rollback and safety
Never test against live mutating integrations without approval. Revert agent prompt/tool version or disable affected integration if failure threshold is breached; scrub fixtures of real credentials.
