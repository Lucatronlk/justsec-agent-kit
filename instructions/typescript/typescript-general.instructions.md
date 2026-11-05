# TypeScript Instructions

> Synthesized from `awesome-copilot` (`instructions/nodejs-javascript-vitest.instructions.md`, `azure-functions-typescript.instructions.md`, `playwright-typescript.instructions.md`, `typescript-mcp-server.instructions.md`, `skills/javascript-typescript-jest`). No single generic "TypeScript best practices" file existed in the source repo — this consolidates the recurring conventions across those narrower files into one general-purpose standard. Converted to generic Markdown; `applyTo` frontmatter dropped in favor of explicit "When To Use" below.

## When To Use

Any TypeScript (or JavaScript-in-a-TS-project) authoring or review — Node.js services, Azure Functions, CLIs, or general application code.

## Coding Standards

- Target a modern, currently-supported Node.js LTS runtime (Node 20+/22+); use ES2022+ language features and native ESM modules unless the project is pinned to CommonJS for a specific reason.
- Prefer Node.js built-in modules over external dependencies; ask before adding a new dependency rather than assuming it's fine.
- Always use `async`/`await` for asynchronous code — avoid raw `.then()` chains and callback-style APIs. Use the promise-based variants of built-ins (e.g. `node:fs/promises` instead of `fs`) so the event loop is never blocked.
- Use `undefined` for "no value," not `null`, unless interoperating with an API/library that specifically requires `null` (e.g. some ORM/DB drivers) — be consistent within a codebase either way.
- Prefer functions over classes unless the object clearly needs mutable internal state or is modeling a real domain entity with identity — don't reach for OOP patterns by default.
- Keep code simple and self-explanatory; avoid comments that just restate what the code does — comment only non-obvious *why*, not *what*.

## Type Safety

- Enable `strict: true` in `tsconfig.json` (or at minimum `strictNullChecks` + `noImplicitAny`) for any new project; don't silently loosen strictness to make errors go away.
- Avoid `any` — prefer `unknown` at trust boundaries (external API responses, `JSON.parse` output) and narrow explicitly before use.
- Avoid non-null assertions (`!`) except where you've genuinely proven the invariant elsewhere; prefer a real guard/check.
- Model domain data with explicit types/interfaces rather than passing around loosely-typed `object`/`Record<string, any>`.
- Use discriminated unions for state/variant modeling instead of multiple optional/nullable fields on one type.

## Async & Error Handling

- Every `async` function that can reject should have a clear error-handling story at the call site — don't let unhandled promise rejections silently disappear.
- Use `Promise.all`/`Promise.allSettled` deliberately, not implicitly serial `await` in a loop, when operations are independent and parallelizable — but be explicit about rate limits/concurrency caps for external calls.
- Prefer typed custom error classes (extending `Error`) over throwing plain strings or untyped objects.

## Testing

- Use Vitest or Jest (pick one per project, don't mix) — see naming/structure conventions below.
- Name test files with a `.test.ts`/`.spec.ts` suffix; co-locate with source or use a `__tests__` directory consistently within a project.
- Structure with `describe`/`it` blocks; test names should read as a behavior statement ("should reject invalid input"), not an implementation detail.
- Mock external dependencies (APIs, databases, filesystem) to isolate the unit under test; reset mocks between tests (`afterEach` + `jest.resetAllMocks()`/`vi.resetAllMocks()`).
- Never change the original code just to make it easier to test — write tests that exercise the code as it actually is; if it's genuinely untestable, that's a design signal to address separately, not to route around.
- For async code: always `await`/`return` promises in tests; use `resolves`/`rejects` matchers; set explicit timeouts for slow tests.
- For React/UI components specifically: prefer Testing Library over Enzyme, query by accessibility role/label/text, use `userEvent` over `fireEvent` for realistic interaction simulation.
- For E2E (Playwright): keep selectors resilient (role/test-id based, not brittle CSS/XPath), isolate test data per run, and avoid hardcoded sleeps — use Playwright's built-in auto-waiting/assertions instead.

## Documentation

- Update `README.md` when adding a feature or making a significant change — don't let docs silently drift from behavior.
- Document public function/type signatures with clear names over verbose comments; use TSDoc only where the signature alone doesn't convey intent (e.g. non-obvious side effects, units, or constraints).

## Security Notes (cross-reference `instructions/security/owasp-security.instructions.md`)

- Never `eval()`/`Function()` on untrusted input.
- Validate/parse all external input (API bodies, query params, env vars) with a schema validator (e.g. Zod) rather than trusting TypeScript types alone — types are erased at runtime and provide zero runtime safety.
- No secrets in source, `.env.example` placeholders only for real `.env` files (see `instructions/security/secrets-handling.instructions.md`).

## Safety Notes

- Ask before adding a new dependency; don't silently expand the dependency surface for a project that explicitly favors built-ins.
- Never disable `strict` TypeScript settings or suppress type errors (`@ts-ignore`/`@ts-expect-error`) to unblock a build without a documented reason and a follow-up ticket to actually fix it.
