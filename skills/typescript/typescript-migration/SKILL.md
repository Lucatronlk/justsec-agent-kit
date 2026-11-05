---
name: typescript-migration
description: Migrate JavaScript or older TypeScript projects incrementally with runtime parity and typed compatibility gates.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# TypeScript Migration

## Inputs
Current JS/TS code, tsconfig, framework/build pipeline, tests, public API, and supported runtimes.

## Workflow
1. Inventory entry points, implicit globals, dynamic imports, module format, and type gaps.
2. Plan phased allowJs/checkJs, strictness increments, and module-by-module conversion without suppressing errors broadly.
3. Update compiler/bundler config and declarations; verify emitted JS and consumer exports.
4. Gate each phase on tests, runtime parity, and type errors trending down.

## Validation
Build and run clean consumer smoke tests on target runtimes; compare API behavior and artifact files before/after.

## Rollback and safety
Avoid simultaneous runtime and language migrations. Preserve previous build pipeline and revert conversion batch if parity fails; do not deploy without approval or leak configuration values.
