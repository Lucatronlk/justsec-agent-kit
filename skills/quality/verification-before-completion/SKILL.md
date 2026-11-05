---
name: verification-before-completion
description: Use before claiming any task is complete, fixed, or passing — requires running the verification command and reading its output before making a success claim. Evidence before assertions, always.
---

# verification-before-completion

## Purpose
Enforce one discipline: **no completion claim without fresh verification evidence**. A statement that work is done, fixed, or passing is valid only if the proving command was run and its output read in the same turn.

## When To Use
- About to claim work is complete, fixed, passing, or "done".
- Before committing, pushing, opening a PR, or moving to the next task.
- After delegating work to another agent, tool, or sub-task.
- Any time a success statement — or a synonym/paraphrase of one — is about to be made.

## Inputs Expected
- The claim being made ("tests pass", "build succeeds", "bug fixed", "requirements met").
- The exact command(s) that prove or disprove that claim.
- Ability to run those commands (read-only where possible) in the target repo.

## Step-By-Step Process
Apply this gate before any status statement:

1. **IDENTIFY** — what command proves this claim?
2. **RUN** — execute the full command, fresh and complete (not a cached or previous run).
3. **READ** — read the full output; check the exit code; count failures.
4. **VERIFY** — does the output actually confirm the claim?
   - No → state the actual status, with the evidence.
   - Yes → state the claim, together with the evidence.
5. **ONLY THEN** — make the claim.

Skipping any step is asserting, not verifying.

Claim → required evidence:

| Claim | Requires | Not sufficient |
|---|---|---|
| Tests pass | Test output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command exit 0 | Linter passing, logs "look fine" |
| Bug fixed | Original symptom test now passes | Code changed, assumed fixed |
| Regression test works | Red→green cycle verified | Test passes once |
| Requirements met | Line-by-line checklist against the spec | Tests passing alone |
| Delegated work done | VCS diff inspected | Agent reported "success" |

## Proving A Fix Bites — the revert check
When a **reviewer** (or you) is asked to accept a claimed fix or a new test, a green run is not enough: a test can pass without reaching the code it claims to cover.

For every claimed fix and every new test:
1. In a **scratch copy**, revert the fix (or delete the guarded behaviour).
2. Run the test — it must go **red**. If it stays green, the test is vacuous: report it as a finding.
3. Restore the fix exactly.
4. Run again — it must go **green**.

Report the commands and both results. If you cannot do the revert check, say `NOT VERIFIED` and why — never write "plausible".

## Clean Tree — restore and prove it
After any revert, mutation, or scratch experiment:
- Restore the **exact bytes**, and
- **Prove it**: empty `git status --porcelain`, or a diff against HEAD.

A mutated line left behind is a defect *you* introduced — report it if it happens. A reviewer that leaves the tree changed has failed the review regardless of its findings.

## Validation Checklist
- [ ] The exact verification command was run in this turn
- [ ] The full output was read, not truncated to the happy path
- [ ] Exit code / failure count was checked
- [ ] Claim wording matches what the evidence shows (no overreach)
- [ ] For delegated work, the VCS diff was inspected, not the agent's summary
- [ ] Claimed fixes were revert-checked (red → restore → green), or marked NOT VERIFIED
- [ ] The tree is clean, with proof (`git status --porcelain` empty, or a diff against HEAD)
- [ ] If verification was impossible, that is stated explicitly instead of assumed

## Output Format
- Summary: the claim, the command run, and the observed result.
- Findings by severity: any gap between claim and evidence (per `SEVERITY.md`).
- Evidence: exact command + the relevant output lines (redact secrets).
- Fix: the change needed to make the claim actually true.
- Validation: the command that proves the fix.
- Rollback: how to revert if the change is wrong.
- Residual risk: what remains unverified.

## Red Flags — stop and verify
- "should", "probably", "seems to", "looks correct".
- Satisfaction expressed before verification ("Great", "Perfect", "Done").
- About to commit / push / PR without running verification.
- Trusting another agent's success report.
- "Just this once", "I'm confident", "the linter passed".
- Partial verification treated as full verification.
- Accepting a claimed fix without a revert check ("the test passes").
- Leaving a mutated line behind after a revert check ("the tree is probably fine").

## Safety Notes
- Read-only: run verification commands; never alter application code merely to make a claim pass.
- Never fabricate command output, exit codes, or test counts — if a command was not run, say so.
- Redact secrets and sensitive values from evidence.
- Weakening a check to make a claim pass is a blocking finding — see `instructions/ai-agents/never-weaken.instructions.md`.

Related instructions: `instructions/ai-agents/agent-safety.instructions.md`, `instructions/ai-agents/never-weaken.instructions.md`, `instructions/ai-agents/report-header.instructions.md`

Attribution: adapted from `obra/superpowers` skill `verification-before-completion` (MIT, © 2025 Jesse Vincent).
