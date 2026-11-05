---
name: readme-generator
description: Generates or refreshes a README from verified repository details when project documentation is missing or stale.
---

# readme-generator

## Purpose
Generate or refresh a project's `README.md` (and, optionally, higher-level architecture summary docs) by discovering the actual technology stack, structure, and usage from the repository — not from assumptions.

## When To Use
- A project has no `README.md`, or its README is stale relative to the current codebase.
- Explicit request to generate/refresh project documentation.

## Inputs Expected
- Repository root path (read access to source, config, `package.json`/`pyproject.toml`/etc., and any existing docs).
- Optional: example READMEs the user explicitly points to for tone/structure inspiration (not to copy from).

## Step-By-Step Process
1. Discover the project: language/framework/runtime, entry points, build/test/run commands (from actual config files — `package.json` scripts, `Makefile`, `pyproject.toml`, CI config — not guessed).
2. Check for existing context first: `AGENTS.md`/`README.md`/`ARCHITECTURE.md`/`.github/copilot-instructions.md` — read and respect what's already there rather than overwriting authoritative content.
3. Draft README sections: what it is (one paragraph), quick start (fewest steps to a working example, verified against actual scripts/commands), configuration, and links to deeper docs — not an exhaustive inline API reference.
4. Keep it concise; don't duplicate `LICENSE`/`CONTRIBUTING.md`/`CHANGELOG.md` content — link instead.
5. For architecture-level documentation requests, structure using the C4 model (Context/Container/Component/Infrastructure) per `instructions/documentation/technical-writing.instructions.md`.
6. Verify every command/snippet actually works against the current repo state before including it (run it if safe/read-only to do so; otherwise flag as unverified).

## Validation Checklist
- [ ] Every command/script referenced actually exists in the project (verified, not assumed)
- [ ] No content duplicated from LICENSE/CONTRIBUTING/CHANGELOG
- [ ] Existing authoritative docs (AGENTS.md, ARCHITECTURE.md) respected, not silently overwritten
- [ ] Concise — no excessive emoji use, no exhaustive inline reference material
- [ ] GitHub-Flavored Markdown used correctly (admonitions, code fences with language tags)

## Output Format
- Generated/updated `README.md` (and any companion architecture doc requested).
- Summary of what was discovered (stack, entry points, commands) and what was assumed vs. verified.

## Safety Notes
- Read-only with respect to application/production code — this skill produces documentation only.
- Never fabricate a command or config value discovered "probably" — verify against the actual repository or flag explicitly as unverified.
- Do not overwrite an existing `AGENTS.md`/`ARCHITECTURE.md` without explicit instruction; prefer additive updates.

Related instructions: `instructions/documentation/technical-writing.instructions.md`
