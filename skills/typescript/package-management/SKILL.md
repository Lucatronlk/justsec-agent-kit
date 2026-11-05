---
name: package-management
description: Govern JavaScript package manager selection, lockfile integrity, workspace resolution, and dependency updates.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Package Management

## Inputs
package.json, lockfile, package manager/version, workspace layout, registry configuration, and CI install steps.

## Workflow
1. Confirm one canonical manager and frozen-lockfile installs across local/CI environments.
2. Audit direct/transitive dependencies, lifecycle scripts, peer constraints, and registry trust.
3. Update narrowly; compare lockfile diffs and run clean install, build, test, and audit gates.
4. Document upgrade or resolution overrides with expiry and owner.

## Validation
Reproduce install from lockfile on clean supported Node versions; verify package provenance and workspace links.

## Rollback and safety
Never run untrusted install scripts with privileged tokens. Revert manifest and lockfile together if behavior regresses; require approval before publishing or switching production dependencies.
