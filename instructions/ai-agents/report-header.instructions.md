# Standard Report Header

> Adapted from `ChiefGyk3D/department-of-internal-arguments` (`fragments/report-header.md`, MIT, © 2026 ChiefGyk3D), mapped to this framework (`packs` → `skills`, `PACKS LOADED` → `SKILLS LOADED`). The frameworks' shared report contract.

## When To Use

Every agent report, in every domain, on every task. The header is the first thing in the output so a controller can log a task from the header alone and check the model and skills against what was dispatched.

## The Header

```
ROLE: <agent name>            MODEL: <exact model id | not verified - reason>
HEAD: <short sha | n/a - reason>  BASE: <short sha | n/a - reason>
GATE: <command> exit=<code> | not-run - <reason> | n-a - <reason>
OTHER GATES: <name>: pass | fail | not-run | n-a - <reason>   (one per line)
SKILLS LOADED: <names, or none>
TREE: clean (<evidence>) | NOT CLEAN (<what>) | n-a - <reason>
NOT VERIFIED: <what you did not run or could not check>        (one per line, or none)
```

## Field Rules

- **MODEL** names the exact model ID when exposed by the host — not a guessed family name or `inherit`. If unavailable, use `not verified - host did not expose model ID`; controller can fill it from dispatch records (see `MODEL_ROUTING.md`).
- **HEAD / BASE** are real Git SHAs only when there is a repository and the comparison base is known. Otherwise use `n/a - no Git repository` or `not verified - base unknown` for the affected field; do not invent a base equal to HEAD.
- **GATE** carries a real exit code from a run in this task. `not-run` always carries a reason; `n-a` always carries a reason.
- **SKILLS LOADED** lists the skills actually loaded. Naming a skill in a task is not proof it was loaded.
- **TREE** is `clean` only with evidence (empty `git status --porcelain`, or a diff against HEAD). For a read-only report with no repository, use `n-a - <reason>`.
- **NOT VERIFIED** is the list the controller now owns: run it, dispatch it, or record it as open.

## Body

After the header, use the agent's own output format — `Summary / Findings by severity / Evidence / Fix / Validation / Rollback / Residual risk`, or its domain equivalent (e.g. a migration plan, a knowledge-graph summary, a Diátaxis document).

## Safety Notes

- A missing field makes the report incomplete: the controller re-dispatches rather than filling it in from its own reading.
- Never fabricate an exit code, a model ID, HEAD/BASE, or a tree state. Disclose missing evidence with its reason.
- See also `instructions/ai-agents/never-weaken.instructions.md` (the `GATE` / `OTHER GATES` / `NOT VERIFIED` rules).
