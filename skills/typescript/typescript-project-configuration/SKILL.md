---
name: typescript-project-configuration
description: Review and configure TypeScript projects for strict types, module resolution, ESM/CommonJS compatibility, declaration outputs and project references. Use when changing tsconfig, exports, build scripts or TS compiler versions.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# typescript-project-configuration

## Purpose and scope
Change project configuration deliberately and verify emitted/runtime compatibility, not merely that `tsc --noEmit` exits zero. Build tools, Node/bundler resolution and library declaration consumers can interpret the same sources differently.

## Inputs
Existing `tsconfig` inheritance and references, `package.json` `type`/`exports`/`engines`, installed TypeScript version, runtime, test/build scripts, declaration consumers and supported environments.

## Workflow
1. Capture the current effective config and package scripts. Decide whether target is Node ESM, Node CommonJS, browser/bundler or dual package; don't combine settings from incompatible targets. Prefer repository defaults over global commands.
2. Check `strict` and related null/implicit-any settings. Identify overrides and suppressions with a documented reason; never relax strictness simply to pass CI.
3. Align `module`, `moduleResolution`, target/libs, path aliases and package `exports` with the actual runtime/bundler. A TS-only path alias needs runtime/build support. Check `.d.ts` outputs and `types`/conditional exports for published packages.
4. For multi-project setups, verify `composite`, references, incremental outputs and dependency order without writing build artifacts into source unexpectedly. Determine whether typecheck and emit are separate gates.
5. Run existing typecheck, build and focused runtime import/consumer checks after reviewing scripts for side effects; for a config change compare emitted entry points/declarations and test both supported module systems if applicable.

## Validation checklist
- [ ] Existing effective settings, supported runtime and module strategy recorded.
- [ ] Strictness not loosened; exceptions justified and scoped.
- [ ] Typecheck, build and runtime/consumer resolution checked separately or marked not-run.
- [ ] Package exports, declaration paths and project references tested where relevant.
- [ ] Generated artifacts and lockfiles not changed accidentally.

## Output
Summary / Configuration and consumers / Findings by severity / Proposed diff / Validation / Rollback / Residual risk.

## Safety
Do not run package lifecycle scripts or install build tools without inspection and approval; no fabricated `tsconfig` flags or universal ESM migration assumptions.
