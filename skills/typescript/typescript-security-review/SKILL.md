---
name: typescript-security-review
description: Review TypeScript and JavaScript runtime code for input, injection, authorization and dependency risks. Use for security-sensitive TypeScript changes; escalate deep threat modeling, secrets scanning and CI security to devsecops-agent.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# typescript-security-review

## Purpose and scope
Identify security defects in Node/browser TypeScript code without treating compile-time types as runtime protection. This is focused code review, not a substitute for SAST, DAST, penetration testing or `devsecops-agent`'s security sign-off.

## Inputs
Changed code, entry points, trust boundaries, request schemas, auth/authz flow, dependency and lockfile diff, deployment context and existing security tests.

## Workflow
1. Map sources (HTTP bodies, env/config, URLs, postMessage/IPC, dependencies) to sinks (SQL/command/template/DOM, filesystem, fetch and authorization decisions).
2. Check validation **at each boundary** using `typescript-untrusted-input`. Look for unsafe casts, prototype pollution via dynamic keys/merge, deserialization assumptions, path traversal, SSRF (including redirects/DNS), command injection, XSS/HTML sinks and insecure IPC exposure.
3. Trace authentication to every object-level and tenant-level authorization check; a typed ID is not proof of access. Review CSRF/session/cookie controls where relevant.
4. Inspect dependency changes and lockfile integrity; no blind install, audit fix or lockfile deletion. Check secrets by metadata/diff, never print credential values.
5. Require negative tests for each confirmed finding (unauthorized caller, malicious payload, denied destination). Reproduce safely in a local test only when authorized; do not probe production or third parties.
6. Escalate complex authorization, threat-model, MCP/LLM, supply-chain or CI issues to `devsecops-agent` and its domain skills; record scope not reviewed.

## Validation checklist
- [ ] Untrusted sources and sensitive sinks mapped with file:line evidence.
- [ ] Runtime validation and object authorization verified independently.
- [ ] Each confirmed finding has a safe reproduction or explicitly stated limitation.
- [ ] Secrets redacted; no external target touched without approval.
- [ ] Typecheck/tests/scans actually run or listed as not-run; residual risk named.

## Output
Summary / Findings by severity / Evidence / Fix / Validation / Rollback / Residual risk.

## Safety
Never run scanners against third-party or production targets without scope approval. Never relax guards, scanners or tests to make an unsafe change pass.
