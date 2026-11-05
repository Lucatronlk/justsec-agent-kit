# Docker Best Practices Instructions

> Condensed from `awesome-copilot/instructions/containerization-docker-best-practices.instructions.md` (the largest Docker reference found, ~680 lines) and `skills/multi-stage-dockerfile`. Converted to generic Markdown.

## When To Use

Authoring or reviewing Dockerfiles and container build pipelines.

## Core Principles

- Immutability: rebuild, don't patch, a running container.
- Multi-stage builds: separate `builder` stage (compilers/dev deps) from a minimal `runtime` stage (only what's needed to run).
- Layer-caching order: copy dependency manifests (`package.json`, `requirements.txt`) and install dependencies **before** copying full source, so code changes don't bust the dependency-install cache layer.

## Example Multi-Stage Pattern

```dockerfile
FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-slim AS runtime
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
USER node
HEALTHCHECK CMD node healthcheck.js
CMD ["node", "dist/index.js"]
```

## Security Checklist

- Non-root `USER` directive — never run as root in the final image.
- `.dockerignore` present (exclude `.git`, `.env`, local secrets, `node_modules`, build artifacts not needed).
- Prefer distroless or minimal base images (`-slim`, `-alpine`, `gcr.io/distroless/*`) over full OS images.
- Pin base image tags to a specific version, and ideally a digest, not `latest`.
- Scan images in CI: `hadolint` (Dockerfile lint) + `trivy image` (vulnerability scan) — fail on Critical/High without an approved exception.
- Sign images for production (`cosign sign`/`cosign verify`) where a signing pipeline exists.
- Set resource limits at runtime (`--memory`, `--cpus` or Kubernetes `resources.limits`).

## Review Checklist

- [ ] Multi-stage build used where a compiler/build toolchain is needed.
- [ ] Non-root `USER` set.
- [ ] `HEALTHCHECK` defined.
- [ ] No secrets `COPY`'d or `ARG`'d into the image (build args can leak into image history — use BuildKit secrets mounts instead: `RUN --mount=type=secret`).
- [ ] Base image pinned to a specific version.
- [ ] `.dockerignore` excludes sensitive/unnecessary files.

## Validation Commands

```bash
hadolint Dockerfile
docker build -t app:test .
trivy image app:test
```

## Safety Notes

- Never bake secrets into image layers (even if deleted in a later layer, they remain in image history) — use BuildKit secret mounts or runtime injection instead.
- Never disable a Trivy/Hadolint gate to "unblock" a build without documented, approved exception.
