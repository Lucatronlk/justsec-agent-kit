---
name: azure-iac-generation
description: Generates validated first-draft Azure Bicep, ARM, Terraform, or Pulumi when new Azure infrastructure code is requested.
---

# azure-iac-generation

## Purpose
Generate first-draft Azure infrastructure code (Bicep, ARM, Terraform, or Pulumi) from a plain-language requirement, with schema validation before code is written.

## When To Use
- User asks to generate/create/write/build infrastructure code, deployment code, or IaC templates for Azure (or explicitly multi-cloud).
- Not for reviewing existing IaC — use `skills/terraform/terraform-review/SKILL.md` or `skills/azure/azure-architecture-review/SKILL.md` for that.

## Inputs Expected
- Infrastructure requirement description (what resources, what environment, any compliance constraints).
- Preferred IaC format (ask if not specified — do not assume).

## Step-By-Step Process
1. Gather requirements: target platform (default Azure), format, environment, naming requirements (`instructions/azure/azure-naming.instructions.md`), compliance/security constraints.
2. Validate schema/best-practices against a current, authoritative source before generating (see the validation table in `instructions/azure/azure-iac-generation.instructions.md`) — never generate purely from memory.
3. Check for an existing Azure Verified Module (Bicep/Terraform) that fits before hand-rolling resources.
4. Generate modular, parameterized code with security defaults (least privilege, encryption on, no hardcoded secrets).
5. Add a parameter file for environment-specific values.
6. Add a `README.md` covering deployment instructions, parameters, and security notes.
7. Run the format's validation command (`bicep build`, `terraform validate`/`plan`, `pulumi preview`) and report the result — do not declare "done" without it.

## Validation Checklist
- [ ] Requirements confirmed (platform, format, environment) before generation
- [ ] Schema/best-practices validated against a current source, or explicitly flagged as unverified
- [ ] AVM/existing module checked before hand-rolling
- [ ] No hardcoded secrets; parameter references or Key Vault used
- [ ] Azure naming conventions applied
- [ ] README + parameter file included for non-trivial output
- [ ] Format-specific validation command run and result reported

## Output Format
- Summary (what was generated, for what requirement)
- Generated files (with brief purpose per file)
- Validation output (`bicep build`/`terraform plan`/`pulumi preview`)
- Residual risk / follow-up (e.g., "schema unverified — confirm before apply")

## Safety Notes
- This skill only drafts code — it never applies/deploys. Deployment requires the same review/approval discipline as any other IaC change.
- Flag any generated resource whose schema could not be verified against a current source.

Related instructions: `instructions/azure/azure-iac-generation.instructions.md`, `instructions/azure/azure-naming.instructions.md`, `instructions/azure/azure-terraform.instructions.md`
