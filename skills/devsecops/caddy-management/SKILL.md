---
name: caddy-management
description: Configure Caddy reverse proxy, TLS automation, routing, and safe reloads for hosted services.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Caddy Management

## Inputs
Caddyfile or JSON config, DNS ownership, upstream health endpoints, certificate issuer, and deployment topology.

## Workflow
1. Map hostnames to upstreams and trust boundaries; confirm forwarded headers and private endpoint exposure.
2. Design TLS challenge and certificate storage permissions, redirects, timeouts, and upstream health checks.
3. Validate configuration offline and test routes in staging before approved reload.
4. Monitor TLS renewal, response codes, and upstream health after rollout.

## Validation
Test certificate chain, HTTP-to-HTTPS behavior, expected/denied routes, and proxy headers from external and internal paths.

## Rollback and safety
Never expose admin API publicly or print private keys. Snapshot last-good config and reload it if cert issuance, routing, or health checks fail; require approval for production changes.
