---
name: azure-identity-rbac
description: Review and design Entra ID and Azure RBAC assignments, managed identities, PIM, and access boundaries.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Azure Identity RBAC

## Inputs
Identity inventory, role assignments, scope hierarchy, service principals, PIM settings, and access requirements.

## Workflow
1. Map principals, groups, inherited roles, and effective access across management groups, subscriptions, and resources.
2. Find broad Owner/Contributor grants, stale principals, direct user grants, and unmanaged credentials.
3. Propose least-privilege custom/built-in roles, managed identities, conditional access, and time-limited elevation.
4. Define access review ownership and break-glass exceptions with expiry.

## Validation
Test allowed and denied operations with nonproduction identities; verify inherited grants and CI workload federation before removal.

## Rollback and safety
Never read credential values. Require approval and a tested break-glass path before revoking access; restore previous assignments if critical workflows fail and log the exception.
