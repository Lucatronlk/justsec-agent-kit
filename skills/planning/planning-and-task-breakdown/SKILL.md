---
name: planning-and-task-breakdown
description: Breaks work into ordered, verifiable tasks. Use when you have a spec or clear requirements and need implementable units, when a task feels too large to start, when you need to estimate scope, or when parallel work is possible.
---

# planning-and-task-breakdown

## Purpose
Decompose work into small, verifiable tasks with explicit acceptance criteria. Good breakdown is the difference between reliable completion and a tangled, unverifiable result. Every task should be small enough to implement, verify, and checkpoint in a single focused session.

## When To Use
- A spec or requirements exist and need to become implementable units.
- A task feels too large, vague, or risky to start.
- Work will be parallelized across agents, sessions, or people.
- Scope needs to be communicated to a human, or implementation order isn't obvious.

**When NOT to use:** single-file changes with obvious scope, or when the spec already contains well-defined tasks.

## Inputs Expected
- The spec / requirements, or a clear statement of the goal.
- Access to the relevant codebase sections and existing conventions.
- The project's agent rules (`AGENTS.md`, and any repo-level instructions).

## Step-By-Step Process
1. **Plan in read-only mode.** Read the spec and relevant code; identify existing patterns; map dependencies; note risks and unknowns. Produce a plan — not implementation.
2. **Map the dependency graph.** What depends on what (schema → models → endpoints → clients → UI)? Implementation order follows the graph bottom-up: foundations first.
3. **Slice vertically.** Prefer complete feature paths over horizontal layers. Build "user can register (schema + API + UI)" before "all API endpoints".
4. **Write tasks** using the template below — each with acceptance criteria and a verification step.
5. **Order and checkpoint.** Satisfy dependencies first; keep the system working after each task; place verification checkpoints after every 2–3 tasks; put high-risk tasks early (fail fast).

Task template:

```markdown
## Task [N]: [Short descriptive title]

**Description:** One paragraph on what this accomplishes.

**Acceptance criteria:**
- [ ] [Specific, testable condition]

**Verification:**
- [ ] Tests pass: [the repository's focused-test command]
- [ ] Build succeeds: [the repository's build command]
- [ ] Manual check: [what to verify]

**Dependencies:** [Task numbers this depends on, or "None"]

**Files likely touched:**
- `path/to/file`

**Estimated scope:** [Small: 1-2 files | Medium: 3-5 files | Large: 5+ files]
```

## Task Sizing
| Size | Files | Scope |
|------|-------|-------|
| XS | 1 | Single function or config change |
| S | 1-2 | One component or endpoint |
| M | 3-5 | One feature slice |
| L | 5-8 | Multi-component feature |
| XL | 8+ | **Too large — break it down further** |

Break a task down further if it needs more than one focused session, if acceptance criteria can't be stated in 3 bullets or fewer, if it touches two independent subsystems, or if the title contains "and".

## Output Files
- **Plan document:** markdown, capturing design decisions, risks, and open questions.
- **Task list:** the per-task checklist (default a local markdown checklist) or, when the project designates an external tracker, one tracker item per task.

**Never overwrite an incomplete plan.** Before writing, check whether a plan for *different* work already exists with unchecked tasks — if so, stop and ask rather than overwrite it, since it may be mid-build in another session.

## Validation Checklist
- [ ] Every task has acceptance criteria
- [ ] Every task has a verification step
- [ ] Dependencies are identified and ordered correctly
- [ ] No task touches more than ~5 files
- [ ] Checkpoints exist between major phases
- [ ] No pre-existing incomplete plan was overwritten without confirmation
- [ ] The human has reviewed the plan before implementation starts

## Output Format
- Summary: scope, task count, and phase structure.
- Findings by severity: risks and unknowns (per `SEVERITY.md`).
- Evidence: the spec/requirements and codebase conventions the plan is grounded in.
- Fix: the plan document + ordered task list.
- Validation: how plan completeness is checked (criteria + checkpoints).
- Rollback: how to abandon/revise the plan safely without destroying work state.
- Residual risk: open questions and assumptions needing confirmation.

## Red Flags
- Starting implementation without a written task list
- Overwriting a plan that still has unchecked tasks without asking
- Tasks with no acceptance criteria ("implement the feature")
- No verification steps, no checkpoints
- All tasks XL-sized; dependency order ignored

## Safety Notes
- Planning is read-only with respect to application code; the only writes are the plan/task artifacts.
- Never claim a plan is complete or approved without explicitly confirming with the human.

Related instructions: `instructions/ai-agents/context-engineering.instructions.md`

Attribution: adapted from `addyosmani/agent-skills` skill `planning-and-task-breakdown` (MIT, © 2025 Addy Osmani).
