---
name: nodejs-runtime
description: Configure and troubleshoot Node.js runtime behavior, process lifecycle, memory, and deployment compatibility.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Node.js Runtime

## Inputs
Node version, module format, launch command, runtime flags, process manager, and resource limits.

## Workflow
1. Confirm engines, ESM/CJS resolution, native module ABI, and environment variable contract.
2. Inspect startup, event-loop delays, heap use, signals, and health checks under representative load.
3. Set bounded timeouts, graceful shutdown, and observable errors; test a staged runtime upgrade.
4. Record compatibility gaps and release gating criteria.

## Validation
Run clean startup/shutdown, dependency compatibility, and load tests on target Node versions; check unhandled rejections.

## Rollback and safety
No unapproved runtime upgrade in production. Keep previous image/runtime pinned and revert if crashes or latency increase; never dump sensitive environment variables.
