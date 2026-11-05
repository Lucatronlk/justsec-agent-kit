---
name: openapi-hardener
description: Tightens API contracts to prevent mass assignment and data exposure (OWASP API3:2023, Broken Object Property Level Authorization). Use when writing, reviewing, or editing an OpenAPI/Swagger spec, JSON Schema, or Zod/Joi/Pydantic schema, or when defining request/response schemas.
---

# openapi-hardener

## Purpose
Treat schema definitions as the **first line of defense** against bad input and data exposure. A loose schema is an attack surface: every unconstrained string is a potential injection vector, every missing `additionalProperties: false` is a mass-assignment risk, and every response without an explicit field list is a data leak waiting to happen. The output is tightened schemas and exact corrected snippets — not general advice.

## When To Use
- Writing, reviewing, or editing an OpenAPI/Swagger spec (`openapi.yaml|json`, `swagger.yaml`).
- Defining API schemas with Zod, Joi, Yup, or Pydantic; writing JSON Schema.
- Reviewing any endpoint contract for input validation or response data exposure.

**Scope note:** this skill hardens the *contract*. Object-level authorization is covered by `bola-detector`; holistic endpoint review is a separate API security review.

## Inputs Expected
- The spec or schema source (OpenAPI/JSON Schema/Zod/Joi/Pydantic).
- The data model and which fields are server-owned (`id`, `createdAt`, `role`, `isAdmin`, secrets).
- The intended request vs. response field sets.

## Security Mindset
- **Input schemas — deny by default.** List only the fields a client may send; everything else must be rejected. This is the schema equivalent of a firewall default-deny rule.
- **Output schemas — explicit allowlist.** List only the fields the server will return, so serializers cannot pass through `passwordHash`, `resetToken`, `internalCost`, `__v`, and similar.

Loose definition → attack it enables:

| Loose definition | Attack |
|---|---|
| `type: string` with no `maxLength` | DoS via oversized payload |
| `type: object` with no `properties` | Mass assignment (client sets any field) |
| `additionalProperties` unset (defaults `true`) | Client sends `isAdmin: true`, `role: "admin"` |
| No `required` array | Client omits critical fields → null/logic bypass |
| No `readOnly` on `id`/`createdAt` | Client sets server-owned values |
| Response with no explicit `properties` | Internal fields leak to client |
| Free `string` for status/role | Arbitrary values bypass business logic |

## Step-By-Step Process
1. Identify every input schema and every output schema; mark which fields are server-owned.
2. Apply the hardening rules field by field:
   - **`additionalProperties: false`** on every object (the default `true` is the #1 mass-assignment cause) — ideally set globally.
   - **`required`** — list mandatory fields; don't leave everything optional.
   - **String constraints** — `maxLength` (and `minLength`/`pattern`/`format`) on every string.
   - **Numeric constraints** — `minimum`/`maximum` (and `multipleOf`) on every number.
   - **Enum exhaustiveness** — constrained enums for status/role/type fields, never free strings.
   - **`readOnly` / `writeOnly`** — mark server-owned fields `readOnly`; mark secrets `writeOnly`.
   - **Separate request and response schemas** — never share one schema for both.
3. Produce the corrected YAML/code for each finding, and (for OpenAPI) a hardened request/response pair for the affected object.
4. Flag any response schema that omits an explicit field list, or that includes password/token/secret fields.

## Validation Checklist
- [ ] `additionalProperties: false` on all input objects
- [ ] `required` lists present and meaningful
- [ ] Length/range/pattern constraints on strings and numbers
- [ ] Status/role/type fields are enums, not free strings
- [ ] Server-owned fields `readOnly`; secrets `writeOnly`
- [ ] Request and response schemas are distinct
- [ ] No secret/internal field (password hash, reset token, internal cost) reachable in a response
- [ ] Corrected snippet produced for every finding

## Output Format
- Summary: N schema findings — n Critical, n High, n Medium, n Low.
- Findings by severity: one block per finding.
- Evidence: `file:line` (or spec path) + the offending definition.
- Fix: exact corrected YAML/code.
- Validation: the linter/validator or test that confirms the tightened schema.
- Rollback: revert guidance if a change is applied.
- Residual risk: schemas not reviewed.

Finding block:
```
Schema Hardening — OWASP API3:2023
File: <file>:<line>
Pattern: <one-line description>
Risk: <concrete attack enabled>
Severity: <Critical | High | Medium | Low>
Fix: <corrected YAML/code>
```

## Safety Notes
- Read-only review: propose schema changes; do not apply them to production contracts without review.
- Never invent field names, constraints, or business rules — base every recommendation on the actual spec and model.
- Redact any real secret values encountered.

Related instructions: `instructions/security/owasp-security.instructions.md`

Attribution: adapted from `apisec-inc/apisec-skills` skill `openapi-hardener` (MIT, © 2026 apisec inc.).
