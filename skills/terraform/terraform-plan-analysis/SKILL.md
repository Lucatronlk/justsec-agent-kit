---
name: terraform-plan-analysis
description: Analyzes Terraform plan JSON for real changes, false-positive reorders, and recreate risk when a plan is confusing or high impact.
---

# terraform-plan-analysis

## Purpose
Parse and interpret `terraform show -json` plan output to distinguish real infrastructure changes from false positives (e.g., Set-attribute reordering in `azurerm` resources) and to classify blast radius.

## When To Use
- A `terraform plan` shows a large or confusing diff.
- Before approving any plan with destroy/recreate actions.
- CI pipeline plan-review gates.

## Inputs Expected
- `terraform show -json <plan-file>` output, or the ability to generate it (`terraform plan -out=tfplan && terraform show -json tfplan`).

## Step-By-Step Process
1. Generate the JSON plan if not already available.
2. Parse `resource_changes[]`; group by `change.actions` (`create`, `update`, `delete`, `no-op`, `["delete","create"]` = recreate).
3. For any resource with only "update" actions on list/set-typed attributes (common on `azurerm_network_security_group` rules, `azurerm_application_gateway` blocks, `azurerm_lb` rules), normalize (sort) both `before` and `after` arrays and re-diff — if no delta remains, label as a **false-positive reorder**, not a real change.
4. For genuine `["delete","create"]` (recreate) actions, flag as **high blast radius** — especially for stateful resources (databases, storage accounts with data, load balancers with active connections).
5. Summarize: real changes vs false positives vs recreates, and the practical impact of each (downtime, data loss risk, cost change).

## Validation Checklist
- [ ] Plan JSON successfully parsed
- [ ] Every non-no-op resource classified (create/update/recreate/delete)
- [ ] False-positive reorders explicitly called out and excluded from "real changes" count
- [ ] Every recreate/delete action has an explicit blast-radius note

## Output Format
```markdown
## Plan Analysis: <module/PR>

### Real Changes
| Resource | Action | Notes |

### False Positives (Set/List Reordering)
| Resource | Attribute | Why it's a false positive |

### Recreate / Delete (High Blast Radius)
| Resource | Action | Impact | Recommendation |
```

## Safety Notes
- This skill is read-only analysis; it never runs `terraform apply`.
- Do not suppress a real destroy/recreate as a "false positive" without actually normalizing and re-diffing the values — never assume.

Related instructions: `instructions/terraform/terraform-review.instructions.md`
