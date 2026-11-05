---
name: adversarial-review
description: Adversarial review of a diff, PR, or change set for security-sensitive work. Assume the change is wrong until a reproduction breaks it; attacks assumptions, failure paths, trust boundaries and misleading tests. Every finding carries a concrete reproduction. Use alongside — not instead of — an ordinary code review, when a change touches credentials, parsers, network, CI, permissions, or anything a threat model ranks high.
---

# adversarial-review

## Purpose
Assume the change under review is **wrong until a reproduction breaks it**. The author's tests passing, and an ordinary reviewer's approval, are evidence about the *happy path* only. This skill produces adversarially-probed findings, each with a command and output that proves it — not opinions about code style.

It **complements** the normal review; it does not replace it, and it does not run the full gate unless asked.

## When To Use
- A diff/PR touches credentials, secrets, parsers, network calls, CI/CD, permissions, auth, or untrusted input.
- A change is security-sensitive enough that a same-tier happy-path review is a gate, not a verdict.
- A claimed fix must be shown to actually close the class of bug (see `verification-before-completion`).
- As the stand-in when an independent adversarial pass (another model/runtime) is out of budget.

**Not for:** line-level style review, general code review, or a complete security audit claim.

## Inputs Expected
- Base and head commits (or a PR), and the task text/spec.
- A **current** base — merge or compare against the current base branch first; a stale base produces false findings. State the base sha attacked against.
- A scratch directory for reproductions (the session scratch dir, else `mktemp -d`).
- Any loaded domain skills (attack specifics live in the domain skills, not here).

## Step-By-Step Process
1. Establish base/head, the task, and the scratch dir. If you lack base, head, or task, return `VERDICT: NOT ATTACKED` naming what you need and do nothing else.
2. **Before installing anything:** diff the dependency manifests / lockfiles / build hooks / install scripts between base and head. Installing from the head runs the code under attack; a changed dependency source is *itself* a finding to reproduce, not something to install.
3. For each suspicious area, **write and run a reproduction** (a script, two loopback servers, a hostile input file, a mutated manifest). A finding without a reproduction is marked `SPECULATIVE` and ranked below every reproduced one.
4. Walk the nine attack classes below; enumerate the whole API/behaviour surface rather than the single form the fix touched.
5. Name the **strongest** failure case first — the one most likely to hurt, not the easiest to list. Separate *blocking* from *preference*.
6. For each objection, state **what evidence would change your conclusion** (a command to run, a test that would go red) and, when non-trivial, the **cost of acting on it**.
7. Restore any file you mutated and prove the tree is clean (see `verification-before-completion`).

### The nine attack classes (domain-neutral)
1. **Fail-open paths.** Exception, missing file, timeout, unset variable, empty list, empty matrix, parse error. A security claim must fail **closed**; a claim of success ("signed in", "scanned", "verified") needs proof from the protected action itself, not the step before it.
2. **Tests that filter on the already-correct form.** A guard test that only iterates inputs already matching the strict pattern passes when the bad form is present. Check loose collection, strict assertion, `assertTrue(collected)`, a negative case. Delete the guarded behaviour; see if anything goes red.
3. **Two readers of one input.** One component validates, another consumes with a different parser/grammar/default. Craft inputs they read differently. Test against the consumer's real reader, not your model of it.
4. **Trust carried across a boundary.** Credentials, cookies, approvals, or verified bytes that cross a host, scheme, job, process, or branch boundary without re-checking. Follow each secret and verified artifact from where it is produced to where it is used.
5. **Replay after an ambiguous outcome.** A timeout, 5xx, dropped connection, or partial response is **UNKNOWN, not failed**. Is anything non-idempotent sent twice?
6. **Weakened or masked controls.** Opt-outs, skips, ignores, narrower pins/scopes/gates added to make CI green. Any of these is blocking regardless of the reason (see `instructions/ai-agents/never-weaken.instructions.md`).
7. **Secrets in outputs.** Credentials echoed into reports, logs, artifacts, or error messages; redaction applied after the data is already written elsewhere.
8. **API surface gaps.** The fix closes one call form and misses its sibling (2-arg vs 3-arg, an alias, a second entry point). Enumerate the surface before accepting a fix.
9. **Fix-introduced defects.** The fix for round N is the likeliest place for the round N+1 bug. Attack the fix, not only the original code.

## Validation Checklist
- [ ] Base is current; the base sha attacked against is stated
- [ ] Dependency manifests/hooks diffed before installing; no install from head
- [ ] Every finding has a reproduction, or is marked `SPECULATIVE`
- [ ] The strongest failure case is listed first
- [ ] Blocking vs preference is separated; preferences are never blockers
- [ ] Each finding names the evidence that would withdraw it
- [ ] The whole surface was enumerated, not just the form the fix touched
- [ ] Any mutated file was restored and the tree proven clean

## Output Format
The agent's standard report header, then:

```
VERDICT: APPROVE | FINDINGS | NOT ATTACKED
1. [blocking|important|minor] path:line - title
   Impact: who can do what.
   Reproduction: exact commands/inputs and the output that proves it.
   Status: REPRODUCED | SPECULATIVE
   Blocking: yes | no (preference)
   Would change my mind: the evidence that would withdraw this finding.
   Cost of acting on it: only when non-trivial.
2. ...
NOT ATTACKED: areas not covered, and why
COVERAGE: what was attacked (so APPROVE is meaningful)
```

Severity: **blocking** = wrong behaviour, a security hole, a masked/weakened check, or a failing gate. **Important** = a real defect that does not block merge alone. **Minor** = style or small clarity.

## Safety Notes
- Read-only: run reproductions, change nothing that outlives them — no commits, no push, no branch checkout in a main checkout, no subagents. Edits only inside the scratch copy.
- Do not read `.env` files or print secrets; if a command would print one, do not run it.
- Your own approval covers only what you attacked — state the coverage.
- Prompts guide behaviour; they are not access control (see `instructions/ai-agents/agent-safety.instructions.md`).

Related instructions: `instructions/ai-agents/never-weaken.instructions.md`, `instructions/security/owasp-security.instructions.md`, `instructions/security/threat-modeling.instructions.md`
Related skills: `skills/quality/verification-before-completion/SKILL.md`, `skills/quality/systematic-debugging/SKILL.md`

Attribution: adapted from `ChiefGyk3D/department-of-internal-arguments` role `adversarial-reviewer` (MIT, © 2026 ChiefGyk3D).
