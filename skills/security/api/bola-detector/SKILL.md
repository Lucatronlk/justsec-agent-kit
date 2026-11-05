---
name: bola-detector
description: Detects Broken Object Level Authorization (BOLA/IDOR, OWASP API1:2023) in API endpoints that retrieve, update, or delete a record by a client-supplied identifier. Use when writing or reviewing route handlers with :id params or ORM lookups by ID (findById/findOne/get_object_or_404/findUnique).
---

# bola-detector

## Purpose
Detect **Broken Object Level Authorization (BOLA / IDOR)** — OWASP **API1:2023**, the top API vulnerability. BOLA occurs when an endpoint accepts an object identifier from the client and returns or mutates the object **without verifying that the caller is authorized for that specific object**. Authentication alone is never sufficient.

## When To Use
- Reviewing or generating any endpoint that fetches, updates, or deletes a record by a client-supplied ID.
- Route handlers with `:id` / `{id}` path params; controller functions calling `findById`, `findOne`, `get_object_or_404`, `findUnique`, `repository.findById`, or any ORM lookup by identifier.
- **Not** for holistic endpoint review (use a general API security review for that); this skill is narrowly about object-level authorization.

## Inputs Expected
- The endpoint code (handler/controller + data-access/ORM calls).
- The authentication middleware and how the caller identity is established (`req.user`, `request.user`, `context.user`, claims).
- The data model, including which field ties a record to its owner (e.g. `userId`, `tenantId`, `orgId`).

## Step-By-Step Process
1. Identify how caller identity is established, and confirm it is server-verified (not a client-supplied claim).
2. **Authentication ≠ authorization.** Check for a separate object-level ownership check:
   - Authentication answers *who is calling?* (token/session validation).
   - Object authorization answers *does this caller own this object?* (query filter or policy check).
3. Walk the six-point checklist below.
4. For every failure, produce a concrete finding + exact corrected snippet.

### Six-point checklist
1. **Identity established first** — is there an authenticated server-verified identity?
2. **Ownership checked at query level, not post-fetch** — the ownership predicate belongs *in* the query (`findOne({ _id, userId })`), not in an `if (obj.userId !== user.id)` after loading the row (avoids TOCTOU and data exposure).
3. **Role-based bypass is explicit and server-side** — admin/all-access paths must be checked on the server, not from a client claim.
4. **Bulk/list endpoints are scoped to the caller** — `find({})` must become `find({ userId })`; no unfiltered list access.
5. **Nested/resource chains validated end-to-end** — `/users/:uid/orders/:oid` must verify the caller owns both the parent and the child, not just one.
6. **UUIDs do not eliminate BOLA** — unguessable IDs reduce discoverability, not the need for authorization.

### Core vulnerable vs safe pattern
```javascript
// VULNERABLE: fetch by ID alone — any authenticated user can access any record
const order = await Order.findById(req.params.id);

// SAFE: ownership enforced at the query level
const order = await Order.findOne({ _id: req.params.id, userId: req.user.id });
if (!order) return res.status(404).json({ error: 'Not found' });
```
The same shape applies across stacks (Prisma `findUnique` + ownership `where`, Django `get_object_or_404(Model, pk=id, owner=request.user)`, DRF queryset filtering, Spring `findByIdAndOwnerId`, Go/GORM `Where("id = ? AND user_id = ?")`).

## Severity Classification
| Severity | Condition |
|----------|-----------|
| Critical | Unauthenticated endpoint + no ownership check |
| High | Authenticated, but no ownership check at any level |
| Medium | Ownership checked post-fetch rather than at query level (TOCTOU / exposure) |
| Low | Admin bypass exists but is weak (client-supplied claim, no audit) |

## Validation Checklist
- [ ] Every ID-based endpoint has a query-level ownership predicate
- [ ] Caller identity is server-verified, not client-supplied
- [ ] List/bulk endpoints are scoped to the caller
- [ ] Nested-resource chains validate every level
- [ ] Admin/bypass paths are server-side and audited
- [ ] A negative test exists (user B cannot read user A's object → 404/403)

## Output Format
- Summary: N BOLA findings — n Critical, n High, n Medium, n Low.
- Findings by severity: one block per finding.
- Evidence: `file:line` + the offending call.
- Fix: exact corrected snippet.
- Validation: the negative test proving ownership is enforced.
- Rollback: revert guidance if a change is applied.
- Residual risk: endpoints not reviewed.

Finding block:
```
BOLA Risk — OWASP API1:2023
File: <file>:<line>
Pattern: <one-line description>
Risk: <who can access what, by doing what>
Severity: <Critical | High | Medium | Low>
Fix: <corrected snippet>
```

## Safety Notes
- Read-only review: propose fixes; do not apply them or weaken auth to test.
- Do not print real tokens, session values, or user data in evidence — redact.
- Report unverified suspicions as suspicions, not findings.

Related instructions: `instructions/security/owasp-security.instructions.md`

Attribution: adapted from `apisec-inc/apisec-skills` skill `bola-detector` (MIT, © 2026 apisec inc.).
