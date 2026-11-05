---
name: azure-architecture-review
description: Reviews Azure workload and landing-zone architecture against Well-Architected and CAF guidance when design changes are requested.
---

# azure-architecture-review

## Purpose
Review or design an Azure architecture (landing zone, workload, or resource group design) against the Azure Well-Architected Framework and CAF landing zone patterns.

## When To Use
- New Azure workload design.
- Architecture change requests (new trust boundary, new region, new integration).
- Pre-deployment architecture sanity check.

## Inputs Expected
- Architecture description, Bicep/Terraform source, or a live resource group/subscription scope to inspect (read-only).

## Step-By-Step Process
1. Identify scope: subscription(s), management group, resource groups involved.
2. Map the design against the 5 WAF pillars: Reliability, Security, Cost Optimization, Operational Excellence, Performance Efficiency.
3. Check landing zone alignment: management group hierarchy, subscription vending model, hub-spoke networking, centralized logging (Log Analytics workspace), Azure Policy assignment scope.
4. Identify single points of failure, missing redundancy (availability zones, region pairs), and scaling limits.
5. Cross-check naming (`instructions/azure/azure-naming.instructions.md`) and IaC conventions (`instructions/azure/azure-terraform.instructions.md`) if IaC is present.
6. Produce a prioritized set of findings, not just an approval/rejection.

## Validation Checklist
- [ ] Reliability: multi-AZ/multi-region where required, health checks, autoscaling defined
- [ ] Security: private networking where possible, Key Vault use, diagnostic logging enabled
- [ ] Cost: right-sized SKUs, reserved capacity considered, unused resources flagged
- [ ] Operations: monitoring/alerting defined, IaC used (not portal-only), naming/tagging consistent
- [ ] Performance: appropriate SKU/tier for expected load, caching considered where relevant

## Output Format
- Summary
- Findings by WAF pillar (with severity)
- Evidence
- Recommendation
- Residual risk

## Safety Notes
- Read-only by default — do not execute `az` write/deploy commands as part of a review.
- Never fabricate control mappings or SKU pricing; verify against current docs/pricing API if precision matters.

Related instructions: `instructions/azure/azure-cloud.instructions.md`, `instructions/azure/azure-naming.instructions.md`
