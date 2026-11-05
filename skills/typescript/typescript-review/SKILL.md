---
name: typescript-review
description: Reviews TypeScript code for type safety, correctness, testing, and secure input handling when a TypeScript change is requested.
---

# typescript-review

## Purpose
Review TypeScript code for type safety, correctness, testing coverage, and maintainability.

## When To Use
- Any TypeScript PR or module change.
- Explicit request to review/refactor TypeScript code.
- Pre-merge check on a new Node.js/TypeScript service or CLI.

## Inputs Expected
- Target file(s)/module or PR diff.
- `tsconfig.json` (to check strictness settings) and existing tests, if any.

## Step-By-Step Process
1. Check `tsconfig.json` strictness (`strict`, `noImplicitAny`, `strictNullChecks`) — flag if loosened without justification.
2. Scan for `any`/non-null assertions (`!`) at trust boundaries (external API responses, `JSON.parse`, env vars) — these should be `unknown` + narrowed, not `any`.
3. Check async/error handling: unhandled promise rejections, serial `await` in a loop where parallelization was intended, missing try/catch or `.catch()` at a real failure boundary.
4. Check for `@ts-ignore`/`@ts-expect-error` suppressions without a documented reason.
5. Check test coverage: new/changed logic has corresponding tests; test names describe behavior, not implementation; mocks isolate external dependencies.
6. Check dependency additions: is a new package actually necessary, or does a built-in/existing dependency cover it?
7. Check for untrusted-input handling: is external input validated with a schema (e.g. Zod) rather than trusted via TypeScript types alone (types are erased at runtime)?
8. Propose the smallest safe patch for each finding.

## Validation Checklist
- [ ] `tsc --noEmit` (or project build) passes with no new errors
- [ ] No unjustified `any`/`@ts-ignore`/`@ts-expect-error`
- [ ] External input validated with a runtime schema, not just typed
- [ ] Async code has explicit error handling; no silent unhandled rejections
- [ ] Tests exist for new/changed logic and pass (`vitest run` / `jest`)
- [ ] No unnecessary new dependencies added without justification
- [ ] `README.md` updated if behavior/usage changed

## Output Format
- Summary
- Findings by severity
- Evidence (file:line)
- Fix (patch)
- Validation (build/test output)
- Residual risk

## Safety Notes
- Review only — do not `npm install`/add dependencies or run destructive scripts as part of this skill.
- Never silently loosen `tsconfig.json` strictness or suppress a type error to "make the review pass."

Related instructions: `instructions/typescript/typescript-general.instructions.md`, `instructions/security/owasp-security.instructions.md`
