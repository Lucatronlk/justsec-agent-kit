# Context Engineering Instructions

> Adapted from `awesome-opencode` (`docs/schema-design.md`, `data/examples/*.yaml` — the OpenCode config/skill/agent schema) and `awesome-copilot` (`skills/threat-model-analyst`'s progressive-disclosure reference-file architecture). Converted to generic Markdown.

## When To Use

Designing how instructions, skills, and agents load context for an AI coding agent (OpenCode, Copilot CLI, Claude Code, or similar).

## Config Precedence (OpenCode model — useful mental model regardless of tool)

```
remote org defaults (.well-known/opencode)
  → global config (~/.config/opencode/opencode.json)
    → OPENCODE_CONFIG env var override
      → project config (opencode.json in repo root)
        → project .opencode/ directory
          → inline session/env vars (highest precedence)
```

Design shared instructions so the **most specific, most local** context always wins — global standards should be overridable per-repo, not the reverse.

## Progressive Disclosure Pattern

For a complex skill (e.g., threat modeling, security review), don't put everything in one giant `SKILL.md`. Instead:

- `SKILL.md` — orchestrator: purpose, when to use, high-level steps, links to references.
- `references/*.md` — deep detail loaded only when needed (taxonomy, output-format skeletons, verification checklists).

This keeps the default context window small while still allowing depth on demand — mirrors how `awesome-copilot`'s largest skills (threat-model-analyst, security-review, github-actions-hardening) are structured.

## File Types & Where They Live (this repository's convention)

| Type | Location | Purpose |
|---|---|---|
| Instructions | `instructions/<domain>/*.instructions.md` | Always-relevant standards for a domain, auto-loadable |
| Skills | `skills/<domain>/<skill-name>/SKILL.md` | Invokable, step-by-step procedures with validation + output format |
| Agents | `agents/<domain>/<agent-name>.md` | Persona + role + allowed/forbidden actions + workflow, one per skill where applicable |
| Prompts | `prompts/*.md` | One-off or templated prompt snippets |
| Checklists | `checklists/*.md` | Pure checklists, no narrative |
| Templates | `templates/**` | Scaffolding to copy into a new repo/agent config |

## Writing Good Instructions

- State **when to use** explicitly — avoid instructions that silently trigger on everything.
- Prefer concrete commands/checklists over prose — they're directly actionable and easy to validate.
- Always end with a **Safety Notes** section for anything with real-world side effects.
- Cross-reference related files by explicit path (e.g., "see `skills/terraform/terraform-review/SKILL.md`") so an agent (or human) can navigate without guessing paths.

## Agent Config Portability

- Keep the **body/reasoning content** of an instruction/agent generic Markdown — this is what's portable across OpenCode, Copilot, Claude Code.
- Isolate tool-specific bindings (MCP server declarations, `tools:` frontmatter, plugin manifests) into a clearly separate config block or file, so the reasoning content survives a tool migration even if the binding syntax doesn't.

## Safety Notes

- Do not let a "helpful" global default silently override a repo's explicit local safety policy — local, more specific config should win, per the precedence model above.
