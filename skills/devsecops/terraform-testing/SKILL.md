---
name: terraform-testing
description: Build layered Terraform validation covering format, schema, module contracts, plans, and isolated integration tests.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Terraform Testing

## Inputs
Module source, provider lockfile, variable contracts, target cloud constraints, and isolated test account details.

## Workflow
1. Define assertions for outputs, security defaults, resource relationships, and negative variable cases.
2. Run format and validate checks, then terraform test or plan with mocks where provider behavior permits.
3. Test real provider behavior only in approved ephemeral accounts using bounded cost and cleanup budgets.
4. Record plan changes, test evidence, drift assumptions, and coverage gaps in CI.

## Validation
Ensure failed policy cases fail tests and outputs remain stable; compare integration plan against expected resource counts.

## Rollback and safety
Never apply to production as a test. Keep state isolated and encrypted; tear down approved ephemeral resources after verification, and retain state/backups if destroy fails for manual recovery.
