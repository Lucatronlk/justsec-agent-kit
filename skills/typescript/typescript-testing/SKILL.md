---
name: typescript-testing
description: Design and validate TypeScript runtime, integration and type-level tests using the project's existing Jest/Vitest or equivalent setup. Use when adding regression tests, reviewing mocks or coverage, or proving type contracts.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# typescript-testing

## Purpose and scope
Prove runtime behavior **and** compile-time contracts separately. Don't install Vitest, Jest or a test-types package when the project already has an established runner.

## Inputs
Changed behavior and risk, current test runner and scripts, `tsconfig`/typecheck config, fixtures, supported runtimes, and safe test data. Inspect test scripts for side effects before running.

## Workflow
1. Pick the cheapest meaningful layer: isolated unit test, integration test at a real boundary, browser/E2E test where interaction demands it, or a compile-time type contract test.
2. For bug fixes, make a focused test fail before changing code. Cover success, malformed input, rejection, cancellation and authorization as relevant.
3. Use existing Vitest/Jest idioms. Await async assertions; restore mocks, fake timers, environment variables and module state between tests. Do not mock the code path under test or overuse snapshots.
4. For type-level tests, use the repository's supported method (e.g. Vitest `expectTypeOf`/`assertType` or a compile-only fixture). Confirm the **typecheck step actually runs**: a green runtime suite alone is not proof of type assertions. Negative type tests must fail when invalid code is accepted; document the expected error for any `@ts-expect-error`.
5. Run targeted tests plus the relevant typecheck and wider suite if safe. Report skipped tests, coverage gaps and flaky behavior, not only passing totals.

## Validation checklist
- [ ] Test reached changed behavior; failing regression observed before fix or noted not-run.
- [ ] Runtime tests and type-level/typecheck gates verified independently.
- [ ] Async assertions awaited and mocks/timers cleaned up.
- [ ] No external service, destructive script or dependency install triggered without approval.

## Output
Summary / Cases and risks / Evidence / Tests changed / Validation (commands, exit codes) / Rollback / Residual risk.

## Safety
Treat test scripts and fixtures as potentially side-effecting. Never run integration/E2E tests against a production or third-party service without scope approval; avoid copying real credentials or customer data into fixtures.
