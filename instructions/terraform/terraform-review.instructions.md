# Terraform Review Instructions

> Adapted from `awesome-copilot/agents/terraform-iac-reviewer.agent.md` and `skills/terraform-azurerm-set-diff-analyzer`. Converted to generic Markdown.

## When To Use

Reviewing a Terraform PR, module change, or `terraform plan` output before merge/apply.

## Review Checklist

### State Safety
- Does this change move/rename/delete any resource address? Confirm intended vs accidental destroy/recreate.
- Are there `for_each`/`count` changes that would shift resource indices (causing unintended destroy/recreate)?
- Is remote state locking in place (DynamoDB table / Azure blob lease / GCS)?

### Security
- New/changed IAM policies: check for wildcard actions/resources.
- New network resources: check for `0.0.0.0/0` ingress, public subnets, missing NSG/SG rules.
- Encryption: is encryption-at-rest explicitly enabled (not just "default")?
- Secrets: any secret values in variables, defaults, or outputs?

### Drift & Plan Analysis
- When reviewing `terraform show -json` plan output, distinguish **real changes** from **Set-attribute reordering false positives** (common in `azurerm` resources like App Gateway, NSG, Load Balancer, where lists are semantically unordered sets but rendered as ordered arrays).
- A generic approach: parse the plan JSON, normalize any list attribute known to be an unordered set (sort before comparing), then diff again — if no real delta remains, it's a false positive.
- Flag any `-/+` (destroy and recreate) actions distinctly from in-place updates; recreate actions carry higher blast radius (downtime, data loss for stateful resources).

### Policy-as-Code
- Are OPA/Sentinel/Conftest policies passing? Do not bypass a failing policy gate without documented, approved exception.

## Validation Commands

```bash
terraform fmt -check -recursive && terraform validate
tflint
tfsec . || checkov -d .
terraform plan -out=tfplan && terraform show -json tfplan > plan.json
```

## Output Format

- Summary
- Findings by severity (Critical/High/Medium/Low)
- Evidence (resource address + plan diff excerpt)
- Fix (smallest safe patch)
- Validation (commands above, re-run)
- Rollback
- Residual risk

## Safety Notes

- Never apply a plan that contains unexplained destroy actions.
- Never bypass a failing security scan (tfsec/checkov) without an explicit, documented exception and owner sign-off.
