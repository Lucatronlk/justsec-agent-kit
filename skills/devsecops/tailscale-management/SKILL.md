---
name: tailscale-management
description: Govern Tailscale tailnets, ACL/grants, device posture, subnet routes, and exit-node access.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Tailscale Management

## Inputs
Tailnet policy, identity groups, device inventory, advertised routes, tag owners, and approved access paths.

## Workflow
1. Inventory devices, ephemeral keys, exit nodes, subnet routers, and existing grants.
2. Design least-privilege tags and source/destination grants; document posture checks and route approvals.
3. Test proposed policy against allowed and denied actor/resource pairs in staging or policy tests.
4. Stage tag and route changes with connectivity monitoring and owner sign-off.

## Validation
Check authorized connectivity and rejected paths from representative clients; verify DNS and route failover.

## Rollback and safety
Avoid lockout: retain independent admin access and last-good policy. Do not expose auth keys or change production grants/routes without approval; restore previous policy if critical connectivity breaks.
