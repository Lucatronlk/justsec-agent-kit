---
name: python-security-review
description: Reviews Python services and automation for secure coding risks when a Python security audit is requested.
---

# python-security-review

## When To Use

Use for Python services, scripts, Lambdas, automation, and dependency reviews.

## Workflow

1. Identify entry points, inputs, outputs, and network calls.
2. Review secrets handling, subprocess use, deserialization, filesystem access, and auth logic.
3. Check dependency pinning and known-vulnerability tooling.
4. Verify timeouts, retries, error handling, and logging hygiene.
5. Draft minimal safe fixes.

## Validation Commands

- `ruff check .`
- `bandit -r .`
- `pytest -q`
- `pip-audit` if available

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk

## Related Skills

- [python-untrusted-input](../python/python-untrusted-input/) — loaders, HTTP/GraphQL clients and paths that handle bytes you did not write; run a hostile input, not just a code read.
