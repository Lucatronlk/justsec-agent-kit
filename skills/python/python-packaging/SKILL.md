---
name: python-packaging
description: Package and publish Python distributions using pyproject.toml, build isolation, metadata checks, and trusted release provenance.
license: MIT
metadata:
  author: justsec-agent-kit contributors
  source: original
---

# Python Packaging

## Inputs
Package layout, pyproject.toml, supported interpreters, dependency ranges, index target, and release policy.

## Workflow
1. Define build backend, name/version, optional extras, entry points, license, and included package data.
2. Build wheel and sdist in isolated environment; inspect archives for missing files and unintended sensitive data.
3. Install artifacts into clean envs across supported Python versions; test imports and CLI entry points.
4. Stage to test index and verify metadata, hashes, and provenance before approved release.

## Validation
Run metadata validation and smoke tests from built artifacts, not only working tree; verify wheel/sdist parity.

## Rollback and safety
Do not publish without approval. Published versions are immutable: yank bad release, pin consumers to last-good version, and issue corrected increment; never include credentials in distributions.
