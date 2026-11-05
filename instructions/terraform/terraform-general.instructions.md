# Terraform General Instructions

> Adapted from `awesome-copilot/instructions/terraform.instructions.md` and `agents/terraform.agent.md`. Converted to generic Markdown; MCP server / Copilot tool-call syntax removed.

## When To Use

Any Terraform/OpenTofu module authoring, review, or plan analysis, cloud-agnostic.

## Conventions

- One logical resource group per module; keep modules composable and single-purpose.
- Pin provider versions (`required_providers` with `~>` constraints) and Terraform core version (`required_version`).
- Always use remote state (S3+DynamoDB, azurerm storage backend, GCS, or HCP Terraform) — never local state for anything shared.
- Never commit `.tfstate`, `.tfvars` with secrets, or `.terraform/` directories.
- Use `for_each` over `count` when resource identity matters (avoids destroy/recreate churn on list reordering).
- Document every module with a `README.md` covering inputs, outputs, and examples; keep `variables.tf` descriptions non-empty.

## Review Discipline

1. `terraform fmt -check -recursive`
2. `terraform validate`
3. `tflint` (provider-specific rulesets)
4. `tfsec .` or `checkov -d .` (or both)
5. `terraform plan -out=tfplan` — review the plan diff before any apply
6. Never auto-apply. Always require explicit human approval, even in automation, unless the pipeline has an explicit, reviewed auto-apply policy for a specific low-risk environment.

## Security

- No secrets in variable defaults, module outputs, or state without `sensitive = true` (and remember `sensitive` does not encrypt state — treat state itself as sensitive).
- Encrypt state at rest (S3 SSE-KMS, Azure Storage encryption, GCS default encryption) and restrict access via IAM/RBAC.
- Use OPA/Sentinel/Conftest policy-as-code gates in CI for guardrails beyond linting (e.g., "no public S3 buckets", "no unencrypted RDS").

## Drift & State Safety

- Treat `terraform plan` drift as a signal to investigate, not silently reconcile.
- `terraform state mv/rm/import` are surgical operations — require explicit user intent and a plan showing the expected outcome before running.
- Only ever read `.tfstate` files directly; never hand-edit them.

## Testing

- Prefer Terratest (Go) or `terraform test` (native, ≥1.6) for module validation.
- CI-safe patterns favor `terraform validate`/`plan` over live `apply` unless integration credentials are explicitly provided and scoped to a sandbox account.

## Safety Notes

- Never rely on secrets or cloud credentials for tests unless explicitly requested for integration testing, and then only against a sandbox/non-production account.
