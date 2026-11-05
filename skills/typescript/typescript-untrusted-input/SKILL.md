---
name: typescript-untrusted-input
description: Harden TypeScript runtime boundaries for JSON, HTTP, env, filesystem and cross-process messages. Use when code reads data it did not produce; narrow unknown with checked schemas before use rather than trusting type assertions.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# typescript-untrusted-input

## Purpose and scope
TypeScript types are erased at runtime. Parse untrusted data as `unknown`, validate it before it reaches business logic and test hostile inputs. Do not presume a schema validator is installed; use existing project tooling or request approval for new dependencies.

## Inputs
Input producers, wire format and size limits, parser/validator and consumers, current schema tooling, error behavior and filesystem/network trust boundaries.

## Workflow
1. Enumerate ingress: `JSON.parse`, HTTP responses and bodies, query/path parameters, environment values, storage, IPC/postMessage and third-party SDK responses. Trace each to sensitive operations.
2. Set resource bounds before parsing (size, depth, count and timeouts where applicable). Parse to `unknown`; use an existing Zod/Valibot/JSON Schema validator or an explicit predicate that checks required fields, ranges, enums and unexpected keys. `as T`, a generic `response.json<T>()`, and `satisfies T` do not validate runtime data.
3. Reject malformed, prototype-sensitive (`__proto__`, `constructor`, `prototype`) and out-of-policy objects at the boundary when merging dynamic keys. Normalize paths and verify containment before filesystem access, including symlinks/races where relevant. Validate URL scheme, host, redirects and egress for remote fetches.
4. Keep authorization separate from shape validation; tenant/object ownership must be checked against a server-verified identity. Define safe error messages that don't disclose input or secrets.
5. Test missing/wrong fields, extra keys, oversized payloads, malicious paths/URLs, redirect changes, and unexpected runtime types. Prove invalid input is rejected before the sink.

## Validation checklist
- [ ] Every external value is `unknown` until validated at runtime.
- [ ] Bounds and redirect/path rules reflect actual system limits and threat model.
- [ ] Validation rejects hostile variants; authorization remains independently enforced.
- [ ] Negative tests and typecheck run or clearly marked not-run.
- [ ] No full secrets or private input data are logged or copied into findings.

## Output
Summary / Boundary inventory / Findings by severity / Evidence / Fix / Validation / Rollback / Residual risk.

## Safety
Never add a schema dependency, make a network request or read credential files without explicit authorization; do not bypass tests by asserting a type.
