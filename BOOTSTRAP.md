# Bootstrap Workflow

## Initial Setup

1. Create `~/Git/justsec-agent-kit/`.
2. Review `STANDARDS.md`, `SEVERITY.md`, `MODEL_ROUTING.md`, and `REPO_CLASSIFICATION.md`.
3. Add missing repo-local `AGENTS.md` files from `templates/`.
4. Optionally link shared OpenCode templates into selected repos.
5. Validate with the scripts in `scripts/`.

## Onboard A New Repo

1. Detect repo type from markers in `REPO_CLASSIFICATION.md`.
2. Create `AGENTS.md` only if missing.
3. Select the closest template and then add mixed-repo notes if needed.
4. Add `.opencode` only when the repo benefits from repeated review workflows.
5. Do not overwrite repo-specific agent logic.

## Extend Skills

1. Add a new directory under `skills/<skill-name>/`.
2. Define when to use it, workflow steps, validations, and the standard output format.
3. Keep it read-only unless the skill explicitly supports patch drafting.

## Validate Setup

- Confirm the repo has the expected `AGENTS.md`.
- Run the relevant review script for the repo type.
- Check that sensitive files were not copied or modified.
- Review generated docs before wider rollout.

## Suggested Local Scan Flow

1. Run `scripts/repo_security_scan.sh <repo>` for a broad local pass.
2. Run focused scripts such as `scripts/iac_deep_review.sh <repo>` or `scripts/secrets_review.sh <repo>` for higher-signal follow-up.
3. Use `scripts/dependency_review.sh <repo>` for lightweight Node dependency audit.
4. Keep OWASP Dependency-Check and CI artifact publication in centralized CI unless you also replicate the NVD cache flow locally.

## Global OpenCode Sync

To make every skill/agent in `justsec-agent-kit` globally discoverable (not just per-project), run the sync script for your OS after adding relevant `instructions/**` paths to `~/.config/opencode/opencode.json`:

- Windows: `powershell -File scripts/sync-global-opencode.ps1` (junctions for skills, copies for agents -- re-run after editing an agent)
- macOS/Linux: `bash scripts/sync-global-opencode.sh` (symlinks for both skills and agents -- agent edits apply immediately, re-run only when adding/removing files)
