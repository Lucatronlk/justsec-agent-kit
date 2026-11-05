---
name: python-refactor
description: Refactors Python code without changing behavior when complexity, duplication, or testability improvements are requested.
---

# python-refactor

## Purpose
Refactor Python code for readability, maintainability, and testability without changing behavior.

## When To Use
- Code review flags complexity/duplication.
- Preparing a module for new features or better test coverage.
- Explicit refactor request.

## Inputs Expected
- Target file(s)/module, and existing tests (if any) to preserve behavior against.

## Step-By-Step Process
1. Establish a behavior baseline: run existing tests first; if none exist, write minimal characterization tests before refactoring.
2. Identify the smallest independently-mergeable refactor steps (extract function, remove duplication, add type hints, replace bare `except`, split God-function) rather than one large rewrite.
3. Apply one refactor step at a time; re-run tests after each step.
4. Run `ruff check`/`black`/`mypy` after each step to keep style and typing consistent.
5. Ensure public interfaces (function signatures used elsewhere) are not broken without an explicit, called-out migration note.

## Validation Checklist
- [ ] Tests (existing or newly added characterization tests) pass before AND after refactor
- [ ] `ruff check .` clean
- [ ] `mypy`/`pyright` clean or no new errors introduced
- [ ] No public interface changed without an explicit note
- [ ] Behavior unchanged — no drive-by feature changes mixed into the refactor

## Output Format
- Summary
- Refactor steps taken (in order)
- Validation (test/lint output before and after)
- Residual risk / follow-up refactors deferred

## Safety Notes
- Never mix behavior changes into a "pure" refactor without calling it out explicitly.
- Never remove tests to make a refactor "pass" — fix the refactor instead.

Related instructions: `instructions/python/python-review.instructions.md`, `instructions/python/python-automation.instructions.md`
