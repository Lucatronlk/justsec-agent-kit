---
name: dockerfile-hardening
description: Reviews Dockerfiles and image-build pipelines for hardening when container security or runtime posture is requested.
---

# dockerfile-hardening

## When To Use

Use for Dockerfiles, image build pipelines, and runtime container hardening reviews.

## Workflow

1. Review base image source, pinning, and update posture.
2. Check user context, package installs, file permissions, and secret handling.
3. Review entrypoints, health checks, exposed ports, and shell usage.
4. Verify image minimization and provenance controls.
5. Recommend minimal hardening edits.

## Validation Commands

- `hadolint <Dockerfile>`
- `docker build --no-cache --progress=plain .` only when explicitly approved

## Output Format

- Summary
- Findings by severity
- Evidence
- Patch
- Validation
- Rollback
- Residual risk
