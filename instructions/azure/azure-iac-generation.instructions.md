# Azure IaC Generation Instructions (Bicep / ARM / Terraform / Pulumi)

> Adapted from `awesome-copilot/agents/azure-iac-generator.agent.md` and `instructions/bicep-code-best-practices.instructions.md`. Converted to generic Markdown; Copilot MCP tool-call bindings (`azure-mcp/bicepschema`, `azure-mcp/azureterraformbestpractices`, `pulumi-mcp/get-type`) replaced with a documentation-lookup requirement so the guidance works whether or not those specific MCP servers are wired up.

## When To Use

Generating new Azure infrastructure code from a requirement, in Bicep, ARM, Terraform, or Pulumi. For **reviewing existing** Terraform, use `instructions/azure/azure-terraform.instructions.md` and `skills/terraform/terraform-review/SKILL.md` instead — this file is for first-draft generation.

## Requirements Gathering (Do This First)

Before writing any code, confirm:
- Target platform — **default to Azure** unless AWS/GCP/multi-cloud is explicitly requested.
- Preferred IaC format (ask if not specified; don't assume Bicep vs Terraform).
- Environment (dev/staging/prod) and any compliance constraints.
- Resource naming — must follow `instructions/azure/azure-naming.instructions.md` (CAF conventions) regardless of chosen format.

## Format-Specific Validation-Before-Generation Rule

**Never generate IaC from memory of "roughly how the schema looks."** For each format, validate against a current, authoritative source before writing code:

| Format | Validate Against |
|---|---|
| Bicep | Current resource schema (via an MCP schema tool if available, or the [ARM template reference docs](https://learn.microsoft.com/azure/templates/)) — confirm required/optional properties and current API version before generating. |
| ARM (JSON) | Same schema source as Bicep. |
| Terraform | Current `azurerm`/`azapi` provider docs (Terraform Registry) — confirm resource/attribute names haven't changed since training data. |
| Pulumi | Current SDK type definitions for the target language — confirm property names/types before generating. |

If no live schema-lookup tool is available, say so explicitly and flag the generated code as "unverified against current schema — validate with `bicep build`/`terraform plan`/`pulumi preview` before applying."

## Quality Standards

- Azure-first: default to Azure-native services unless another cloud is explicitly requested.
- Security by default: least-privilege access, encryption enabled, network isolation considered, no hardcoded secrets (parameter references / Key Vault only).
- Modularity: reusable modules/components, not monolithic single-file templates for complex infrastructure.
- Parameterization: environment-specific values via parameter files, not hardcoded.
- Prefer Azure Verified Modules (AVM) for Bicep/Terraform where one exists and fits (see `instructions/azure/azure-terraform.instructions.md`).
- Include a `README.md` with deployment instructions, parameter descriptions, and security notes for anything non-trivial.

## Suggested Project Layout

```
infrastructure/
├── modules/           # Reusable components
├── environments/      # Environment-specific configs/parameter files
├── policies/          # Governance and compliance (Azure Policy / OPA)
├── scripts/           # Deployment helpers
└── docs/              # Architecture notes, README
```

## Constraints

- No deprecated resource API versions — use current ones.
- No hardcoded environment-specific values.
- Include resource dependencies explicitly and correctly (don't rely on implicit ordering where the tool doesn't guarantee it).
- Don't skip documentation for anything beyond a trivial single-resource template.

## Validation Commands

```bash
# Bicep
az bicep build --file main.bicep
az deployment group what-if --resource-group <rg> --template-file main.bicep

# Terraform
terraform fmt -check -recursive && terraform validate && terraform plan

# Pulumi
pulumi preview
```

## Safety Notes

- Never generate code that hardcodes secrets — always use secure parameter references, Key Vault, or environment-injected values.
- Never apply/deploy generated IaC automatically — generation is a drafting step; deployment requires the same review/approval discipline as any other IaC change (see `instructions/terraform/terraform-review.instructions.md` for the general pattern).
- Flag any generated resource whose schema you could not verify against a current source.
