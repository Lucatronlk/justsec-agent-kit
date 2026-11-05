---
name: typescript-development
description: Implement production TypeScript using explicit contracts, safe type modeling, runtime boundary validation and behavior-focused tests. Use when writing new TypeScript features, libraries, or services.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# typescript-development

## Purpose and scope
Implement new TypeScript behavior, not merely review existing code (`typescript-review`) or restructure it (`typescript-refactor`). Follow `instructions/typescript/typescript-general.instructions.md` and local conventions before choosing patterns or dependencies.

## Inputs
Requirement, target modules, public contracts, supported runtimes, `tsconfig.json`, existing tests and package scripts. If any requirement or API behavior is unclear, ask rather than invent it.

## Workflow
1. Establish observable acceptance criteria, affected callers and error behavior before editing. Identify external input and authorization boundaries.
2. Model valid states explicitly: discriminated unions for variants, generics only where they preserve a useful relationship, `unknown` for untrusted values and `never` for exhaustive branches. Avoid `any`, unsafe casts and gratuitous type complexity.
3. Implement the smallest change compatible with the repository's module system and supported Node/browser runtime. Keep public types aligned with runtime behavior; no type assertion substitutes for validation.
4. For async paths, define ownership of errors, timeouts, cancellation and cleanup. Bound concurrency where calls or resources have limits.
5. Add tests for expected behavior, invalid input and failure handling. Keep an API compatibility note for public type/signature changes.
6. Read the project's existing scripts before running typecheck, lint, test or build; do not install tools or change config solely to get a green result.

## Validation checklist
- [ ] Public types describe actual behavior, including failures and nullability.
- [ ] Untrusted data is validated at runtime (`typescript-untrusted-input` for complex boundaries).
- [ ] Tests cover positive and negative behavior; relevant typecheck, tests and lint were run or marked not-run.
- [ ] No new dependency or changed public API without review and migration notes.

## Output
Summary / Findings by severity / Evidence / Fix / Validation (actual command and result) / Rollback / Residual risk.

## Safety
Never weaken `tsconfig`, suppress errors, invent scripts, read secret files or deploy as a side effect. Security-sensitive code requires `typescript-security-review` and, where necessary, `devsecops-agent`.
