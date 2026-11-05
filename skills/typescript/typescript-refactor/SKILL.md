---
name: typescript-refactor
description: Refactor TypeScript while preserving runtime behavior and public type/API contracts. Use for extracting modules, reducing unsafe casts, converting JavaScript incrementally, or simplifying code without a requested behavior change.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# typescript-refactor

## Purpose and scope
Change internal structure, not semantics. For a bug fix use `typescript-debugging`; for a feature use `typescript-development`. Type-only edits can still break consumers: emitted declarations and compile-time API compatibility matter.

## Inputs
Target code, affected callers, public declarations/exports, current test baseline, TypeScript settings, module format and migration constraints.

## Workflow
1. Define invariants: exported names, observable runtime behavior, error semantics, serialization and supported import paths. Identify consumers before editing public types.
2. Run or record existing tests and typecheck as baseline; if no gate exists, create focused characterization tests before structural changes.
3. Refactor in small steps. Preserve `this` binding, initialization order, side effects, generic variance and inference for callers. Replace unsafe casts with explicit narrowing only when it preserves behavior.
4. For JS-to-TS conversion, migrate a narrow boundary at a time; compare emitted runtime behavior and package exports. Don't turn on permissive flags globally to hide errors.
5. Compare public declarations or consumer fixture builds, run affected tests/typecheck/lint, and inspect the diff for unrelated changes.

## Validation checklist
- [ ] Before/after tests cover unchanged behavior and failure paths.
- [ ] Public types/exports and inferred call-site contracts remain compatible, or breaking changes are explicitly approved.
- [ ] Typecheck and relevant build/test commands run with observed results; missing gates disclosed.
- [ ] No silent strictness relaxation, `any` substitution, or blanket suppression.

## Output
Summary / Behavior invariants / Evidence / Patch or proposal / Validation / Rollback / Residual risk.

## Safety
No unrelated cleanup folded into a bug fix; do not publish or migrate consumers without authorization. Keep separate commits only when explicitly requested.
