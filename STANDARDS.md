# DevSecOps Standards

## Naming Conventions

- Use clear, stable names tied to workload, environment, and owner.
- Prefer lowercase kebab-case for files, directories, labels, and tags unless the tool requires another format.
- Keep environment names explicit: `dev`, `test`, `stage`, `prod`.
- Name IAM roles and service accounts by workload and privilege scope.

## Tagging Standards

Apply provider-native tags or labels where supported.

- `owner`
- `service`
- `environment`
- `data-classification`
- `cost-center`
- `managed-by`
- `incident-contact`

## Security Baseline

- Default deny where supported.
- Encrypt network traffic and storage.
- Pin versions for providers, actions, images, and dependencies.
- Prefer immutable references and signed artifacts.
- Enforce branch protection and CI checks on protected branches.
- Run secret scanning and dependency scanning in CI where feasible.

## Logging And Monitoring

- Emit access, error, and security-relevant events.
- Route logs to a central sink with retention and access controls.
- Monitor authentication failures, privilege changes, network exposure changes, and deployment changes.
- Define health checks and service-level alerts for production workloads.

## Secret Handling

- Never commit secrets.
- Prefer secret managers and workload identity.
- Do not print sensitive values in logs or CI output.
- Mask secret-like values in review output.
- Treat `.env`, `*.pem`, kubeconfigs, and cloud credential files as sensitive.

## IAM Expectations

- Use least privilege.
- Scope permissions to resource, action, and environment.
- Prefer short-lived credentials and federation.
- Review trust relationships for cross-account or cross-cluster access.

## Patch Philosophy

- Choose the smallest safe change.
- Avoid unrelated refactors during security or production work.
- Prefer additive controls before structural rewrites.

## Rollback Requirements

- Every meaningful change should identify rollback steps.
- Rollback should be as small and deterministic as the forward change.
- Capture data migration and state impact before rollout.

## PR Expectations

- Describe why the change is needed.
- State blast radius and affected environments.
- Include validation evidence.
- Note rollback steps and residual risk.
- Call out security-sensitive or availability-sensitive changes explicitly.

## Terraform Standards

- Pin provider/module versions; remote state with locking; never local state for shared infra.
- `fmt`/`validate`/`tflint`/`tfsec`(or `checkov`) clean before merge; plan reviewed before any apply.
- No secrets in variables/outputs; `sensitive = true` is not a substitute for encrypting/restricting state access.
- See `instructions/terraform/`.

## Azure Standards

- CAF naming and tagging (`instructions/azure/azure-naming.instructions.md`).
- Managed identity over service principal secrets; Key Vault for all secrets, soft-delete + purge protection on.
- Diagnostic settings on every production resource; Azure Policy at management-group scope.
- Prefer Azure Verified Modules for Bicep/Terraform where they fit.

## AWS Standards

- Least-privilege IAM (no bare `*` actions without justification); GuardDuty/Config/CloudTrail enabled org-wide.
- No public S3 buckets/security groups without explicit, documented justification.
- IAM Identity Center (SSO) for human access, not long-lived IAM user keys.
- See `instructions/aws/`.

## Python Standards

- `venv`/`uv`/`poetry` for environment isolation; pinned dependencies; prefer stdlib when sufficient.
- `ruff` + `mypy`/`pyright` + `pytest` as the default quality bar.
- No `shell=True` with unsanitized input, no bare `except:`, explicit timeouts on network calls.
- See `instructions/python/`.

## Docker Standards

- Multi-stage builds; non-root `USER`; pinned/minimal base images; no secrets baked into layers.
- `hadolint` + `trivy image` clean (or Critical/High triaged) before production use.
- See `instructions/docker/docker-best-practices.instructions.md`.

## Kubernetes Standards

- `runAsNonRoot`, drop all capabilities, `readOnlyRootFilesystem` by default; no `privileged: true` without exception.
- Resource requests/limits and liveness/readiness probes on every container; PDB + anti-affinity for production.
- RBAC least-privilege; NetworkPolicy default-deny.
- See `instructions/kubernetes/kubernetes-best-practices.instructions.md`.

## GitLab CI Standards

- `rules:` not deprecated `only`/`except`; `CI_JOB_TOKEN` scoped, secrets `Protected`+`Masked`.
- Built-in SAST/Dependency/Secret/Container scanning templates included.
- See `instructions/cicd/gitlab-ci.instructions.md`.

## GitHub Actions Standards

- `permissions:` least-privilege by default; third-party actions pinned to SHA, not tag.
- Never interpolate untrusted `${{ }}` directly into a shell `run:` step — pass via `env:`.
- Elevated-trust triggers (`pull_request_target`, `workflow_run`) reviewed for checkout-and-execute risk.
- See `instructions/cicd/github-actions.instructions.md`.

## Migration Standards

- Full inventory + dependency mapping before starting; checksum/metadata parity verified before declaring any step complete.
- Rotate credentials as part of migration, never carry over; keep source read-only (not deleted) through a bake period.
- See `instructions/migrations/migration-pipelines.instructions.md`.

## Documentation Standards

- Every module/service/skill documents purpose, inputs/outputs, and validation commands.
- Instructions/skills/agents state explicitly **when to use** and **safety notes** — avoid silent auto-triggering behavior.
- Cross-reference related files by explicit path so both humans and agents can navigate without guessing.
- Classify any documentation deliverable by Diátaxis type (tutorial/how-to/reference/explanation) and don't mix types in one document.
- Verify every code snippet/command/config value against the actual project before publishing — never fabricate.
- README should be concise: what it is, quick start, configuration, links to deeper docs — not an exhaustive inline reference; don't duplicate LICENSE/CONTRIBUTING/CHANGELOG content.
- See `instructions/documentation/technical-writing.instructions.md`, `skills/documentation/documentation-writer/SKILL.md`, `skills/documentation/readme-generator/SKILL.md`.
