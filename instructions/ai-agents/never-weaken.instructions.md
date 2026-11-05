# Never Weaken A Check

> Adapted from `ChiefGyk3D/department-of-internal-arguments` (`fragments/never-weaken.md` and `policies/quality-gates.md`, MIT, © 2026 ChiefGyk3D). The framework's "green gate" constitution — applies to every agent that runs, reports, or reviews a quality gate.

## When To Use

Always, for every agent that runs tests, linters, builds, scanners or review gates, and for every agent that reviews such work. Loaded via `opencode.json`; referenced by `agents/*-agent.md`.

## The Rule

**Never weaken a check to get green.** Do not add or use:

`continue-on-error`, `*-continue-on-error: true`, `require-non-root: false`, `nosemgrep`, `# noqa`, `# type: ignore`, `shellcheck disable`, `hadolint ignore`, `pytest.mark.skip`, `|| true` on a test or gate, `--no-verify`, a narrower pin, scan or lint scope, or a loosened/weakened test.

If the only route to green is such a change, **stop and report it as an escalation with the evidence**. A lint ignore is allowed only with a stated reason on the same or previous line, and only when the task explicitly permits it.

## Gate Reporting

- A plan or an opinion is not proof of execution. Run the repository's **full gate, exactly as CI runs it**, and capture the exit code:
  `<gate> > "$SCRATCH/gate.log" 2>&1; echo "gate exit=$?"`
  Never pipe a gate into `grep`/`tail` and chain on the result.
- Report every applicable gate (tests, lint, build, security scan, docs) with exactly one status: **pass**, **fail**, **not-run**, **n-a** — each with the command and a reason.
- A failure is never hidden as `n-a`; if a gate could not run, it is `not-run`.
- **If no gate is defined** (neither the task nor the repository documents one): report `GATE: not-run - none defined`, run the test and lint commands you can find, list them under OTHER GATES, and propose a gate command. Never invent a command and call it the full gate.
- Say what you did not run under **NOT VERIFIED**. Never write "plausible" for something you could have run.

## Proving A Fix Bites (reviewers)

For every claimed fix and every new test: revert the fix in a scratch copy, confirm the test goes **red**, restore, confirm **green**. A test that stays green on revert is a finding. Report the commands and the results; if it cannot be done, say `NOT VERIFIED` and why.

## Guard Tests

Guard/allowlist tests collect loosely, assert strictly (including that something was collected) and include a negative case proving the guard bites.

## Clean Tree

After any revert or mutation, restore the exact bytes and prove it (empty `git status --porcelain`, or a diff against HEAD). A mutated line left behind is a defect the reviewer introduced — report it.

## Output Format For Gate Reviews

- Summary
- Findings by severity
- Evidence (gate log, exit code, red→green proof)
- Fix
- Validation
- Residual risk

## Safety Notes

- Weakening a check is a blocking finding regardless of the reason given, and escalates to a human decision — not to the next agent in the chain.
- Never claim a gate passed without a fresh exit code produced in this turn.
- See also `instructions/ai-agents/report-header.instructions.md` (the `GATE` and `OTHER GATES` fields) and `skills/quality/verification-before-completion/SKILL.md`.
