---
name: python-untrusted-input
description: Hardens Python code that parses or fetches untrusted input - YAML/JSON loaders, HTTP/GraphQL clients, filesystem paths. Covers safe loaders and the audit greps that actually catch them, validator mutation sweeps, redirect credential carry, non-idempotent replay, path confinement, FIFOs, atomic writes and network-guard completeness. Use when reviewing a loader/parser, an API client, or a file routine that touches bytes you did not write.
---

# python-untrusted-input

## Purpose
"Untrusted" means any bytes you did not write: config files, API responses, downloaded catalogues, directory entries. Defects in this class are found by **running a hostile input**, not by reading the code — the author's tests exercise the happy path the author already believed in. This skill is the bank of specific, measurable defects to look for, and how to prove a fix.

## When To Use
- A diff adds or changes a YAML/JSON/TOML loader, a parser, an HTTP/GraphQL client, or a path/file routine.
- A loader or client processes anything from outside the process boundary.
- Before accepting a "hardened" claim about such code.
- **Not for** pure application logic on values already validated at the boundary — though note that "the boundary validated it" is often the assumption that fails (see the mutation sweep).

## Inputs Expected
- The code under review and its tests.
- A scratch dir, and a way to run the code against a hostile input (a crafted file, a loopback server).

## Step-By-Step Process

### 1. YAML and JSON loading
- **Safe loader only.** `yaml.safe_load`, or an explicit `SafeLoader` subclass.
- **Grep for the whole family, not one spelling.** An audit for `yaml.load(` misses `full_load`, `unsafe_load`, `load_all`, and `load(` with no `Loader=`. Grep every spelling.
- **Duplicate keys.** PyYAML silently keeps the last. Detect during construction (override `construct_mapping`, or walk the composed node tree) and reject.
- **Aliases, anchors and merge keys (`<<`).** Reject or cap them. Alias expansion multiplies memory (the billion-laughs shape); detect it at the event or node level, before construction.
- **Depth.** Cap nesting at compose time, before Python objects exist. For JSON, deep nesting raises `RecursionError`/`ValueError` partway through.
- **Size.** Cap the byte size *before* parsing.
- **One documented error type.** A loader should raise its own exception. Raw `OSError`/`UnicodeDecodeError`/`KeyError`/`RecursionError` escaping to the caller is a finding.

### 2. Validation is a control, so test it like one
Every validation rule needs a test that goes **red when the rule is deleted**. Delete each rule in turn and record the survivors; a survivor is an untested control. (One 14-rule loader sweep left 14 survivors.)

### 3. HTTP / API clients
- **No credentials across a redirect.** `urllib` forwards `Authorization` to the redirect host. Follow redirects only within the same origin, or strip credentials on a cross-origin redirect.
- **Never replay a non-idempotent call after an ambiguous outcome.** A timeout, 5xx or dropped connection is **UNKNOWN**, not failed — re-sending a POST can double-charge or double-create. Retry only idempotent calls, or require an explicit idempotency key.
- **GraphQL returns `errors` alongside partial `data`.** Check both; never read `data != null` as success.
- **Parse `Retry-After` defensively** — reject `nan`, `inf`, negatives and absurd values, and cap the wait.
- **Bound pagination** — a null or repeated cursor must end the loop, not spin.
- **Set connect and read timeouts, and cap the response size** before reading it into memory.

### 4. Paths and files
- **Confine by path components, not by string prefix** (`/srv/data-evil` starts with `/srv/data`).
- **`O_NOFOLLOW` + `dir_fd`** on the open chain; reject `..` and symlinks component by component.
- **FIFOs block a naive read.** Open `O_NONBLOCK` and confirm `S_ISREG` with `os.fstat`.
- **Atomic writes.** Temp file in the *same* directory, `fsync`, `rename`, then `fsync` the directory.

### 5. Network guards must cover the whole surface
A socket-forbidding fixture commonly covers `connect` and misses its siblings. Cover `connect`, `connect_ex`, `sendto` (both the 2-arg and 3-arg forms), `sendmsg`, `gethostbyname`/`gethostbyname_ex`, and `getaddrinfo`. A 3-arg `sendto` survived one fix round that only patched `connect`.

### 6. The three-fix pattern
After fixing one instance, **enumerate the sibling cases before declaring done**. The same bug usually has a twin: 2-arg vs 3-arg, an alias, a second entry point. See `skills/quality/adversarial-review/SKILL.md` attack class 8.

## Validation Checklist
- [ ] Loader is `safe_load`/explicit `SafeLoader`, and the audit greps `full_load`, `unsafe_load`, `load_all` and bare `load(`
- [ ] Duplicate keys, aliases/anchors/merge keys and excess depth are rejected or capped **before** object construction
- [ ] Input size is capped before parsing
- [ ] Each validation rule has a test that fails when the rule is deleted (mutation sweep run; survivors listed)
- [ ] No credential is sent to a different origin after a redirect
- [ ] No non-idempotent call is retried after an ambiguous outcome
- [ ] GraphQL `errors` is checked independently of `data`
- [ ] Pagination terminates on a null or repeated cursor
- [ ] Connect and read timeouts set; response size capped
- [ ] Path confinement by components; `O_NOFOLLOW`; FIFOs handled; writes atomic
- [ ] The network guard covers `connect`, `connect_ex`, `sendto` (2- and 3-arg), `sendmsg`, `gethostbyname`, `getaddrinfo`

## Output Format
The agent's standard report header, then:
- Summary
- Findings by severity — each with the hostile input that produces it and the observed output
- Evidence (command + output)
- Fix
- Validation (the test that bites: red without the fix, green with it)
- Rollback
- Residual risk

## Safety Notes
- Read-only: run hostile inputs against the *code*, never against a live service you do not own.
- Hostile fixtures are test artifacts; keep them in a scratch dir, and never commit a billion-laughs file as a fixture without a size guard.
- Do not print secrets a parser may surface — redact them.

Related instructions: `instructions/python/python-review.instructions.md`, `instructions/python/python-automation.instructions.md`, `instructions/security/owasp-security.instructions.md`
Related skills: `skills/python-security-review/SKILL.md`, `skills/quality/adversarial-review/SKILL.md`, `skills/quality/verification-before-completion/SKILL.md`

Attribution: adapted from `ChiefGyk3D/department-of-internal-arguments` pack `python-untrusted-input` (MIT, © 2026 ChiefGyk3D).
