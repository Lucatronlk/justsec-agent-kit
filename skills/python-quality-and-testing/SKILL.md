---
name: python-quality-and-testing
description: Reviews Python code quality and test coverage when maintainability or release readiness is requested.
---

# python-quality-and-testing

## When To Use

Use for Python code quality, test coverage, maintainability, and release-readiness reviews.

## Workflow

1. Identify execution paths and existing tests.
2. Review correctness, typing, error handling, and maintainability.
3. Check test gaps around failure paths, boundary conditions, and integration points.
4. Recommend small tests before larger refactors.
5. Provide validation and rollback guidance.

## Validation Commands

- `pytest -q`
- `ruff check .`
- `python -m compileall .`

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk
