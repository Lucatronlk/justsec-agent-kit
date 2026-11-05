---
name: gitlab-pipeline-review
description: Reviews .gitlab-ci.yml for security, efficiency, and migration readiness when a GitLab pipeline changes.
---

# gitlab-pipeline-review

## Purpose
Review a `.gitlab-ci.yml` pipeline for security, efficiency, and migration-readiness (e.g., ahead of a GitHub↔GitLab migration).

## When To Use
- New or changed `.gitlab-ci.yml`.
- Preparing to migrate a pipeline to/from GitHub Actions.
- Periodic CI/CD security audit for GitLab-hosted repos.

## Inputs Expected
- `.gitlab-ci.yml` and any `include:`d templates.

## Step-By-Step Process
1. Check structure: explicit `stages:`, `rules:` used instead of deprecated `only`/`except`.
2. Check token/secret scope: `CI_JOB_TOKEN` cross-project access disabled unless explicitly needed and allow-listed; CI/CD variables marked `Protected` + `Masked`.
3. Check image/dependency pinning: `image:` tags pinned to specific versions/digests.
4. Check branch/environment protection: protected branches, required MR approvals, environment protection rules for deploy jobs.
5. Check security gates: GitLab SAST/Dependency Scanning/Secret Detection/Container Scanning templates included.
6. If this is a migration-prep review, map each job/stage to its GitHub Actions equivalent using the mapping table in `instructions/cicd/gitlab-ci.instructions.md`, and flag anything that won't auto-migrate (branch protection, environment approvals, webhooks).

## Validation Checklist
- [ ] `rules:` used, no deprecated `only`/`except`
- [ ] Secrets are `Protected`+`Masked` CI/CD variables, not hardcoded
- [ ] `CI_JOB_TOKEN` scope reviewed
- [ ] Images pinned
- [ ] Branch/environment protections confirmed in project settings (not just pipeline file)
- [ ] Built-in security scanning templates included or explicitly deferred with owner sign-off

## Output Format
- Summary
- Findings by severity
- Evidence (file:line)
- Fix
- Migration notes (if applicable): job-by-job GitHub Actions mapping, non-migrating settings flagged
- Residual risk

## Safety Notes
- Review only — do not trigger pipeline runs or modify project CI/CD variable settings as part of this skill.
- Never recommend broadening `CI_JOB_TOKEN` scope without explicit justification.

Related instructions: `instructions/cicd/gitlab-ci.instructions.md`, `instructions/cicd/github-actions.instructions.md`
