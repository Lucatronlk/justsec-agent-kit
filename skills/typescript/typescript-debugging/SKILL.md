---
name: typescript-debugging
description: Diagnose TypeScript compiler, module-resolution, source-map, runtime and async failures with reproducible evidence. Use when a TypeScript build, typecheck, test or execution fails; pair with systematic-debugging.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# typescript-debugging

## Purpose and scope
Add TypeScript-specific diagnostics to `systematic-debugging`'s root-cause process; do not use this skill as a shortcut around reproduction. Do not mistake a type error for the location of the underlying design defect.

## Inputs
Exact error and failing command, relevant `tsconfig` and package scripts, supported runtimes, lockfile/package metadata, recent diff and the minimal failing file or test.

## Workflow
1. Reproduce with the **existing** project command; record exact diagnostics, TypeScript/runtime version from the installed environment, command and exit code. If reproduction is unsafe/unavailable, state why.
2. Sort the failure: parse/type inference, declaration compatibility, module resolution/ESM versus CommonJS, emitted code/source maps, runtime exception, or async/test timing.
3. Trace evidence to the first incorrect assumption. Check the effective config and module format before proposing config changes; distinguish generated declarations from source. Do not delete a lockfile or reinstall dependencies to guess a fix.
4. Write a minimal failing regression (or document why impossible), test one root-cause hypothesis and change one variable at a time.
5. Apply a minimal fix if authorized; run the failing check and neighboring tests again. Treat typecheck and runtime tests as separate gates; one cannot prove the other.

## Validation checklist
- [ ] Full error, reproduction command and observed result captured.
- [ ] Module and runtime assumptions checked against local config, not guessed.
- [ ] Regression fails before fix and passes after, or the gap is disclosed.
- [ ] Typecheck **and** relevant runtime tests/build are run or explicitly not-run.
- [ ] Temporary debug instrumentation removed and tree changes accounted for.

## Output
Root cause / Evidence (file:line, command, result) / Minimal fix / Validation / Rollback / Residual risk.

## Safety
No blind `@ts-ignore`, force-install, global tool install, test weakening or speculative compiler flag changes. Do not expose env values in diagnostic logs.
