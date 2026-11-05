---
name: terraform-review
description: Reviews Terraform modules and pull requests for state safety, security, and correctness before merge or apply.
---

# terraform-review

## Purpose
Review a Terraform module or PR for state safety, security, and correctness before merge/apply.

## When To Use
Any Terraform PR, module change, or ad hoc module review request.

## Inputs Expected
- Path to the Terraform module/directory (or PR diff).
- Target cloud provider(s) (Azure/AWS/GCP) and environment (dev/stage/prod).
- Optional: existing `terraform plan` output.

## Step-By-Step Process
1. Identify changed files, modules, and providers involved.
2. Run static checks: `terraform fmt -check -recursive`, `terraform validate`, `tflint`.
3. Run security scanners: `tfsec .` and/or `checkov -d .`.
4. Generate a plan: `terraform plan -out=tfplan` (never `apply`).
5. Review the plan for unexpected destroy/recreate actions — cross-check against `skills/terraform/terraform-plan-analysis/SKILL.md` if the diff is large or involves `azurerm` Set-typed attributes.
6. Check IAM/network/encryption/secrets per `instructions/terraform/terraform-review.instructions.md`.
7. Propose the smallest safe patch for any finding.

## Validation Checklist
- [ ] `terraform fmt` clean
- [ ] `terraform validate` passes
- [ ] No unresolved `tflint` errors
- [ ] `tfsec`/`checkov` findings triaged (fixed, exception-documented, or accepted risk)
- [ ] Plan reviewed for unintended destroy/recreate
- [ ] No secrets in variables/outputs/state exposure
- [ ] Remote state backend + locking confirmed

## Output Format
- Summary
- Findings by severity (Critical/High/Medium/Low)
- Evidence (resource address, file:line, plan excerpt)
- Fix (patch)
- Validation (commands re-run)
- Rollback
- Residual risk

## Safety Notes
- Never run `terraform apply` or `terraform destroy` as part of this skill.
- Never bypass a failing security scanner without a documented, owner-approved exception.
- Treat `.tfstate` as read-only; never hand-edit it.

Related instructions: `instructions/terraform/terraform-review.instructions.md`, `instructions/terraform/terraform-general.instructions.md`
