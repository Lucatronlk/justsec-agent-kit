---
name: aws-landing-zone-review
description: Reviews AWS Organizations, Control Tower, and landing-zone governance when a multi-account AWS assessment is requested.
---

# aws-landing-zone-review

## Purpose
Review a multi-account AWS Organizations / Control Tower / Landing Zone Accelerator setup for governance, security, and cost posture.

## When To Use
- New landing zone design or account-vending review.
- Periodic governance audit of an existing multi-account estate.

## Inputs Expected
- Organization structure (accounts/OUs), SCPs, and/or Terraform/CloudFormation source for the landing zone.

## Step-By-Step Process
1. Map the account structure: Management, Log Archive, Audit/Security, Shared Services, workload OUs.
2. Review SCPs: confirm guardrails (deny leaving org, deny disabling CloudTrail/Config, region restrictions) are present and not accidentally overly permissive.
3. Confirm centralized logging: CloudTrail organization trail, Config aggregator, GuardDuty delegated admin, all routed to Log Archive/Audit account.
4. Review identity: IAM Identity Center (SSO) for human access; no IAM users with long-lived console/API keys for humans.
5. Review network: hub-and-spoke or Transit Gateway model, centralized egress, no direct-to-internet from private workload subnets.
6. Review cost governance: Cost Explorer/Budgets at org level, tag enforcement (SCP or Config rule).
7. Run the AWS Well-Architected checklist (`instructions/aws/aws-cloud.instructions.md`) against representative workload accounts.

## Validation Checklist
- [ ] SCP guardrails present and tested (not just documented)
- [ ] CloudTrail + Config + GuardDuty centralized and enabled org-wide
- [ ] No long-lived IAM user keys for human access
- [ ] Tag enforcement in place
- [ ] Network egress centralized/controlled
- [ ] Cross-account roles use external IDs where third parties are involved

## Output Format
- Summary
- Findings by severity
- Evidence
- Recommendation
- Residual risk

## Safety Notes
- Landing zone changes are high blast-radius (org-wide) — this skill is review/analysis only, never apply changes without explicit separate approval and change control.
- Never disable CloudTrail/Config/GuardDuty as part of a "fix" without flagging it as a governance regression.

Related instructions: `instructions/aws/aws-landing-zone.instructions.md`, `instructions/aws/aws-cloud.instructions.md`
