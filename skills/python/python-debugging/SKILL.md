---
name: python-debugging
description: Diagnoses failing, hanging, or incorrect Python code when debugging a script, service, or automation is requested.
---

# python-debugging

## Purpose
Systematically debug a failing Python script, service, or automation pipeline.

## When To Use
- A Python script/service is erroring, hanging, or producing wrong output.
- Incident triage where a Python automation component is a suspect.

## Inputs Expected
- Error message/traceback, or a description of the failure symptom.
- Relevant source file(s) and, if available, logs from the failing run.

## Step-By-Step Process
1. Reproduce: identify the exact command/entrypoint and inputs that trigger the failure.
2. Read the full traceback bottom-up; identify the actual raising line, not just the outermost frame.
3. Check for the common root-cause classes first: unhandled exception type mismatch, `None` where a value was assumed, mutable default argument bug, off-by-one, subprocess/network timeout, or a dependency version mismatch.
4. If logs are involved, use `logging` output (not `print`) and correlate timestamps with the failure window (see `skills/devsecops/pipeline-security-review` if it's a CI failure).
5. Add the minimal instrumentation needed (temporary logging or a small repro script) to confirm the hypothesis — do not guess-and-patch.
6. Propose the smallest fix; note any related risk (e.g., a `bare except:` hiding the real error elsewhere).

## Validation Checklist
- [ ] Failure reproduced (or clearly explained why it can't be, e.g. environment-specific)
- [ ] Root cause confirmed with evidence (log line, traceback, or repro output), not assumed
- [ ] Fix is the smallest change that addresses the root cause
- [ ] Regression test added or existing test updated to cover this failure mode
- [ ] `pytest` (or relevant suite) passes after fix

## Output Format
- Summary
- Root cause (with evidence)
- Fix
- Validation (test run output)
- Residual risk / follow-up

## Safety Notes
- Never patch by silently broadening an `except` clause to "make the error go away."
- Do not run destructive commands (data deletion, prod calls) as part of reproduction — use a sandboxed/dry-run path.

Related instructions: `instructions/python/python-automation.instructions.md`, `instructions/python/python-review.instructions.md`
