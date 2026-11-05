# Azure Naming Instructions

> Adapted (condensed) from `awesome-copilot/instructions/azure-naming.instructions.md`, itself based on the Microsoft Cloud Adoption Framework (CAF) naming convention. Fully generic reference content — no Copilot dependency.

## When To Use

Naming any Azure resource, resource group, or tag set.

## Pattern

```
<resource-type-abbr>-<workload>-<environment>-<region>-<instance>
```

Example: `st{workload}{env}{region}001` for storage (no hyphens allowed), `rg-{workload}-{env}-{region}` for resource groups.

## Common Abbreviations

| Resource | Abbreviation | Notes |
|---|---|---|
| Resource Group | `rg` | Hyphens allowed |
| Storage Account | `st` | Lowercase, alphanumeric only, no hyphens, 3-24 chars |
| Key Vault | `kv` | Alphanumeric + hyphen, 3-24 chars, globally unique |
| App Service | `app` | |
| App Service Plan | `asp` | |
| Function App | `func` | |
| Container Registry | `cr` | Alphanumeric only, no hyphens |
| AKS Cluster | `aks` | |
| Virtual Network | `vnet` | |
| Subnet | `snet` | |
| Network Security Group | `nsg` | |
| Public IP | `pip` | |
| Load Balancer | `lb` | |
| SQL Server | `sql` | |
| SQL Database | `sqldb` | |
| Cosmos DB | `cosmos` | |
| Log Analytics Workspace | `log` | |
| Application Insights | `appi` | |
| Virtual Machine | `vm` | Max 15 chars on Windows |

## Rules

- Environment tokens: `dev`, `test`, `stage`, `prod` — never abbreviate inconsistently across a subscription.
- Region tokens: use short codes consistently (`eus`, `weu`, `neu`) across the whole estate.
- No PII, secrets, or customer names embedded in resource names.
- Respect provider-specific character/length constraints (storage/ACR/Cosmos are the most restrictive — lowercase, no hyphens).

## Tagging (pair with naming)

Apply consistently: `owner`, `service`, `environment`, `data-classification`, `cost-center`, `managed-by`, `incident-contact` (see `STANDARDS.md`).
