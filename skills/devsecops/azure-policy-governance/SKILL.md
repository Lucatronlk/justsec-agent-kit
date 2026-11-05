---
name: azure-policy-governance
description: Design Azure Policy initiatives, exemptions, and remediation controls across management groups and subscriptions.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Azure Policy Governance

## Inputs
Management-group tree, policy assignments, compliance exports, approved baselines, and exemption owners.

## Workflow
1. Inventory inheritance, effects (audit, deny, modify, deployIfNotExists), scopes, and existing exemptions.
2. Map controls to initiative definitions and resource providers; assess existing-resource and deployment blast radius.
3. Draft policy-as-code with parameterized scopes, bounded exemptions, and staged audit-before-deny rollout.
4. Plan remediation identities, least privilege, review deadlines, and drift reporting.

## Validation
Test definitions against representative templates in a nonproduction subscription; compare compliance counts and false positives before enforcement.

## Rollback and safety
No production assignment or remediation without approval. Preserve assignment IDs and previous parameters; revert deny to audit if valid deployments fail. Never embed credentials in policy parameters.
