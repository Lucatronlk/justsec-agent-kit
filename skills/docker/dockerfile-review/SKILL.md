---
name: dockerfile-review
description: Reviews Dockerfiles and image-build pipelines when container security, size, or build hygiene needs assessment.
---

# dockerfile-review

## Purpose
Review a Dockerfile and image build pipeline for security, size, and best-practice compliance.

## When To Use
- New or changed Dockerfile.
- Pre-production image build review.
- Periodic container-hygiene audit.

## Inputs Expected
- Dockerfile source, and optionally `.dockerignore` and CI build config.

## Step-By-Step Process
1. Check build structure: multi-stage build present where a compiler/build toolchain is needed; final stage minimal (distroless/-slim/-alpine).
2. Check layer order: dependency manifests copied and installed before full source copy (cache efficiency).
3. Check user: non-root `USER` directive in the final stage.
4. Check secrets: no secrets baked into `ARG`/`ENV`/`COPY` — recommend BuildKit `--mount=type=secret` or runtime injection instead.
5. Check pinning: base image pinned to a specific version/digest, not `latest`.
6. Check `.dockerignore`: excludes `.git`, `.env`, secrets, and unnecessary build context.
7. Run `hadolint Dockerfile` and `trivy image <built-tag>` if available; triage findings by severity.

## Validation Checklist
- [ ] Multi-stage build used appropriately
- [ ] Non-root `USER` set in final stage
- [ ] No secrets in image layers/history
- [ ] Base image pinned
- [ ] `.dockerignore` present and adequate
- [ ] `hadolint` clean or findings triaged
- [ ] `trivy image` Critical/High findings triaged or accepted with owner sign-off

## Output Format
- Summary
- Findings by severity
- Evidence (Dockerfile line)
- Fix (patched Dockerfile snippet)
- Validation (`hadolint`/`trivy` output)
- Residual risk

## Safety Notes
- Never recommend disabling a Trivy/Hadolint gate to unblock a build without an explicit, documented exception.
- Do not build/push images as part of this review without explicit request — review Dockerfile content statically first.

Related instructions: `instructions/docker/docker-best-practices.instructions.md`
