---
name: azure-security-review
description: Audits Azure resources or IaC for security and compliance gaps when an Azure security review is requested.
---

# azure-security-review

## Purpose
Audit an Azure subscription/resource group/IaC codebase for security misconfigurations and compliance gaps.

## When To Use
- Periodic security posture review.
- Before promoting a workload to production.
- After a significant Azure resource or policy change.

## Inputs Expected
- Subscription/resource group scope, or Bicep/Terraform source for the workload.

## Step-By-Step Process
1. Discover scope top-down: management group → subscription → resource group (read-only: `az resource list`, Resource Graph).
2. Check identity: managed identities used over service principals with secrets; no long-lived keys where avoidable.
3. Check network exposure: public IPs, NSG rules allowing broad inbound, Private Endpoint usage for PaaS services.
4. Check encryption: TLS minimum version on storage/App Service, Key Vault soft-delete + purge protection, disk/data encryption.
5. Check logging: diagnostic settings routed to Log Analytics/Event Hub for every production resource; Azure Policy assignments in place.
6. Map findings to a real framework if requested (MCSB, CIS Azure, NIST 800-53) — never fabricate control IDs.
7. Produce a severity-ranked report; do not execute remediation without explicit approval.

## Validation Checklist
- [ ] No public storage accounts/containers without justification
- [ ] NSGs default-deny inbound; broad allow rules documented
- [ ] Key Vault soft-delete + purge protection enabled
- [ ] Diagnostic settings enabled on all production resources
- [ ] No secrets in ARM/Bicep/Terraform outputs or App Service app settings (should reference Key Vault)
- [ ] Azure Policy assigned at appropriate scope, not per-resource ad hoc

## Output Format
- Summary
- Findings by severity, mapped to framework control where applicable
- Evidence
- Fix
- Validation
- Residual risk

## Safety Notes
- Read-only by design — never execute Azure write/delete operations as part of this skill.
- Never print Key Vault secret values, connection strings, or SAS tokens.

Related instructions: `instructions/azure/azure-cloud.instructions.md`, `instructions/security/owasp-security.instructions.md`
