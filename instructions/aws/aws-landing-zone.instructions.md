# AWS Landing Zone Instructions

> Adapted from `awesome-copilot/agents/aws-principal-architect.agent.md`. Converted to generic Markdown.

## When To Use

Multi-account AWS strategy, Control Tower/Landing Zone Accelerator design, org-wide governance.

## Core Patterns

- **AWS Organizations** with dedicated accounts: Management, Log Archive, Audit/Security, Shared Services, per-workload (dev/test/stage/prod).
- **Service Control Policies (SCPs)** as guardrails, not IAM substitutes — deny regions, deny root user actions, deny leaving org.
- **AWS Control Tower** or **Landing Zone Accelerator (LZA)** for baseline account provisioning, guardrails, and centralized logging.
- Centralize CloudTrail, Config, GuardDuty findings into the Log Archive / Audit account.
- Use AWS IAM Identity Center (SSO) for federated human access; avoid IAM users with long-lived keys.
- Account vending via Control Tower Account Factory or Account Factory for Terraform (AFT).

## Network

- Use a hub-and-spoke or Transit Gateway model for multi-VPC connectivity.
- Centralize egress via a dedicated network account (NAT Gateway, firewall).
- No direct internet access from private workload subnets except via controlled egress.

## Cost Governance

- Enable AWS Cost Explorer + Budgets at the Organization level.
- Tag enforcement via SCP or Config rules (`cost-center`, `owner`, `environment`).
- Review Reserved Instance / Savings Plan coverage quarterly.

## Zero-Trust Notes

- Every cross-account access uses IAM roles with explicit trust policies and external IDs (for third-party access) — never static cross-account keys.
- Default-deny SCP baseline, allow-list additions per OU.

## Safety Notes

- Landing zone changes are high blast-radius (affect every account) — always require plan/dry-run review and explicit human approval before applying.
- Never disable CloudTrail or Config as part of a "fix" without flagging it as a governance regression.
