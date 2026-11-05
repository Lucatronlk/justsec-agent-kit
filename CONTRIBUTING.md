# Contributing

## Ground rules

- Keep changes minimal and additive. Do not refactor unrelated files in the same change.
- Never commit a secret, `.env` file, private key, or kubeconfig.
- Do not weaken a validation gate to make it pass. If a gate must change, say why.

## Adding a skill

1. Create `skills/<area>/<skill-name>/SKILL.md`. The folder name and the frontmatter `name:` must be the identical lowercase kebab-case string.
2. Frontmatter requires `name`, `description`, and `license`. Attribution goes in `metadata` (`author`, `version`, `source`).
3. Body requires: purpose, when to use, when not to use, workflow steps, validation commands, output format, and safety notes.
4. Add one row to the Full Matrix in `agents/skill-agent-index.md`, naming every agent that may load it.
5. Run `python3 scripts/sync-agent-skill-permissions.py --write` to regenerate the `permission.skill` allow-lists, then `--check` to confirm.
6. If the skill bundles a script, make it non-destructive by default and give it a `--dry-run` where it would change state.

## Changing an agent

Edit the persona body only. Never hand-edit `permission.skill`; the index is the source of truth and the sync script owns that block.

## Third-party material

If you adapt something, state the upstream repository, the path, and the licence in a header line, and add it to `THIRD_PARTY_NOTICES.md`. MIT and CC0 only. Do not paste material whose terms you have not checked.

## Validation

Run from the repository root and fix everything before opening a pull request:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 scripts/validate-agents.py
python3 scripts/sync-agent-skill-permissions.py --check
```

CI runs the same two gates. Both must be green.

## Output contract

Skills return: Summary, Findings by severity, Evidence, Fix, Validation, Rollback, Residual risk.
