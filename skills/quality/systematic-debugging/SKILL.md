---
name: systematic-debugging
description: Use when encountering any bug, test failure, build failure, performance problem, or unexpected behavior — before proposing fixes. Finds root cause first; symptom fixes are failure.
---

# systematic-debugging

## Purpose
Find the **root cause before attempting any fix**. A fix that addresses where the error appears — rather than where it originates — is a symptom fix and will recur. The process is deliberately slower per attempt and much faster overall than guess-and-check thrashing.

## When To Use
- Any test failure, production bug, build failure, integration issue, or performance regression.
- Any "unexpected behavior" that isn't yet understood.
- **Especially** when under time pressure, when a "quick fix" seems obvious, or after one or more fixes already failed.

**Do not skip** because the issue looks simple, because you are in a hurry, or because someone wants it fixed immediately.

## Inputs Expected
- The error message / stack trace / failing output, in full.
- A way to reproduce the issue.
- Access to recent changes (git log, diff) and the relevant code paths.

## Step-By-Step Process
Complete each phase before starting the next.

### Phase 1 — Root Cause Investigation
1. **Read the error completely** — stack traces, line numbers, error codes, warnings. Do not skip past them.
2. **Reproduce consistently** — exact steps, every time? If not reproducible, gather more data; do not guess.
3. **Check recent changes** — what changed that could cause this? Git diff, new dependencies, config, environment.
4. **Gather evidence at component boundaries** — for multi-component systems (CI → build → sign, API → service → DB), add instrumentation that logs what enters and exits each boundary, run once to see *where* it breaks, then investigate that component.
5. **Trace data flow** — when the error is deep in a call stack, trace the bad value backward to its origin using the technique below.

### Phase 2 — Pattern Analysis
1. Find similar **working** code in the same codebase.
2. Compare against the reference implementation — read it completely, don't skim.
3. List every difference between working and broken, however small.
4. Understand the dependencies, config, and assumptions the broken path makes.

### Phase 3 — Hypothesis and Testing
1. State a single specific hypothesis: "X is the root cause because Y".
2. Test it with the **smallest possible change**; one variable at a time.
3. If it didn't work, form a new hypothesis — do not stack more fixes on top.
4. If you don't know, say so explicitly rather than pretending.

### Phase 4 — Implementation
1. Create a failing test that reproduces the bug **before** fixing (use `verification-before-completion` before claiming it is fixed).
2. Implement a single fix that addresses the root cause — no "while I'm here" refactors.
3. Verify: the test passes, no other tests broke, the symptom is gone.
4. If the fix fails: stop, count attempts. If fewer than 3, return to Phase 1 with the new information.
5. **If 3+ fixes have failed, question the architecture**, not the hypothesis. Repeated fixes that each reveal a new problem elsewhere are the signature of a design problem, not a bug. Stop and raise it with the human before attempting another change.

### Supporting techniques
- **Root-cause tracing:** trace backward through the call chain until you find the original trigger (where the bad value originated), then fix at the source. When manual tracing is impossible, add a temporary stack-trace log (`new Error().stack`) *before* the failing operation, run once, capture, and remove. Use `console.error` in tests; loggers are often suppressed.
- **Defense in depth:** after finding the root cause, add validation at *every* layer the data passes through — entry-point validation, business-logic validation, environment guards, and debug instrumentation. One check can be bypassed by another code path, a mock, or a refactor; several layers make the bug structurally impossible.

## Validation Checklist
- [ ] The full error output was read before any fix was proposed
- [ ] The issue was reproduced (or inability to reproduce was stated)
- [ ] Recent changes were checked
- [ ] A single, explicit root-cause hypothesis was tested in isolation
- [ ] A failing test existed before the fix
- [ ] The fix addresses the root cause, not the symptom location
- [ ] No unrelated refactoring was bundled in
- [ ] If 3+ fixes failed, the architecture was questioned instead of a 4th attempt

## Output Format
- Summary: root cause, in one or two sentences.
- Findings by severity: contributing factors (per `SEVERITY.md`).
- Evidence: exact error output, trace, reproduction steps, relevant file:line.
- Fix: the minimal change at the source, with the failing test added.
- Validation: the command proving the fix and that nothing else broke.
- Rollback: how to revert the fix.
- Residual risk: related paths left unverified.

## Red Flags — stop and return to Phase 1
- "Quick fix for now, investigate later."
- "Just try changing X and see."
- Bundling multiple changes and running tests.
- "It's probably X, let me fix that."
- "I don't fully understand but this might work."
- Listing fixes before tracing the data flow.
- "One more fix attempt" when 2+ have already failed.
- Each fix reveals a new problem in a different place.

## Safety Notes
- Read-only by default: diagnose and add a failing test; do not weaken or disable existing tests, guards, or scanners to make a symptom disappear.
- Remove temporary instrumentation before finalizing.
- Prefer the smallest safe change (per `STANDARDS.md` "Patch Philosophy").

Related instructions: `instructions/devsecops/devsecops-general.instructions.md`, `instructions/python/python-review.instructions.md`

Attribution: adapted from `obra/superpowers` skill `systematic-debugging` (MIT, © 2025 Jesse Vincent).
