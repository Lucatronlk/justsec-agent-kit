# GitLab CI Instructions

> **Authored by us** — no GitLab CI content exists in either `awesome-copilot` or `awesome-opencode` (both confirmed GitHub-first with zero GitLab-specific assets). Structurally modeled on the GitHub Actions equivalent (`cicd/github-actions.instructions.md`, itself adapted from `awesome-copilot/instructions/github-actions-ci-cd-best-practices.instructions.md`) and translated to GitLab CI syntax/concepts.

## When To Use

Authoring or reviewing `.gitlab-ci.yml`, CI/CD variables, or GitLab migration pipelines.

## Structure

- Use `stages:` to define an explicit pipeline order (e.g., `validate`, `build`, `test`, `scan`, `deploy`).
- Use `include:` with project/remote/template includes to share pipeline logic across repos (GitLab's equivalent of reusable workflows) — centralize in a shared `ci-templates` project rather than copy-pasting YAML.
- Use `rules:` (not the deprecated `only`/`except`) for job conditions — clearer and more composable.

## Security Hardening

- Scope `CI_JOB_TOKEN` and project access tokens to least privilege; disable `CI_JOB_TOKEN` project-to-project access by default and allow-list specific projects that need it.
- Store secrets in **CI/CD Variables** marked `Protected` + `Masked`; never in `.gitlab-ci.yml` or committed `.env` files.
- Prefer OIDC-based cloud authentication (GitLab supports OIDC for AWS/Azure/GCP) over long-lived static credentials stored as CI variables.
- Pin `image:` tags to specific versions/digests, not `latest`.
- Use protected branches + protected tags + required approvals (merge request approval rules) before merge to `main`/release branches.
- Enable GitLab's built-in SAST/Dependency Scanning/Secret Detection/Container Scanning templates (`Security/SAST.gitlab-ci.yml`, etc.) rather than reimplementing from scratch.

## Migration-Relevant Notes (GitHub → GitLab or vice versa)

- Map GitHub Actions concepts to GitLab CI: `workflow` → `pipeline`, `job.steps` → `job.script`, `secrets.X` → CI/CD variable, `on: pull_request` → `rules: - if: $CI_PIPELINE_SOURCE == "merge_request_event"`, reusable workflow → `include:`.
- Branch protection rules, required reviewers, and environment protection rules do **not** migrate automatically — must be recreated manually or via API/Terraform (`gitlab` provider) in the target system.
- Artifact/package registries (npm, Maven, generic packages, container registry) require explicit migration — Artifactory/Nexus can act as an intermediary mirror during a phased cutover (see `migrations/migration-pipelines.instructions.md`).

## Validation Commands

```bash
gitlab-ci-local            # if available, run pipeline stages locally
yamllint .gitlab-ci.yml
```

## Output Format

- Summary
- Findings by severity
- Evidence
- Fix
- Validation
- Rollback
- Residual risk

## Safety Notes

- Never disable `Protected`/`Masked` flags on a CI variable to "debug" a pipeline — use a scoped test variable instead.
- Never grant a job `CI_JOB_TOKEN` cross-project access broadly; scope to the exact target projects needed.
