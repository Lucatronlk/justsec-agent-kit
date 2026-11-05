---
name: azure-pipelines-review
description: Reviews Azure DevOps pipeline YAML and deployment controls when azure-pipelines.yml or pipeline management is requested.
---

# azure-pipelines-review

## Purpose
Review an Azure DevOps Pipeline (`azure-pipelines.yml`) for security, structure, and best-practice compliance, and provide `az devops`/`az pipelines` CLI guidance where relevant.

## When To Use
- New or changed `azure-pipelines.yml` / `*.pipeline.yml`.
- Periodic Azure DevOps pipeline security audit.
- Questions about managing Azure DevOps via `az devops`/`az pipelines` CLI.

## Inputs Expected
- `azure-pipelines.yml` (or pipeline template) source, and optionally the target Azure DevOps org/project.

## Step-By-Step Process
1. Check structure: `stages:`/`jobs:`/`steps:` used appropriately for the pipeline's complexity; explicit `dependsOn` between dependent stages/jobs.
2. Check secrets handling: variable groups + Key Vault used for sensitive values; no hardcoded secrets in YAML; sensitive variables marked secret.
3. Check service connections: least-privilege scope; managed identity preferred over service principal where possible.
4. Check triggers: `paths:` filters present to avoid unnecessary builds; branch triggers scoped appropriately.
5. Check deployment safety: `environment:` targeting with approval gates for production; rollback/health-check steps present.
6. Check build hygiene: pinned agent pool/VM image, dependency caching, test result publishing, code-coverage gates.
7. Check for anti-patterns: mixed build/deploy logic in one stage, deprecated task versions, monolithic single-file pipelines.
8. If the request involves CLI management (not just YAML review), reference the `az devops`/`az pipelines` command reference in `instructions/azure/azure-devops-pipelines.instructions.md`.

## Validation Checklist
- [ ] No hardcoded secrets; variable groups/Key Vault used
- [ ] Service connections least-privilege
- [ ] `paths:`/branch triggers scoped appropriately
- [ ] Production deployment stages gated by environment approvals
- [ ] Agent pool/VM image pinned
- [ ] Test results published, coverage gate present
- [ ] No deprecated task versions without an upgrade plan

## Output Format
- Summary
- Findings by severity
- Evidence (file:line)
- Fix
- Validation
- Rollback
- Residual risk

## Safety Notes
- Review only — does not trigger pipeline runs or modify Azure DevOps project settings, service connections, or variable groups.
- Never print PAT tokens, service connection secrets, or variable-group values in output.

Related instructions: `instructions/azure/azure-devops-pipelines.instructions.md`
