# OWASP / Secure Coding Instructions

> Condensed from `awesome-copilot/instructions/security-and-owasp.instructions.md` (the largest single secure-coding reference found, ~1000 lines, OWASP Top-10 2025 aligned). Fully generic content, no Copilot dependency. Read the source repo file directly if you need the full 50+ anti-pattern catalog with regex detectors.

## When To Use

Any code review, secure-coding guidance, or SAST-style manual review.

## OWASP Top-10 Quick Reference

| Category | Key Risk | Primary Mitigation |
|---|---|---|
| A01 Broken Access Control | Missing authz checks, IDOR | Deny-by-default, verify ownership server-side |
| A02 Cryptographic Failures | Weak/no encryption, weak hashing (MD5/SHA1 for passwords) | TLS everywhere, bcrypt/argon2, KMS-managed keys |
| A03 Injection | SQLi, command injection, SSRF | Parameterized queries, allow-lists, no string-built shell commands |
| A04 Insecure Design | Missing threat modeling | Threat model before build (see `threat-modeling.instructions.md`) |
| A05 Security Misconfiguration | Default creds, verbose errors, open cloud storage | Hardened baselines, secret scanning, least-privilege |
| A06 Vulnerable Components | Outdated/unpatched deps | SCA scanning, dependency pinning, patch cadence |
| A07 Auth Failures | Weak session mgmt, credential stuffing | MFA, rate limiting, secure session tokens |
| A08 Data Integrity Failures | Unsigned updates, insecure deserialization | Signed artifacts, safe deserialization libraries |
| A09 Logging Failures | No security event logging | Structured logs for auth/authz/config events, no secrets in logs |
| A10 SSRF | Server fetches attacker-controlled URLs | Scheme + hostname allow-list, block internal IP ranges |

## Representative Before/After (SSRF)

```typescript
// BAD
const data = await fetch(req.body.url);

// GOOD — scheme allow-list + hostname allow-list + DNS/IP validation
const url = new URL(req.body.url);
if (!["https:"].includes(url.protocol)) throw new Error("blocked scheme");
if (!ALLOWED_HOSTS.has(url.hostname)) throw new Error("blocked host");
```

## Category Groups (for deeper review)

- **I1-I8** Injection (SQL, command, LDAP, XML, template, NoSQL, header, log injection)
- **AU1-AU8** Authentication (session fixation, credential stuffing, weak password reset, MFA bypass)
- **AZ1-AZ6** Authorization (IDOR, privilege escalation, missing function-level access control)
- **S1-S6** Secrets (hardcoded keys, secrets in logs, secrets in error messages, secrets in git history)
- **H1-H8** Security Headers (CSP, HSTS, X-Frame-Options, missing CORS restrictions)
- **D1-D5** Dependencies (unpinned versions, known-CVE packages, typosquatting risk)
- **AP1-AP6** API Security (missing rate limiting, mass assignment, excessive data exposure)
- **AI1-AI3** LLM/AI-specific (prompt injection, insecure output handling, training data leakage)
- **L1-L4** Logging (missing audit trail, logging secrets/PII, log injection, insufficient retention)

## Review Process

1. Identify language/framework and apply framework-specific patterns (React/Angular/Express/Django/Flask/Go).
2. Scan for the categories above; cite exact file + line for every finding.
3. Classify severity (Critical/High/Medium/Low) using exploitability + impact.
4. Propose the smallest safe patch — never a broad rewrite.
5. Present the patch for human review; never auto-apply.

## Safety Notes

- Never auto-apply any patch — present patches for human review only.
- Do not fabricate CVE IDs or CWE numbers; only cite what you can verify.
