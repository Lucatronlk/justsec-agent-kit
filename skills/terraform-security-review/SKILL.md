---
name: terraform-security-review
description: Reviews Terraform IAM, state, network, encryption, and provider risks when infrastructure security review is requested.
---

# terraform-security-review

## When To Use

Use for Terraform plans, modules, IAM, network, encryption, state, and provider-risk reviews.

## Workflow

1. Identify changed modules and environments.
2. Review providers, versions, backend, and state handling.
3. Check IAM scope, trust policies, network exposure, encryption, and logging.
4. Review secrets flow, variable defaults, and output exposure.
5. Propose the smallest safe patch.

## Validation Commands

- `terraform fmt -check -recursive`
- `terraform validate`
- `tflint` if available
- `tfsec` or `checkov` if available

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk
