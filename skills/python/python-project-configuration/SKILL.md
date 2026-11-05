---
name: python-project-configuration
description: Standardize Python project config for dependencies, tooling, environments, and reproducible CI.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Python Project Configuration

## Inputs
pyproject.toml, lockfile, supported Python versions, CI matrix, formatter/linter/test settings, and deployment targets.

## Workflow
1. Identify configuration sources and conflicting settings; establish supported interpreter and dependency policy.
2. Consolidate tool config in pyproject.toml where supported; separate runtime, dev, and optional dependencies.
3. Pin reproducible application environments while defining compatible library ranges as needed.
4. Update CI to validate lock freshness and test across supported versions.

## Validation
Create clean environments, resolve/install dependencies, run lint/type/test/build, and compare artifacts to baseline.

## Rollback and safety
Avoid automatic dependency upgrades in production. Preserve prior lockfile; revert config and lock together if installs or tests fail. Never store tokens in project settings.
