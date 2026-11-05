# Azure DevOps Pipelines Instructions

> Adapted from `awesome-copilot/instructions/azure-devops-pipelines.instructions.md` and `awesome-copilot/skills/azure-devops-cli/SKILL.md`. Converted to generic Markdown; `applyTo` frontmatter (`**/azure-pipelines.yml`, `**/*.pipeline.yml`) dropped in favor of explicit "When To Use" below.

## When To Use

Authoring or reviewing `azure-pipelines.yml` (or any `*.pipeline.yml`), or managing Azure DevOps via `az devops`/`az pipelines` CLI.

## Pipeline Structure

- Organize complex pipelines with `stages:` → `jobs:` → `steps:` for visualization and control; use explicit `dependsOn` between stages/jobs.
- Use templates (`extends:`, step templates, variable templates) for reusable components — keep pipeline files focused and modular.
- Meaningful `displayName` on every stage/job/step for readability in the Azure DevOps UI.

## Security

- Use Azure Key Vault + variable groups for secrets; never hardcode sensitive values in YAML.
- Service connections scoped to least privilege; prefer managed identities over service principals where possible.
- Mark sensitive variables as secret (`isSecret`) so they're masked in logs.
- Implement approval gates (environment checks) for production deployments.
- Enable security scans (dependency vulnerability, SAST) as pipeline stages, not optional afterthoughts.

## Build & Test

- Pin agent pool/VM image versions (`vmImage: 'ubuntu-22.04'`, not an unpinned `-latest` alias that can shift under you).
- Cache dependencies (npm/NuGet/Maven) for build performance.
- Publish test results in standard formats (JUnit/VSTest) and enforce code-coverage gates.
- Fail fast on test failures.

## Deployment

- Use `deployment` jobs with explicit `environment:` targeting (enables approval gates and deployment history).
- Prefer blue-green/canary strategies for high-risk production services; include rollback and health checks.
- Use IaC (Bicep/ARM/Terraform) for consistent, reviewable deployments — see `instructions/azure/azure-terraform.instructions.md`.

## Azure DevOps CLI Reference (`az devops`/`az pipelines`)

```bash
az extension add --name azure-devops
az devops login --organization https://dev.azure.com/{org} --token YOUR_PAT_TOKEN
az devops configure --defaults organization=https://dev.azure.com/{org} project={project}
```

Command groups: `az devops` (project/security/service-endpoint/team/wiki), `az pipelines` (build/agent/pool/queue/release/runs/variable-group), `az boards` (work-item/area/iteration), `az repos` (pr/policy/import/ref), `az artifacts` (universal packages).

- Always use `https://dev.azure.com/{org}` — the legacy `https://{org}.visualstudio.com` form should be migrated.
- Store PATs the same way as any other secret (see `instructions/security/secrets-handling.instructions.md`); never paste one into a shared script.

## Common Anti-Patterns To Avoid

- Hardcoding sensitive values directly in YAML.
- Overly broad triggers causing unnecessary builds (missing `paths:` filters).
- Mixing build and deployment logic in a single stage.
- Using deprecated task versions (`@1` when `@2`+ exists) without an upgrade plan.
- Monolithic, unmaintainable single-file pipelines instead of templates.

## Validation

- Lint locally where tooling exists; otherwise validate via a dry-run/PR-triggered pipeline run before merging to a protected branch.
- Confirm variable groups/service connections referenced actually exist and are scoped correctly before relying on a new pipeline in production.

## Safety Notes

- Never print secret/variable-group values in logs or task output.
- Treat PATs and service connection credentials as secrets — rotate, never reuse across environments.
- Require explicit approval gates before any production deployment stage runs.
