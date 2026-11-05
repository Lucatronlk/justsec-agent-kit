---
name: typescript-build-tooling
description: Configure TypeScript compiler, bundler, source maps, and package outputs for reproducible builds.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# TypeScript Build Tooling

## Inputs
tsconfig files, bundler config, module target, package exports, build output, and supported runtimes.

## Workflow
1. Map source entry points to emitted JS/types and ESM/CJS consumers.
2. Align tsconfig moduleResolution, target, strictness, path aliases, bundler externals, and declarations.
3. Ensure output has no undeclared imports and source maps do not expose sensitive source unexpectedly.
4. Build clean artifacts in CI with pinned tooling and inspect published files.

## Validation
Compile with noEmit, build package, install it in a clean consumer, and test runtime imports in supported environments.

## Rollback and safety
Avoid silent breaking changes to exports. Keep prior artifact available; revert compiler/bundler config and lockfile together if consumer smoke tests fail. Never bundle secrets.
