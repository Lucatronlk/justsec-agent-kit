# Azure Cloud Instructions

> Adapted from `awesome-copilot` (`agents/azure-principal-architect.agent.md`, `agents/azure-policy-analyzer.agent.md`, `skills/azure-resource-health-diagnose`) and converted to generic Markdown. Copilot-specific tool call syntax removed.

## When To Use

Any Azure architecture, deployment, diagnostics, cost, or governance task.

## Principles

- Ground recommendations in the Azure Well-Architected Framework (Reliability, Security, Cost Optimization, Operational Excellence, Performance Efficiency).
- Default to **read-only** discovery (`az resource list`, `az monitor`, Resource Graph queries) before proposing changes.
- Never execute a write/delete Azure CLI operation without explicit user confirmation.
- Prefer managed identities / workload identity federation over service principals with secrets, and service principals over long-lived keys.
- Flag any resource with public network access, disabled diagnostic logging, or missing encryption-at-rest as a finding, not a silent fix.
- Multi-account/subscription governance: Management Groups, Azure Policy, subscription vending, landing zone patterns (Azure Landing Zones / CAF).

## Diagnostics Workflow (adapted from `azure-resource-health-diagnose`)

1. Identify scope (subscription / resource group / resource).
2. Pull resource health + Activity Log for the affected window.
3. Query Azure Monitor / Log Analytics (KQL) for failures:
   ```kql
   requests
   | where timestamp > ago(24h)
   | where success == false
   | summarize FailureCount=count() by resultCode, bin(timestamp, 1h)
   ```
4. Correlate with recent deployments (Activity Log `Microsoft.Resources/deployments/write`).
5. Produce a severity-classified RCA and a phased remediation plan (do not apply without approval).

## Governance / Compliance Scanning (adapted from `azure-policy-analyzer`)

- Map findings to a real control framework (NIST 800-53, Microsoft Cloud Security Benchmark, CIS Azure, ISO 27001, PCI-DSS, SOC 2) — never fabricate control IDs.
- Discover scope top-down: management group → subscription → resource group.
- Read-only by design; do not run remediation without explicit consent.

## Security Baseline

- No public storage accounts / blob containers unless explicitly justified.
- NSGs default-deny inbound; document any broad allow rule.
- Key Vault for all secrets; soft-delete + purge protection enabled.
- Diagnostic settings routed to Log Analytics / Event Hub for every production resource.
- Azure Policy assignments enforced at management group level, not per-resource ad hoc.

## Safety Notes

- Never print Key Vault secret values, connection strings, or SAS tokens in output.
- Treat subscription IDs and tenant IDs as semi-sensitive identifiers — acceptable in output, never combine with credentials.
