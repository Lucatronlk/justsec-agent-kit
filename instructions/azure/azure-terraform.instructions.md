# Azure + Terraform Instructions

> Adapted from `awesome-copilot` (`instructions/terraform-azure.instructions.md`, `instructions/generate-modern-terraform-code-for-azure.instructions.md`, `instructions/azure-verified-modules-terraform.instructions.md`, `skills/import-infrastructure-as-code`). Converted to generic Markdown, Copilot-specific `applyTo` frontmatter removed.

## When To Use

Any `.tf`/`.tf.json` work targeting Azure via `azurerm`/`azapi` providers.

## Core Rules

- Use `azurerm_client_config`/environment variables (`ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`) — never hardcode subscription or tenant IDs in provider blocks.
- Only read `*.tfstate` files; never hand-edit state. Use `terraform state mv/rm` deliberately and only with explicit approval.
- Prefer Azure Verified Modules (AVM) (`Azure/avm-res-*` on the Terraform Registry) over hand-rolled resources when an AVM module exists and fits.
- Decide `azurerm` vs `azapi`: use `azurerm` by default; use `azapi` only for preview features or properties not yet exposed by `azurerm`.
- Remote state backend (`azurerm` backend with storage account + container), never local state for shared infrastructure.
- Pin provider and module versions (`~>` with explicit minor bounds); avoid unpinned `latest`.

## Brownfield Import Workflow (adapted from `import-infrastructure-as-code`)

1. Discover live resources (Azure CLI / Resource Graph) and map dependencies before writing any code.
2. Read the target module's README before writing `import` blocks — do not guess resource addresses from memory.
3. If using a downloaded module, grep its source to confirm actual resource types (`azurerm_*` vs `azapi_*`) and whether it uses `count` or `for_each` (this changes the import address format).
4. Generate `import {}` blocks (Terraform ≥1.5) rather than `terraform import` CLI calls where possible, for reviewability.
5. Do not declare an import complete until `terraform plan` shows **0 destroys and 0 unwanted changes**.
6. Diff live resource properties against module defaults explicitly — call out every drift, not just the blocking ones.

## Security Checklist

- No secrets in variable defaults or outputs (`sensitive = true` where applicable, but do not rely on this alone — avoid exposing secrets in state either).
- Storage accounts: `min_tls_version = "TLS1_2"`, public network access disabled unless justified.
- Key Vault: purge protection + soft delete enabled, network ACLs default-deny.
- NSGs / firewall rules: no `0.0.0.0/0` on inbound management ports (22/3389).

## Validation Commands

```bash
terraform fmt -check -recursive
terraform validate
tflint
tfsec . || checkov -d .
terraform plan -out=tfplan
```

## Safety Notes

- Never run `terraform apply`/`terraform destroy` autonomously — always require explicit human confirmation.
- Treat ARM resource IDs as cloud identifiers only, never as local file paths (avoids a subtle path-injection class of mistake).
